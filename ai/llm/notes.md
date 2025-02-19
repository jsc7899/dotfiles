# LLM

## links

- <https://simonwillison.net/2024/Jun/17/cli-language-models/>

## notes

### [usage](https://llm.datasette.io/en/stable/usage.html)

```bash
# default model
llm models default gpt-4o

# project dir
# default: ~/Library/Application Support/io.datasette.llm/logs.db
export LLM_USER_PATH=/path/to/my/custom/directory

# sqlite logging (default on)
llm logs off
```

## ideas for usage

- organize dotfiles by machine type
  - separate file for macos, linux, home
  - load with ifs
  - convert pip to uv

- screenshotterV2
  - <https://llm.datasette.io/en/stable/usage.html#attachments>
  - <https://shot-scraper.datasette.io/>

- system prompts: have the ai create agents with yaml templates
<https://llm.datasette.io/en/stable/templates.html>
  - ansible
  - bash
  - golang
  NOTE: don't forget o3-mini reasoning effor when saving

- nvim key for bash shebang
  - keys for other quick texts?

- code companion
<https://codecompanion.olimorris.dev/extending/prompts.html>
  - setup keys and prompts
  - create my own nvim plugin with hooks to `llm`?
