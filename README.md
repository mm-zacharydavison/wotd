
# Word of the Day

![image](https://github.com/user-attachments/assets/0441b743-effe-4a4f-b3de-6661b4f433f4)

This repository provides a simple script that fetches a random "Word of the Day" using either OpenAI's or Anthropic's Claude API and displays it whenever you open a terminal window.

The script supports:

- Multiple configurable languages.
- Cached API calls per day to avoid unnecessary API hits.
- Multiple shells (bash, zsh, fish).
- Choice between OpenAI and Claude APIs.

## Requirements

- OpenAI API key (set as `OPENAI_API_KEY` environment variable) **OR**
- Anthropic API key (set as `ANTHROPIC_API_KEY` environment variable)
- `curl`, `jq`

## API Selection

The script will automatically use the available API based on which environment variable is set:

- If both `OPENAI_API_KEY` and `ANTHROPIC_API_KEY` are set, you'll be prompted during installation to choose your preferred API.
- If only one API key is set, the script will use that API automatically.

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
