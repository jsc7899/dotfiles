# Guidelines for Codex agents

- The `ai/aider/conventions.md` file describes conventions for Python code. When adding or modifying Python:
  - Use the `uv` tool for all package management.
  - List dependencies in `config/requirements.txt` with no version pins.
  - Prefer the OpenAI Responses API with model `gpt-4.1`.
  - Preserve existing comments and only implement the requested changes.

- This repository mainly contains shell scripts and configuration files for Bash, tmux and Neovim. If you modify any shell scripts run `bash -n <script>` to check syntax before committing.

- There is no automated test suite. Just ensure scripts parse correctly and configuration files remain valid.
