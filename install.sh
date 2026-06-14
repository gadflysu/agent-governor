#!/usr/bin/env bash
set -e

# Agent Governor Installation Script
# Deploys AGENTS.md to AI coding agent platforms

# Color codes
COLOR_GREEN='\033[32m'
COLOR_RED='\033[31m'
COLOR_YELLOW='\033[33m'
COLOR_BLUE='\033[34m'
COLOR_RESET='\033[0m'

# Configuration
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_MD="$DOTFILES/AGENTS.md"
BACKUP_BASE="$HOME/.agent_governor_backup"
BACKUP_DIR="$BACKUP_BASE/$(date +%Y%m%d_%H%M%S)"

# Platform definitions: [config_dir]=target_filename
declare -A PLATFORMS=(
	["$HOME/.claude"]="CLAUDE.md"
	["$HOME/.codex"]="AGENTS.md"
	["$HOME/.gemini"]="GEMINI.md"
)

# Parse command line arguments
MODE="install"
DRY_RUN=0
USE_HARD=1

show_usage() {
	cat <<-EOF
	Usage: $0 [OPTIONS]

	Options:
	  (none)                Install AGENTS.md to all platforms (default)
	  -d, --dry-run         Preview installation without making changes
	  -v, --verify          Verify all links are correct
	  -u, --uninstall       Remove all links
	  --hard                Use hard links instead of symlinks (default)
	  -s, --symlink         Use symlinks instead of hard links
	  -h, --help            Show this help message

	Supported platforms:
	  Claude Code           ~/.claude/CLAUDE.md
	  Codex                 ~/.codex/AGENTS.md
	  Gemini CLI            ~/.gemini/GEMINI.md

	Examples:
	  $0                             # Install to all platforms
	  $0 --dry-run                   # Preview changes
	  $0 --verify                    # Verify links
	  $0 --uninstall                 # Remove all links
	  $0 --hard                      # Use hard links (default)
	  $0 --symlink                   # Use symlinks
	EOF
}

# Parse all arguments
while [[ $# -gt 0 ]]; do
	case "$1" in
		-d|--dry-run)
			DRY_RUN=1
			shift
			;;
		-v|--verify)
			MODE="verify"
			shift
			;;
		-u|--uninstall)
			MODE="uninstall"
			shift
			;;
		--hard)
			USE_HARD=1
			shift
			;;
		-s|--symlink)
			USE_HARD=0
			shift
			;;
		-h|--help)
			show_usage
			exit 0
			;;
		*)
			echo "Error: Unknown option '$1'" >&2
			show_usage
			exit 1
			;;
	esac
done

# Check if source file exists
check_source() {
	if [ ! -f "$AGENTS_MD" ]; then
		echo -e "${COLOR_RED}Error: AGENTS.md not found at $AGENTS_MD${COLOR_RESET}" >&2
		exit 1
	fi
}

# Backup existing file
backup_file() {
	local dest="$1"
	local rel_path="${dest#"$HOME"/}"
	local backup_path="$BACKUP_DIR/$rel_path"

	if [ -e "$dest" ] || [ -L "$dest" ]; then
		if [ "$DRY_RUN" -eq 1 ]; then
			echo -e "${COLOR_BLUE}[DRY RUN]${COLOR_RESET} Would back up $dest to $backup_path"
		else
			echo "Backing up $dest to $backup_path"
			mkdir -p "$BACKUP_BASE"
			mkdir -p "$(dirname "$backup_path")"
			mv "$dest" "$backup_path"
		fi
	fi
}

# Create link (symlink or hard link)
create_link() {
	local src="$1"
	local dest="$2"

	# Create directory if needed
	mkdir -p "$(dirname "$dest")"

	if [ "$DRY_RUN" -eq 1 ]; then
		if [ "$USE_HARD" -eq 1 ]; then
			echo -e "${COLOR_BLUE}[DRY RUN]${COLOR_RESET} Would hard link $src => $dest"
		else
			echo -e "${COLOR_BLUE}[DRY RUN]${COLOR_RESET} Would symlink $src -> $dest"
		fi
	else
		if [ "$USE_HARD" -eq 1 ]; then
			echo "Hard linking $src => $dest"
			ln "$src" "$dest"
		else
			echo "Symlinking $src -> $dest"
			ln -s "$src" "$dest"
		fi
	fi
}

# Check if link is correct
check_link() {
	local src="$1"
	local dest="$2"
	local platform="$3"

	if [ ! -e "$src" ]; then
		echo -e "${COLOR_YELLOW}[WARN]${COLOR_RESET} Source missing: $src"
		return 1
	fi

	if [ "$USE_HARD" -eq 1 ]; then
		# Hard link check
		if [ -L "$dest" ]; then
			echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $dest is a symlink (expected hard link)"
			return 1
		elif [ -f "$dest" ]; then
			local si di
			si="$(stat --printf="%i" "$src" 2>/dev/null || stat -f"%i" "$src" 2>/dev/null)"
			di="$(stat --printf="%i" "$dest" 2>/dev/null || stat -f"%i" "$dest" 2>/dev/null)"
			if [ "$si" == "$di" ]; then
				echo -e "${COLOR_GREEN}[OK]${COLOR_RESET} $dest => $src (hard link)"
				return 0
			else
				echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $dest not hard linked to $src"
				return 1
			fi
		else
			echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $dest does not exist"
			return 1
		fi
	else
		# Symlink check
		if [ -L "$dest" ]; then
			local link_target
			link_target="$(readlink "$dest")"
			if [ "$link_target" == "$src" ]; then
				echo -e "${COLOR_GREEN}[OK]${COLOR_RESET} $dest -> $src (symlink)"
				return 0
			else
				echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $dest -> $link_target (expected: $src)"
				return 1
			fi
		elif [ -e "$dest" ]; then
			echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $dest exists but is not a symlink"
			return 1
		else
			echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $dest does not exist"
			return 1
		fi
	fi
}

# Remove link
remove_link() {
	local src="$1"
	local dest="$2"
	local platform="$3"

	if [ "$USE_HARD" -eq 1 ]; then
		# Hard link removal
		if [ -f "$dest" ] && [ ! -L "$dest" ]; then
			local si di
			si="$(stat --printf="%i" "$src" 2>/dev/null || stat -f"%i" "$src" 2>/dev/null)"
			di="$(stat --printf="%i" "$dest" 2>/dev/null || stat -f"%i" "$dest" 2>/dev/null)"
			if [ "$si" == "$di" ]; then
				echo "Removing hard link: $dest"
				rm -f "$dest"
				return 0
			fi
		fi
		echo "Skipping $dest (not a hard link to $src)"
		return 1
	else
		# Symlink removal
		if [ -L "$dest" ]; then
			local link_target
			link_target="$(readlink "$dest")"
			if [ "$link_target" == "$src" ]; then
				echo "Removing symlink: $dest"
				rm "$dest"
				return 0
			else
				echo "Skipping $dest (points to $link_target, not $src)"
				return 1
			fi
		elif [ -e "$dest" ]; then
			echo "Skipping $dest (not a symlink)"
			return 1
		fi
	fi
	return 1
}

# Install to all platforms
install_all() {
	echo "Installing Agent Governor..."
	echo "Source: $AGENTS_MD"
	echo "Link type: $([ "$USE_HARD" -eq 1 ] && echo "hard link" || echo "symlink")"
	echo ""

	local installed=0
	local skipped=0

	for config_dir in "${!PLATFORMS[@]}"; do
		local target_file="${PLATFORMS[$config_dir]}"
		local dest="$config_dir/$target_file"
		local platform
		platform=$(basename "$config_dir")

		# Check if platform config directory exists
		if [ ! -d "$config_dir" ]; then
			echo -e "${COLOR_YELLOW}[SKIP]${COLOR_RESET} $platform: config directory not found ($config_dir)"
			skipped=$((skipped+1))
			continue
		fi

		echo "Processing $platform..."

		# Check if already correctly linked
		if [ "$USE_HARD" -eq 1 ]; then
			if [ -f "$dest" ] && [ ! -L "$dest" ]; then
				local si di
				si="$(stat --printf="%i" "$AGENTS_MD" 2>/dev/null || stat -f"%i" "$AGENTS_MD" 2>/dev/null)"
				di="$(stat --printf="%i" "$dest" 2>/dev/null || stat -f"%i" "$dest" 2>/dev/null)"
				if [ "$si" == "$di" ]; then
					echo "  Skipping $dest: Already hard linked."
					installed=$((installed+1))
					continue
				fi
			fi
		else
			if [ -L "$dest" ] && [ "$(readlink "$dest")" == "$AGENTS_MD" ]; then
				echo "  Skipping $dest: Already linked."
				installed=$((installed+1))
				continue
			fi
		fi

		# Backup existing file
		backup_file "$dest"

		# Create link
		create_link "$AGENTS_MD" "$dest"
		installed=$((installed+1))
	done

	echo ""
	echo "Installation complete: $installed platforms configured, $skipped skipped."
	if [ -d "$BACKUP_DIR" ]; then
		echo "Backups saved to: $BACKUP_DIR"
	fi
}

# Verify all links
verify_all() {
	echo "Verifying Agent Governor links..."
	echo ""

	local checked=0
	local ok=0
	local errors=0

	for config_dir in "${!PLATFORMS[@]}"; do
		local target_file="${PLATFORMS[$config_dir]}"
		local dest="$config_dir/$target_file"
		local platform
		platform=$(basename "$config_dir")

		# Skip if platform not installed
		if [ ! -d "$config_dir" ]; then
			continue
		fi

		checked=$((checked+1))
		if check_link "$AGENTS_MD" "$dest" "$platform"; then
			ok=$((ok+1))
		else
			errors=$((errors+1))
		fi
	done

	echo ""
	echo "Summary: $checked checked, $ok ok, $errors errors"
	return $errors
}

# Uninstall all links
uninstall_all() {
	echo "Uninstalling Agent Governor..."
	echo ""

	local uninstalled=0

	for config_dir in "${!PLATFORMS[@]}"; do
		local target_file="${PLATFORMS[$config_dir]}"
		local dest="$config_dir/$target_file"
		local platform
		platform=$(basename "$config_dir")

		# Skip if platform not installed
		if [ ! -d "$config_dir" ]; then
			continue
		fi

		if remove_link "$AGENTS_MD" "$dest" "$platform"; then
			uninstalled=$((uninstalled+1))
		fi
	done

	echo ""
	echo "$uninstalled links removed."
	echo ""

	# Show backup info
	if [ -d "$BACKUP_BASE" ]; then
		local -a backups=()
		mapfile -t backups < <(ls -dt "$BACKUP_BASE/"* 2>/dev/null)
		if [ ${#backups[@]} -gt 0 ]; then
			echo "Backups available in: $BACKUP_BASE"
			echo "To restore, manually copy files from backup directories."
		fi
	fi
}

# Main execution
check_source

case "$MODE" in
	verify)
		verify_all
		exit $?
		;;
	uninstall)
		uninstall_all
		exit 0
		;;
	install)
		if [ "$DRY_RUN" -eq 1 ]; then
			echo "=== DRY RUN MODE: No changes will be made ==="
			echo ""
		fi
		install_all
		;;
esac
