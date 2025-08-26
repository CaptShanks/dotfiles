return {
  settings = {
    ["helm-ls"] = {
      yamlls = {
        path = "yaml-language-server",
        config = {
          schemas = {
            kubernetes = "**/templates/**",
          },
          completion = true,
          hover = true,
        },
      },
    },
  },
}
