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

    # Ask the user which languages to enable
    echo "Which languages do you want to enable for the Word of the Day? (comma-separated, e.g., English,Spanish,French)"
    read -r ENABLED_LANGUAGES

    # Add ENABLED_LANGUAGES to the script
    sed -i "s/^ENABLED_LANGUAGES=.*$/ENABLED_LANGUAGES=\"$ENABLED_LANGUAGES\"/" "$INSTALL_DIR/$SCRIPT_NAME"

    # Add the script to shell config files
    echo "Adding the Word of the Day script to your shell configuration files..."
    for config_file in "$BASHRC" "$ZSHRC" "$FISH_CONFIG"; do
        if [ -f "$config_file" ]; then
            if ! grep -q "$INSTALL_DIR/$SCRIPT_NAME" "$config_file"; then
                echo -e "\n# Word Of The Day (.wotd)" >> "$config_file"
                echo -e "\nbash \"$INSTALL_DIR/$SCRIPT_NAME\"" >> "$config_file"
                echo "Added to $config_file."
            else
                echo "Already added to $config_file."
            fi
        fi
    done

    echo "Installation complete. Please restart your shell to see the Word of the Day."
}

# Run the installation if the script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_wotd
fi