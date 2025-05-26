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
sudo apt install -qq -y apt-transport-https ca-certificates curl gpg htop vim git zsh unzip

# Kubectl
print_section "Добавление k8s репы и установка kubectl"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update -qq
sudo apt install -qq -y kubectl

# Установка vault
print_section "Установка vault"
if command -v vault &> /dev/null; then
    echo "✅ Vault установлен. Версия: $(vault --version)"
else
    echo "❌ Vault не найден в системе."
    wget https://mirror.yandex.ru/mirrors/releases.hashicorp.com/vault/1.9.9/vault_1.9.9_linux_amd64.zip -O /tmp/vault.zip
    sudo rm -rf /tmp/vault
    unzip /tmp/vault.zip -d /tmp/vault
    sudo rm -rf /usr/local/bin/vault
    sudo mv /tmp/vault /usr/local/bin/
    vault --version
fi


# Установка terraform
print_section "Установка terraform"
if command -v terraform &> /dev/null; then
    echo "✅ Terraform установлен. Версия: $(terraform --version)"
else
    echo "❌ Terraform не найден в системе."
    wget https://mirror.yandex.ru/mirrors/releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -O /tmp/terraform.zip
    sudo rm -rf /tmp/terraform
    unzip /tmp/terraform.zip -d /tmp/terraform
    sudo rm -rf /usr/local/bin/terraform
    sudo mv /tmp/terraform/terraform /usr/local/bin/
    terraform --version
fi
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
