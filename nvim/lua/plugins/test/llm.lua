-- https://github.com/huggingface/llm.nvim
return {
  'huggingface/llm.nvim',
  opts = {
    api_token = os.getenv 'OPENAI_API_KEY',
    model = 'gpt-3.5-turbo', -- the model ID, behavior depends on backend
    backend = 'openai', -- backend ID, "huggingface" | "ollama" | "openai" | "tgi"
    url = 'https://api.openai.com/v1/completions', -- the http url of the backend
    tokens_to_clear = { '<|endoftext|>' }, -- tokens to remove from the model's output
    -- parameters that are added to the request body, values are arbitrary, you can set any field:value pair here it will be passed as is to the backend
    request_body = {
      -- parameters = {
      --   max_new_tokens = 60,
      --   temperature = 0.2,
      --   top_p = 0.95,
      -- },
    },
    -- set this if the model supports fill in the middle
    fim = {
      enabled = true,
      prefix = '<fim_prefix>',
      middle = '<fim_middle>',
      suffix = '<fim_suffix>',
    },
    debounce_ms = 150,
    accept_keymap = '<Tab>',
    dismiss_keymap = '<S-Tab>',
    tls_skip_verify_insecure = false,
    -- llm-ls configuration, cf llm-ls section
    lsp = {
      bin_path = nil,
      host = nil,
      port = nil,
      cmd_env = nil, -- or { LLM_LOG_LEVEL = "DEBUG" } to set the log level of llm-ls
      version = '0.5.3',
    },
    tokenizer = nil, -- cf Tokenizer paragraph
    context_window = 1024, -- max number of tokens for the context window
    enable_suggestions_on_startup = true,
    enable_suggestions_on_files = '*', -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
    disable_url_path_completion = false, -- cf Backend   -- cf Setup
  },
}
