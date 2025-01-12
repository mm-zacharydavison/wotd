
# Word of the Day

This repository provides a simple script that fetches a random "Word of the Day" using OpenAI's API and displays it whenever you open a terminal window.

The script supports:

- Multiple configurable languages.
- Cached API calls per day to avoid unnecessary API hits.
- Multiple shells (bash, zsh, fish).

## Requirements

- OpenAI API key (set as `OPENAI_API_KEY` environment variable)
- `curl`, `jq`

## Quick Start

To get started, run the following command in your terminal:

```
bash <(curl -sSL https://raw.githubusercontent.com/mm-zacharydavison/wotd/main/install.sh)
```

## Quick Start (fish)

For fish shells, we need to drop into bash first, because the script is interactive.
It will still be installed into your `config.fish`, because installation is detected based on which shells you have installed.

```
bash
bash <(curl -sSL https://raw.githubusercontent.com/mm-zacharydavison/wotd/main/install.sh)
```
