vim.lsp.config('tailwindcss', {
  settings = {
    tailwindCSS = {
      classFunctions = { "cva", "tv", "cn" },
      experimental = {
        -- classRegex = {
        --   -- Matches strings within quotes (single, double, or backticks)
        --   -- { "([\"'`][^\"'`]*.*?[\"'`])", "[\"'`]([^\"'`]*).*?[\"'`]" },

        --   -- Matches arguments passed inside the `cn` function
        --   { "cn\\(([^)]*)\\)",    "[\"'`]([^\"'`]+)[\"'`]" },

        --   -- Matches Tailwind classes within the `tv` function
        --   { "tv\\(([^)]*)\\)",    "[\"'`]([^\"'`]*).*?[\"'`]" },

        --   -- Matches single-quoted classes assigned to a variable `Styles`
        --   { "Styles \\=([^;]*);", "'([^']*)'" },

        --   -- Matches double-quoted classes assigned to a variable `Styles`
        --   { "Styles \\=([^;]*);", "\"([^\"]*)\"" },

        --   -- Matches backtick-enclosed classes assigned to a variable `Styles`
        --   { "Styles \\=([^;]*);", "\\`([^\\`]*)\\`" },

        --   -- Matches cva usage
        --   { "cva\\(([^)]*)\\)",   "[\"'`]([^\"'`]*).*?[\"'`]" },

        -- }
      }
    }
  }
})
