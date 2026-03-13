local vue_plugin_path = vim.fn.expand(
  "$MASON/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin"
)

return {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
  },
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_plugin_path,
        languages = { "vue" },
      },
    },
  },
}
