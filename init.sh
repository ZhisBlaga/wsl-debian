#!/usr/bin/bash
# --- Colors & Formatting ---
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'


# Print a section with colored title
function print_section() {
  echo -e "\n${CYAN}${BOLD}$1${RESET}"
}

# Основные пакеты
print_section "Установка пакетов"
sudo apt update -qq
sudo apt install -qq -y apt-transport-https ca-certificates curl gpg htop vim git zsh

# Kubectl
print_section "Добавление k8s репы и установка kubectl"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update -qq
sudo apt install -qq -y kubectl

# Ansible
print_section "Установка ansible"
sudo apt install -qq -y ansible

# Oh my zsh
print_section "Установка oh-my-zsh"
if [ -d "~/.oh-my-zsh" ]; then
 sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
 echo "Oh my zsh уже установлен"
fi
sed -i.bak 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' ~/.zshrc
sed -i.bak 's/^plugins=.*/plugins=(git kubectl)/' ~/.zshrc
