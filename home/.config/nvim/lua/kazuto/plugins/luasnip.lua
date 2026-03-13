-- Snippet Engine for Neovim written in Lua.
-- https://github.com/L3MON4D3/LuaSnip
return {
  "L3MON4D3/LuaSnip",
  config = function()
    local ls = require("luasnip")

    ls.config.set_config({
      history = true,
      updateevents = "TextChanged,TextChangedI",
    })

    ls.add_snippets("php", {
      ls.parser.parse_snippet("class", "class $1\n{\n    $0\n}"),
      ls.parser.parse_snippet("pubf", "public function $1($2): $3\n{\n    $0\n}"),
      ls.parser.parse_snippet("prif", "private function $1($2): $3\n{\n    $0\n}"),
      ls.parser.parse_snippet("prof", "protected function $1($2): $3\n{\n    $0\n}"),
      ls.parser.parse_snippet("testt", "public function test_$1()\n{\n    $0\n}"),
      ls.parser.parse_snippet("testa", "/** @test */\npublic function $1()\n{\n    $0\n}"),
    })

    ls.add_snippets("typescript", {
      ls.parser.parse_snippet("import", "import $1 from '$0'"),
    })

    ls.add_snippets("vue", {
      ls.parser.parse_snippet("defineProps", "defineProps<{\n  $0\n}>()"),
      ls.parser.parse_snippet("ref", "const $1 = ref$2($3)$0"),
      ls.parser.parse_snippet("computed", "const $1 = computed(() => {\n  $0\n})"),
      ls.parser.parse_snippet("watch", "watch($1, ($2) => {\n  $0\n})"),
      ls.parser.parse_snippet("onMounted", "onMounted(() => {\n  $0\n})"),
      ls.parser.parse_snippet("defineEmits", "const emit = defineEmits<{\n  $0\n}>()"),
      ls.parser.parse_snippet("useFetch", "const { data: $1 } = await useFetch('$2'$3)$0"),
      ls.parser.parse_snippet("useAsyncData", "const { data: $1 } = await useAsyncData('$2', () => $3)$0"),
    })

    -- Blade snippets
    ls.add_snippets("blade", {
      ls.parser.parse_snippet("if", "@if($1)\n    $0\n@endif"),
      ls.parser.parse_snippet("foreach", "@foreach($1 as $2)\n    $0\n@endforeach"),
      ls.parser.parse_snippet("forelse", "@forelse($1 as $2)\n    $3\n@empty\n    $0\n@endforelse"),
      ls.parser.parse_snippet("component", "<x-$1 $2>$0</x-$1>"),
      ls.parser.parse_snippet("props", "@props(['$1'])\n$0"),
      ls.parser.parse_snippet("livewire", "@livewire('$1'$2)$0"),
      ls.parser.parse_snippet("can", "@can('$1')\n    $0\n@endcan"),
      ls.parser.parse_snippet("auth", "@auth\n    $0\n@endauth"),
      ls.parser.parse_snippet("guest", "@guest\n    $0\n@endguest"),
    })

    -- Go snippets
    ls.add_snippets("go", {
      ls.parser.parse_snippet("iferr", "if err != nil {\n    $0\n}"),
      ls.parser.parse_snippet("func", "func $1($2) $3 {\n    $0\n}"),
      ls.parser.parse_snippet("test", "func Test$1(t *testing.T) {\n    $0\n}"),
      ls.parser.parse_snippet("table", "tests := []struct {\n    name string\n    $1\n}{\n    $0\n}\n\nfor _, tt := range tests {\n    t.Run(tt.name, func(t *testing.T) {\n        $2\n    })\n}"),
    })

    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
