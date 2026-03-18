#!/bin/bash

# Tool Information
TOOL_NAME="Vedan-Bug Bounty Toolkit"
VERSION="1.0"
AUTHOR="Ved Kumar"
CONTACT_EMAIL="devkumarmahto204@outlook.com"
GITHUB_REPO="https://github.com/devkumar-swipe/vedan"
BANNER="============================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Output directory
OUTPUT_DIR="$HOME/vedan"
LOG_FILE="$OUTPUT_DIR/bug_bounty_tool.log"

# Function to display the header
header() {
  echo -e "${GREEN}$BANNER"
  echo -e "${BLUE}$TOOL_NAME"
  echo -e "${YELLOW}Version: $VERSION"
  echo -e "Author: $AUTHOR"
  echo -e "Contact: $CONTACT_EMAIL"
  echo -e "GitHub: $GITHUB_REPO"
  echo -e "${GREEN}$BANNER${NC}"
}

# Function to log messages
log() {
  local message="$1"
  echo -e "${BLUE}[*]${NC} $message" | tee -a "$LOG_FILE"
}

# Function to log errors
error() {
  local message="$1"
  echo -e "${RED}[!]${NC} $message" | tee -a "$LOG_FILE"
  exit 1
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install dependencies
install_dependencies() {
  log "Installing required dependencies..."

  # Update system
  sudo apt update -y && sudo apt install -y subfinder amass

  # Install Go if not found
  if ! command_exists go; then
    log "Installing Go..."
    sudo apt install -y golang
  fi

  # Set Go environment path
  export PATH=$PATH:$(go env GOPATH)/bin
  echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
  source ~/.bashrc

  # Install required Go tools
  go install github.com/tomnomnom/httprobe@latest
  go install github.com/tomnomnom/waybackurls@latest
  go install github.com/Emoe/kxss@latest

  # Install filter-resolved manually
  go install github.com/tomnomnom/assetfinder@latest
  if ! command_exists filter-resolved; then
    log "Manually setting up filter-resolved..."
    cd $(go env GOPATH)/src/github.com/tomnomnom/assetfinder
    go build -o $GOPATH/bin/filter-resolved filter-resolved.go
    cd -
  fi

  log "All dependencies installed successfully!"
}

# Function to create output directory
create_output_dir() {
  [[ ! -d "$OUTPUT_DIR" ]] && mkdir -p "$OUTPUT_DIR"
}

# Function to validate domain format
validate_domain() {
  local domain="$1"
  if [[ ! "$domain" =~ ^([a-zA-Z0-9][a-zA-Z0-9-]*\.)+[a-zA-Z]{2,}$ ]]; then
    error "Invalid domain format. Use a valid domain (e.g., example.com)."
  fi
}

# Function to run the tool
run_tool() {
  local domain="$1"
  local subfinder_output="$OUTPUT_DIR/domains_subfinder_$domain.txt"
  local amass_output="$OUTPUT_DIR/domains_$domain.txt"
  local resolved_output="$OUTPUT_DIR/domains_$domain_resolved.txt"
  local xss_output="$OUTPUT_DIR/xss_$domain.txt"

  log "Scanning domain: $domain"

  # Run subfinder
  log "Running subfinder..."
  subfinder -d "$domain" -o "$subfinder_output"

  # Run amass
  log "Running amass..."
  amass enum --passive -d "$domain" -o "$amass_output"

  # Combine results
  log "Combining results..."
  cat "$subfinder_output" >> "$amass_output"

  # Filter resolved domains
  log "Filtering resolved domains..."
  cat "$amass_output" | filter-resolved > "$resolved_output"

  # Run httprobe, waybackurls, and kxss
  log "Running httprobe, waybackurls, and kxss..."
  cat "$resolved_output" | httprobe -p http:81 -p http:8080 -p https:8443 | waybackurls | kxss > "$xss_output"

  log "Scan completed. Results saved in $xss_output"
}

# Main script
main() {
  header

  # Install dependencies if needed
  install_dependencies

  # Parse arguments
  if [[ $# -eq 0 ]]; then
    log "No arguments provided. Use -h for help."
    exit 1
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -d|--domain)
        DOMAIN="$2"
        shift 2
        ;;
      -h|--help)
        echo -e "${YELLOW}Usage: ./vedan.sh -d <domain>${NC}"
        exit 0
        ;;
      *)
        error "Invalid argument: $1"
        ;;
    esac
  done

  # Check domain
  [[ -z "$DOMAIN" ]] && error "Domain not provided! Use -d <domain>."

  validate_domain "$DOMAIN"
  create_output_dir
  run_tool "$DOMAIN"
}

# Execute the script
main "$@"
