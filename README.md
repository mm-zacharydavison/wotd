
# Word of the Day

This repository provides a simple script that fetches a random "Word of the Day" using OpenAI's API and displays it whenever you open a terminal window.

The script supports:

- Multiple configurable languages.
- Cached API calls per day to avoid unnecessary API hits.
- Multiple shells (bash, zsh, fish).

## Quick Start

To get started, run the following command in your terminal:

```
curl -s https://raw.githubusercontent.com/mm-zacharydavison/wotd/main/install.sh | bash
```

You'll need to set the `OPENAI_API_KEY` environment variable in order for it to work.