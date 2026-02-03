#!/bin/sh

# Color Var
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'


printf "${BLUE}updating apt...${NC}\n"
sudo apt update  # To get the latest package lists

# Check if Git is already installed
if ! command -v git >/dev/null 2>&1; then
  printf "${BLUE}Installing Git...${NC}\n"
  sudo apt install git -y
  printf "${GREEN}Git installed successfully.${NC}\n"
else
  printf "${GREEN}Git is already installed.${NC}\n"
fi

# Check if Docker is already installed
if ! command -v docker >/dev/null 2>&1; then
  printf "${BLUE}Installing Docker...${NC}\n"
  sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io -y
  sudo usermod -aG docker $USER
  printf "${GREEN}Docker installed successfully.${NC}\n"
else
  printf "${GREEN}Docker is already installed.${NC}\n"
fi


# Ask if the user wants to install direnv
read -p "Do you want to install direnv? (y/N): " direnv_choice
direnv_choice=${direnv_choice:-n}
if [ "$direnv_choice" = "y" ] || [ "$direnv_choice" = "Y" ]; then
  if ! command -v direnv >/dev/null 2>&1; then
    printf "${BLUE}Installing direnv...${NC}\n"
    sudo apt install direnv -y
    printf "${GREEN}direnv installed successfully.${NC}\n"
  else
    printf "${GREEN}direnv is already installed.${NC}\n"
  fi
else
  printf "${YELLOW}Skipping direnv installation.${NC}\n"
fi

# Ask if the user wants to install Nix
read -p "Do you want to install Nix? (y/N): " nix_choice
nix_choice=${nix_choice:-n}
if [ "$nix_choice" = "y" ] || [ "$nix_choice" = "Y" ]; then
  if ! command -v nix >/dev/null 2>&1; then
    printf "${BLUE}Installing Nix...${NC}\n"
    curl -L --fail https://nixos.org/nix/install -o /tmp/nix-install.sh && sh /tmp/nix-install.sh --daemon
    printf "${GREEN}Nix installed successfully.${NC}\n"
  else
    printf "${GREEN}Nix is already installed.${NC}\n"
  fi
else
  printf "${YELLOW}Skipping Nix installation.${NC}\n"
fi


# Ask if the user wants to install Devenv
read -p "Do you want to install Devenv? (y/N): " devenv_choice
devenv_choice=${devenv_choice:-n}
if [ "$devenv_choice" = "y" ] || [ "$devenv_choice" = "Y" ]; then
  if ! command -v devenv >/dev/null 2>&1; then
    if command -v nix >/dev/null 2>&1; then
      printf "${BLUE}Installing Devenv...${NC}\n"
      nix-env --install --attr devenv -f https://github.com/NixOS/nixpkgs/tarball/nixpkgs-unstable
      printf "${GREEN}Devenv installed successfully.${NC}\n"
    else
      printf "${RED}Nix is required to install Devenv. Please install Nix first.${NC}\n"
    fi
  else
    printf "${GREEN}Devenv is already installed.${NC}\n"
  fi
else
  printf "${YELLOW}Skipping Devenv installation.${NC}\n"
fi

# Ask if the user wants to install NVM (Node Version Manager)
read -p "Do you want to install NVM (Node Version Manager)? (y/N): " nvm_choice
nvm_choice=${nvm_choice:-n}
if [ "$nvm_choice" = "y" ] || [ "$nvm_choice" = "Y" ]; then
  if [ ! -d "$HOME/.nvm" ]; then
    printf "${BLUE}Installing NVM...${NC}\n"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    printf "${GREEN}NVM installed successfully.${NC}\n"
  else
    printf "${GREEN}NVM is already installed.${NC}\n"
  fi
else
  printf "${YELLOW}Skipping NVM installation.${NC}\n"
fi

# Check if Starship is already installed
if ! command -v starship >/dev/null 2>&1; then
  printf "${BLUE}Installing Starship...${NC}\n"
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  printf "${GREEN}Starship installed successfully.${NC}\n"
else
  printf "${GREEN}Starship is already installed.${NC}\n"
fi

# Setup Starship configuration
STARSHIP_CONFIG_DIR="$HOME/.config/starship"
STARSHIP_CONFIG_FILE="$STARSHIP_CONFIG_DIR/starship.toml"

if [ ! -d "$STARSHIP_CONFIG_DIR" ]; then
  mkdir -p "$STARSHIP_CONFIG_DIR"
  printf "${BLUE}Created Starship config directory.${NC}\n"
fi

if [ ! -f "$STARSHIP_CONFIG_FILE" ]; then
  cat <<EOF > "$STARSHIP_CONFIG_FILE"
# Starship Configuration
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"

[git_branch]
symbol = " "

[git_status]
stashed = "[📦](bold blue) "
ahead = "[⇡](bold green) "
behind = "[⇣](bold red) "
diverged = "[⇕](bold purple) "
untracked = "[?](bold yellow) "
modified = "[!](bold red) "
staged = "[+](bold green) "
conflicted = "[=](bold red) "

[package]
symbol = "📦 "
EOF
  printf "${GREEN}Starship config file created successfully.${NC}\n"
else
  printf "${GREEN}Starship config file already exists.${NC}\n"
fi

# Check if Nerd Font 'MesloLGS' is already installed
read -p "Do you want to install Nerd Font 'MesloLGS'? (y/N): " font_choice
font_choice=${font_choice:-n}
if [ "$font_choice" = "Y" ] || [ "$font_choice" = "y" ]; then
  if ! fc-list | grep -i "MesloLGS" >/dev/null 2>&1; then
    printf "${BLUE}Installing Nerd Font 'MesloLGS'...${NC}\n"
    mkdir -p ~/.local/share/fonts
    curl -fLo "~/.local/share/fonts/MesloLGS NF Regular.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/MesloLGS/Regular/complete/MesloLGS%20NF%20Regular.ttf
    curl -fLo "~/.local/share/fonts/MesloLGS NF Bold.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/MesloLGS/Bold/complete/MesloLGS%20NF%20Bold.ttf
    curl -fLo "~/.local/share/fonts/MesloLGS NF Italic.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/MesloLGS/Italic/complete/MesloLGS%20NF%20Italic.ttf
    curl -fLo "~/.local/share/fonts/MesloLGS NF Bold Italic.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/MesloLGS/BoldItalic/complete/MesloLGS%20NF%20Bold%20Italic.ttf
    fc-cache -fv
    printf "${GREEN}Nerd Font 'MesloLGS' installed successfully.${NC}\n"
  else
    printf "${GREEN}Nerd Font 'MesloLGS' is already installed.${NC}\n"
  fi
else
  printf "${YELLOW}Skipping Nerd Font 'MesloLGS' installation.${NC}\n"
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
read -p "Do you want to install Warp Terminal? (y/N): " warp_choice
warp_choice=${warp_choice:-n}
if [ "$warp_choice" = "y" ] || [ "$warp_choice" = "Y" ]; then
  if ! command -v warp-terminal >/dev/null 2>&1; then
    printf "${BLUE}Installing Warp Terminal...${NC}\n"
    sudo apt-get install wget gpg -y
    wget -qO- https://releases.warp.dev/linux/keys/warp.asc | gpg --dearmor > warpdotdev.gpg
    sudo install -D -o root -g root -m 644 warpdotdev.gpg /etc/apt/keyrings/warpdotdev.gpg
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" > /etc/apt/sources.list.d/warpdotdev.list'
    rm warpdotdev.gpg
    sudo apt update && sudo apt install warp-terminal -y
    printf "${GREEN}Warp Terminal installed successfully.${NC}\n"
  else
    printf "${GREEN}Warp Terminal is already installed.${NC}\n"
  fi
else
  printf "${YELLOW}Skipping Warp Terminal installation.${NC}\n"
fi

# Ask if the user wants to install VS Code
read -p "Do you want to install Visual Studio Code? (y/N): " vscode_choice
vscode_choice=${vscode_choice:-n}
if [ "$vscode_choice" = "y" ] || [ "$vscode_choice" = "Y" ]; then
  if ! command -v code >/dev/null 2>&1; then
    printf "${BLUE}Installing Visual Studio Code...${NC}\n"
    sudo apt-get install wget gpg -y
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt update && sudo apt install code -y
    printf "${GREEN}Visual Studio Code installed successfully.${NC}\n"
  else
    printf "${GREEN}Visual Studio Code is already installed.${NC}\n"
  fi
else
  printf "${YELLOW}Skipping Visual Studio Code installation.${NC}\n"
fi

# Ask if the user wants to install antigravity (Python easter egg package)
read -p "Do you want to install antigravity? (y/N): " antigravity_choice
antigravity_choice=${antigravity_choice:-n}
if [ "$antigravity_choice" = "y" ] || [ "$antigravity_choice" = "Y" ]; then
  if ! command -v python3 >/dev/null 2>&1; then
    printf "${BLUE}Installing Python3 first...${NC}\n"
    sudo apt install python3 -y
  fi
  
  if command -v python3 >/dev/null 2>&1; then
    printf "${GREEN}antigravity is a built-in Python easter egg module.${NC}\n"
    printf "${YELLOW}You can use it with: python3 -c \"import antigravity\"${NC}\n"
  else
    printf "${RED}Python3 is not available. Cannot use antigravity.${NC}\n"
  fi
else
  printf "${YELLOW}Skipping antigravity installation.${NC}\n"
fi

# Check GitHub SSH connection
printf "${BLUE}Checking GitHub SSH connection...${NC}\n"
if ssh -T git@github.com -o StrictHostKeyChecking=accept-new 2>&1 | grep -q "successfully authenticated"; then
  printf "${GREEN}GitHub SSH connection is working!${NC}\n"
else
  printf "${YELLOW}GitHub SSH connection failed or not configured.${NC}\n"
  printf "${YELLOW}You may need to set up SSH keys for GitHub.${NC}\n"
  printf "${YELLOW}Visit: https://docs.github.com/en/authentication/connecting-to-github-with-ssh${NC}\n"
fi

# Reload bash if needed
BASHRC_MODIFIED=false
if [ -f "$HOME/.bashrc" ]; then
  # Check if direnv hook is in bashrc
  if [ "$direnv_choice" = "y" ] || [ "$direnv_choice" = "Y" ]; then
    if ! grep -q 'eval "$(direnv hook bash)"' "$HOME/.bashrc"; then
      echo '' >> "$HOME/.bashrc"
      echo '# Added by setup.sh' >> "$HOME/.bashrc"
      echo 'eval "$(direnv hook bash)"' >> "$HOME/.bashrc"
      BASHRC_MODIFIED=true
      printf "${GREEN}Added direnv hook to ~/.bashrc${NC}\n"
    fi
  fi
  
  # Check if NVM is in bashrc
  if [ "$nvm_choice" = "y" ] || [ "$nvm_choice" = "Y" ]; then
    if ! grep -q 'export NVM_DIR=' "$HOME/.bashrc"; then
      echo '' >> "$HOME/.bashrc"
      echo '# Added by setup.sh' >> "$HOME/.bashrc"
      echo 'export NVM_DIR="$HOME/.nvm"' >> "$HOME/.bashrc"
      echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> "$HOME/.bashrc"
      echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> "$HOME/.bashrc"
      BASHRC_MODIFIED=true
      printf "${GREEN}Added NVM initialization to ~/.bashrc${NC}\n"
    fi
  fi
  
  # Check if starship is in bashrc
  if ! grep -q 'eval "$(starship init bash)"' "$HOME/.bashrc"; then
    echo '' >> "$HOME/.bashrc"
    echo '# Added by setup.sh' >> "$HOME/.bashrc"
    echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
    BASHRC_MODIFIED=true
    printf "${GREEN}Added starship init to ~/.bashrc${NC}\n"
  fi
  
  if [ "$BASHRC_MODIFIED" = true ]; then
    printf "${BLUE}~/.bashrc has been updated.${NC}\n"
    printf "${YELLOW}Please run 'source ~/.bashrc' or restart your terminal to apply changes.${NC}\n"
  fi
fi

printf "${GREEN}Setup completed!${NC}\n"
