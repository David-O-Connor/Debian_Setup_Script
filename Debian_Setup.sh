#!/bin/bash

# Function to check if gpg is installed and install it if necessary
check_install_gpg_debian() {
    if ! command -v gpg &> /dev/null; then
        echo "gpg is not installed. Installing gpg..."
        sudo apt update
        sudo apt install -y gpg
    else
        echo "gpg is already installed."
    fi
}

# Function to install Visual Studio Code on Debian-based systems
install_vscode_debian() {
    echo "Installing Visual Studio Code on Debian-based system..."
    check_install_gpg_debian
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code
    rm packages.microsoft.gpg
    echo "Visual Studio Code installation complete!"
}

# Function to update and upgrade on Debian-based systems
update_upgrade_debian() {
    echo "Updating package list and upgrading all packages on Debian-based system..."
    sudo apt update && sudo apt -y upgrade
    echo "Update and upgrade complete!"
}

# Function to install fastfetch on Debian-based systems
install_fastfetch_debian() {
    echo "Installing fastfetch on Debian-based system..."
    sudo apt install -y fastfetch
    echo "fastfetch installation complete!"
}

# Function to install virt-manager on Debian-based systems
install_virtmanager_debian() {
    echo "Installing virt-manager on Debian-based system..."
    sudo apt install -y virt-manager
    echo "virt-manager installation complete!"
}

# Function to modify sources.list for Debian-based systems
modify_sources_list_debian() {
    echo "Modifying /etc/apt/sources.list for Debian-based system..."
    sudo sh -c 'echo "deb http://deb.debian.org/debian bookworm main non-free-firmware
deb-src http://deb.debian.org/debian bookworm main non-free-firmware

deb http://deb.debian.org/debian-security/ bookworm-security main non-free-firmware
deb-src http://deb.debian.org/debian-security/ bookworm-security main non-free-firmware

deb http://deb.debian.org/debian bookworm-updates main non-free-firmware
deb-src http://deb.debian.org/debian bookworm-updates main non-free-firmware" > /etc/apt/sources.list'
    echo "Sources list modified!"
}

# Function to add the current user to the sudoers file
add_current_user_to_sudoers() {
    username=$(whoami)
    #echo "Switching to su user to modify sudoers file..."
    sudo "echo '$username ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/$username"
    sudo chmod 0440 /etc/sudoers.d/$username
    echo "User $username added to sudoers."
}

# Detect the Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            debian|ubuntu)
                DISTRO="debian"
                ;;
            *)
                echo "Unsupported Linux distribution: $ID"
                exit 1
                ;;
        esac
    else
        echo "Cannot detect Linux distribution."
        exit 1
    fi
}

# Display package installation menu and execute chosen option
install_packages_menu() {
    while true; do
        echo "Please choose a package to install:"
        echo "1. Install fastfetch"
        echo "2. Install virt-manager"
        echo "3. Install Visual Studio Code"
        echo "4. Modify sources.list"
        echo "5. Back to main menu"
        read -p "Enter your choice (1, 2, 3, 4, or 5): " choice

        case "$choice" in
            1)
                install_fastfetch_debian
                ;;
            2)
                install_virtmanager_debian
                ;;
            3)
                install_vscode_debian
                ;;
            4)
                modify_sources_list_debian
                ;;
            5)
                return
                ;;
            *)
                echo "Invalid choice, please choose a valid option."
                ;;
        esac
    done
}

# Display main menu and execute chosen option
show_menu() {
    while true; do
        echo "Please choose an option:"
        echo "1. Update and Upgrade System"
        echo "2. Install Packages"
        echo "3. Add Current User to Sudoers"
        echo "4. Exit"
        read -p "Enter your choice (1, 2, 3, or 4): " choice

        case "$choice" in
            1)
                update_upgrade_debian
                ;;
            2)
                install_packages_menu
                ;;
            3)
                add_current_user_to_sudoers
                ;;
            4)
                echo "Exiting program."
                exit 0
                ;;
            *)
                echo "Invalid choice, please choose a valid option."
                ;;
        esac
    done
}

# Main script execution
detect_distro
show_menu