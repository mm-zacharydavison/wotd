#!/bin/bash

INSTALL_DIR="$HOME/.wotd"
SCRIPT_NAME="word_of_the_day.sh"
BASHRC="$HOME/.bashrc"
ZSHRC="$HOME/.zshrc"
FISH_CONFIG="$HOME/.config/fish/config.fish"

# Ensure install directory exists
mkdir -p "$INSTALL_DIR"

# Copy the script to the install directory
SCRIPT_PATH="$INSTALL_DIR/$SCRIPT_NAME"
cp "$(dirname "$0")/$SCRIPT_NAME" "$SCRIPT_PATH"
chmod +x "$SCRIPT_PATH"

echo "Word of the Day script installed to $SCRIPT_PATH."

# Ask the user which languages to enable
echo "Which languages do you want to enable for the Word of the Day? (comma-separated, e.g., English,Spanish,French)"
read -r ENABLED_LANGUAGES

# Add ENABLED_LANGUAGES to the script
sed -i "s/^ENABLED_LANGUAGES=.*$/ENABLED_LANGUAGES=\"$ENABLED_LANGUAGES\"/" "$SCRIPT_PATH"

# Add the script to shell config files
echo "Adding the Word of the Day script to your shell configuration files..."
for config_file in "$BASHRC" "$ZSHRC" "$FISH_CONFIG"; do
    if [ -f "$config_file" ]; then
        if ! grep -q "$SCRIPT_PATH" "$config_file"; then
	    echo "\n# Word Of The Day (.wotd)" >> "$config_file"
            echo "\nbash \"$SCRIPT_PATH\"" >> "$config_file"
            echo "Added to $config_file."
        else
            echo "Already added to $config_file."
        fi
    fi
done

echo "Installation complete. Please restart your shell to see the Word of the Day."

