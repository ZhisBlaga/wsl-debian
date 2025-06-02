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
sudo apt install -qq -y apt-transport-https ca-certificates curl gpg htop vim git zsh unzip python3-pip python3-debian

# Kubectl
print_section "Добавление k8s репы и установка kubectl"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --yes --dearmor -o  /etc/apt/keyrings/kubernetes-apt-keyring.gpg
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

# Установка docker
print_section "Установка Docker"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --yes --dearmor -o  /etc/apt/keyrings/docker-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/docker-apt-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update -qq
sudo apt-get install -y docker-ce
sudo usermod -aG docker $USER

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

# Установка terragrunt
print_section "Установка terragrunt"
if command -v terragrunt &> /dev/null; then
    echo "✅ Terragrunt установлен. Версия: $(terragrunt --version)"
else
    echo "❌ Terragrunt не найден в системе."
    wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.80.4/terragrunt_linux_amd64 -O /tmp/terragrunt
    chmod +x /tmp/terragrunt
    sudo mv /tmp/terragrunt /usr/local/bin/
    terragrunt --version
fi

cat << EOF > ~/.terraformrc
provider_installation {
  network_mirror {
    url     = "https://nm.tf.org.ru/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
EOF



# Ansible
print_section "Установка ansible"
pip3 install ansible --break-system-packages
cat << EOF > ~/.ansible.cfg
[defaults]
host_key_checking = False
EOF




# Oh my zsh
print_section "Установка oh-my-zsh"
if [ -d "~/.oh-my-zsh" ]; then
 sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
 echo "Oh my zsh уже установлен"
fi
sed -i.bak 's/^plugins=.*/plugins=(git kubectl)/' ~/.zshrc
