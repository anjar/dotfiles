#!/bin/sh

# Color Var
GREEN='\033[0;32m'
BLUE='\033[0;34m'


printf "${BLUE}updating apt...${NC} $*\n"
sudo apt update  # To get the latest package lists

# Check if Git is already installed
if ! command -v git >/dev/null 2>&1; then
  printf "${BLUE}Installing Git...${NC} $*\n"
  sudo apt install git -y
  printf "${GREEN}Git installed successfully.${NC} $*\n"
else
  printf "${GREEN}Git is already installed.${NC} $*\n"
fi

# Check if Docker is already installed
if ! command -v docker >/dev/null 2>&1; then
  printf "${BLUE}Installing Docker...${NC} $*\n"
  sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io -y
  sudo usermod -aG docker $USER
  printf "${GREEN}Docker installed successfully.${NC} $*\n"
else
  printf "${GREEN}Docker is already installed.${NC} $*\n"
fi


# Check if direnv is already installed
if ! command -v direnv >/dev/null 2>&1; then
  printf "${BLUE}Installing direnv...${NC} $*\n"
  sudo apt install direnv -y
  printf "${GREEN}direnv installed successfully.${NC} $*\n"
else
  printf "${GREEN}direnv is already installed.${NC} $*\n"
fi

# Check if Nix is already installed
if ! command -v nix >/dev/null 2>&1; then
  printf "${BLUE}Installing Nix...${NC} $*\n"
  curl -L --fail https://nixos.org/nix/install -o /tmp/nix-install.sh && sh /tmp/nix-install.sh --daemon
else
  printf "${GREEN}Nix is already installed.${NC} $*\n"
fi


# Check if Devenv is already installed
if ! command -v devenv >/dev/null 2>&1; then
  printf "${BLUE}Installing Devenv...${NC} $*\n"
  nix-env --install --attr devenv -f https://github.com/NixOS/nixpkgs/tarball/nixpkgs-unstable
  printf "${GREEN}Devenv installed successfully.${NC} $*\n"
else
  printf "${GREEN}Devenv is already installed.${NC} $*\n"
fi

# Check if Starship is already installed
if ! command -v starship >/dev/null 2>&1; then
  printf "${BLUE}Installing Starship...${NC} $*\n"
  curl -fsSL https://starship.rs/install.sh | bash -s -- -y
  printf "${GREEN}Starship installed successfully.${NC} $*\n"
else
  printf "${GREEN}Starship is already installed.${NC} $*\n"
fi

# Check if Nerd Font 'MesloLGS' is already installed
read -p "Do you want to install Nerd Font 'MesloLGS'? (Y/n): " font_choice
if [ "$font_choice" = "Y" ] || [ "$font_choice" = "y" ] || [ -z "$font_choice" ]; then
  if ! fc-list | grep -i "MesloLGS" >/dev/null 2>&1; then
    printf "${BLUE}Installing Nerd Font 'MesloLGS'...${NC} $*\n"
    mkdir -p ~/.local/share/fonts
    curl -fLo "~/.local/share/fonts/MesloLGS NF Regular.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/MesloLGS/Regular/complete/MesloLGS%20NF%20Regular.ttf
    curl -fLo "~/.local/share/fonts/MesloLGS NF Bold.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/MesloLGS/Bold/complete/MesloLGS%20NF%20Bold.ttf
    curl -fLo "~/.local/share/fonts/MesloLGS NF Italic.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/MesloLGS/Italic/complete/MesloLGS%20NF%20Italic.ttf
    curl -fLo "~/.local/share/fonts/MesloLGS NF Bold Italic.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/MesloLGS/BoldItalic/complete/MesloLGS%20NF%20Bold%20Italic.ttf
    fc-cache -fv
    printf "${GREEN}Nerd Font 'MesloLGS' installed successfully.${NC} $*\n"
  else
    printf "${GREEN}Nerd Font 'MesloLGS' is already installed.${NC} $*\n"
  fi
else
  printf "${YELLOW}Skipping Nerd Font 'MesloLGS' installation.${NC} $*\n"
fi



# Check if the script is running in a bash shell
# if [ -z "$BASH_VERSION" ]; then
#   if [ -f "./.bashrc" ]; then
#     printf "${BLUE}Appending ./.bashrc content to ~/.bashrc...${NC} $*\n"
#     cat ./.bashrc >> ~/.bashrc
#     printf "${GREEN}.bashrc content appended successfully.${NC} $*\n"
#     # Reload bash shell to apply changes
#     # printf "${BLUE}Reloading bash shell to apply changes...${NC} $*\n"
#     # exec bash
#   else
#     printf "${RED}./.bashrc file not found. Skipping append.${NC} $*\n"
#   fi
  
# fi

# Ask if the user wants to install Warp Terminal
read -p "Do you want to install Warp Terminal? (Y/n): " choice
case "$choice" in
  [Yy]* )
    printf "${BLUE}Installing Warp Terminal...${NC} $*\n"
    sudo apt-get install wget gpg
    wget -qO- https://releases.warp.dev/linux/keys/warp.asc | gpg --dearmor > warpdotdev.gpg
    sudo install -D -o root -g root -m 644 warpdotdev.gpg /etc/apt/keyrings/warpdotdev.gpg
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" > /etc/apt/sources.list.d/warpdotdev.list'
    rm warpdotdev.gpg
    sudo apt update && sudo apt install warp-terminal
    ;;
  [Nn]* )
    printf "${YELLOW}Skipping Warp Terminal installation.${NC} $*\n"
    ;;
  * )
    printf "${RED}Invalid input. Skipping Warp Terminal installation.${NC} $*\n"
    ;;
esac
