#!/bin/bash

INSTALL_DIR="$HOME/.wotd"
SCRIPT_NAME="word_of_the_day.sh"
BASHRC="$HOME/.bashrc"
ZSHRC="$HOME/.zshrc"
FISH_CONFIG="$HOME/.config/fish/config.fish"

# Download and install function
install_wotd() {
    # Ensure install directory exists
    mkdir -p "$INSTALL_DIR"

    # Download the script
    curl -o "$INSTALL_DIR/$SCRIPT_NAME" https://raw.githubusercontent.com/mm-zacharydavison/wotd/main/word_of_the_day.sh
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

    echo "Word of the Day script installed to $INSTALL_DIR/$SCRIPT_NAME."

    # Ask the user for their native language
    echo -e "\e[1;34mWhat is your native language? (e.g. 'English')\e[0m"
    echo -e "\e[1;34mMeanings of words will be shown in your native language.\e[0m"
    echo -e "Default: English"
    read -r NATIVE_LANGUAGE

    if [ -z "$NATIVE_LANGUAGE" ]; then
        NATIVE_LANGUAGE="English"
    fi

    # Ask the user which languages to enable
    echo -e "\e[1;34mWhich languages do you want get words of the day for? (comma-separated, e.g., English,Spanish,French)\e[0m"
    read -r ENABLED_LANGUAGES

    # Add ENABLED_LANGUAGES and NATIVE_LANGUAGE to the script
    sed -i "s/^ENABLED_LANGUAGES=.*$/ENABLED_LANGUAGES=\"$ENABLED_LANGUAGES\"/" "$INSTALL_DIR/$SCRIPT_NAME"
    sed -i "s/^NATIVE_LANGUAGE=.*$/NATIVE_LANGUAGE=\"$NATIVE_LANGUAGE\"/" "$INSTALL_DIR/$SCRIPT_NAME"

    # Add the script to shell config files
    echo -e "\e[1;34mAdding the Word of the Day script to your shell configuration files...\e[0m"
    for config_file in "$BASHRC" "$ZSHRC" "$FISH_CONFIG"; do
        if [ -f "$config_file" ]; then
            if ! grep -q "$INSTALL_DIR/$SCRIPT_NAME" "$config_file"; then
                echo -e "\n# Word Of The Day (.wotd)" >> "$config_file"
                echo -e "\nbash \"$INSTALL_DIR/$SCRIPT_NAME\"" >> "$config_file"
                echo -e "\e[1;32mAdded to $config_file.\e[0m"
            else
                echo -e "\e[1;33mAlready added to $config_file.\e[0m"
            fi
        fi
    done

    echo -e "\e[1;32mInstallation complete. Please restart your shell to see the Word of the Day.\e[0m"
}

# Run the installation if the script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_wotd
fi