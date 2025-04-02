local line_begin = require("luasnip.extras.expand_conditions").line_begin
local helpers = require("luasnip-helper-funcs")
local get_visual = helpers.get_visual

return {
	-- main() function with void argument
	s({trig = "imv", snippetType="autosnippet"},
		fmta(
			[[
		int main(void) {
				<>
		}
		]],
			{ i(0) }
		),
		{condition = line_begin}
	),
	-- main() function with argc/argv
	s({trig = "ima", snippetType="autosnippet"},
		fmta(
			[[
		int main(int argc, char* argv[argc]) {
				<>
		}
		]],
			{ i(0) }
		),
		{condition = line_begin}
	),
}
