#!/bin/bash
WORD_OF_DAY_CACHE="$HOME/.wotd/cache"
PREVIOUS_WORDS_FILE="$WORD_OF_DAY_CACHE/previous_words.txt"

# User-configurable languages (comma-separated, e.g., "English,Spanish,French")
ENABLED_LANGUAGES="English,Japanese,German,French"
NATIVE_LANGUAGE="English"

# Check if OPENAI_API_KEY is set
if [ -z "$OPENAI_API_KEY" ]; then
    echo -e "\e[1;31mError: OPENAI_API_KEY is not set. Please set it in your environment variables.\e[0m" >&2
    exit 1
fi

# Path to store the cached word of the day
if [ ! -d "$WORD_OF_DAY_CACHE" ]; then
    mkdir -p "$WORD_OF_DAY_CACHE"
fi

fetch_word_of_day() {
    local language="$1"
    local response
    local current_date=$(date +%Y-%m-%d)
    local used_words=""

    # Read used words
    if [ -f "$PREVIOUS_WORDS_FILE" ]; then
        used_words=$(cat "$PREVIOUS_WORDS_FILE" | tr '\n' ',' | sed 's/,$//')
    fi

    # Start spinner in background
    spinner &
    SPINNER_PID=$!

    response=$(curl -s -X POST https://api.openai.com/v1/chat/completions \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"model\": \"gpt-3.5-turbo\",
            \"messages\": [{\"role\": \"system\", \"content\": \"You are a multilingual dictionary. Provide a unique word of the day in $language along with its meaning in $NATIVE_LANGUAGE. Also provide the translation of the word in $NATIVE_LANGUAGE. Today's date is $current_date. Exclude these words: $used_words. Respond with only the word, its definition in $NATIVE_LANGUAGE, and its translation in $NATIVE_LANGUAGE.\"}]
        }")

    # Stop spinner
    kill $SPINNER_PID
    wait $SPINNER_PID 2>/dev/null
    printf "\r%s\r" "$(printf ' %.0s' {1..20})"

    local word_and_definition=$(echo "$response" | jq -r '.choices[0].message.content')
    echo "$word_and_definition" > "$WORD_OF_DAY_CACHE/$language.cache"

    # Extract just the word and add it to used words
    local new_word=$(echo "$word_and_definition" | awk '{print $1}' | tr -d '[:punct:]')
    echo "$new_word" >> "$PREVIOUS_WORDS_FILE"
}

# Spinner function
spinner() {
    local i=0
    local sp='/-\|'
    printf ' '
    while true; do
        printf '\b%s' "${sp:i++%${#sp}:1}"
        sleep 0.1
    done
}
# Function to display the word of the day
show_word_of_day() {
    # Parse the enabled languages into an array
    IFS=',' read -r -a languages <<< "$ENABLED_LANGUAGES"

    # Randomly select a language
    local selected_language=${languages[$RANDOM % ${#languages[@]}]}

    # Cache file for the selected language
    local cache_file="$WORD_OF_DAY_CACHE/$selected_language.cache"

    # Check if the cache file exists and is from today
    if [ -f "$cache_file" ]; then
        local cache_date
        cache_date=$(stat -c %y "$cache_file" | cut -d' ' -f1)
        local current_date
        current_date=$(date +%F)

        if [ "$cache_date" != "$current_date" ]; then
            fetch_word_of_day "$selected_language"
        fi
    else
        fetch_word_of_day "$selected_language"
    fi

    # Get terminal width
    local term_width=$(tput cols)
    local line=$(printf '%*s' "$term_width" | tr ' ' '-')

    # Display the word of the day with formatting
    echo -e "$line"
    echo -e "\e[1;32mWord of the Day\e[0m \e[1;34m(in $selected_language):\e[0m"
    echo -e "\e[1;33m$(cat "$cache_file")\e[0m"
    echo -e "$line"
}

# Call the function to show the word of the day
show_word_of_day

