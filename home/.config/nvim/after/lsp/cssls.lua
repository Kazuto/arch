return {
  settings = {
    css = {
      validate = true,
      lint = {
        unknownAtRules = "ignore", -- Ignore Tailwind's @theme, @apply, @layer, etc.
      },
    },
    scss = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
    less = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
  },
}
