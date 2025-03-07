local line_begin = require("luasnip.extras.expand_conditions").line_begin
local helpers = require('luasnip-helper-funcs')
local get_visual = helpers.get_visual

local inp_class_param = function(args, snip)
	local vars = tonumber(snip.captures[1])
	local nodes = {}
	if vars == 0 then 
		return sn(nil, nodes)
	end

	for j = 1, vars do
		table.insert(nodes, r(j, tostring(j) .. "x1", i(1)))
		table.insert(nodes, t({"","\t"}))
	end
	return sn(nil, nodes)
end

local gen_get_decl = function(args, snip)
  if (#snip.snippet.env.TM_SELECTED_TEXT < 0) then
    return sn(nil, i(1, ''))
  end
	local nodes = {}
	for k, v in pairs(snip.snippet.env.TM_SELECTED_TEXT) do
		table.insert(nodes, t("get" .. v))
	end

	return sn(nil, nodes)
end

return {
	s( { trig="class(%d+) ", regTrig=true, wordTrig=false, desc="simple class template", snippetType="autosnippet"}, 
		fmta(
			[[
				class <> {
				public:
					<>();
					<>
					<>
					<>
				private:
					<>
				};
			]],
			{ i(1), rep(1), i(0), rep(2), rep(2), d(2, inp_class_param) },
			{ condition = line_begin }
		)
	),
	s( { trig="getsetv", snippetType="autosnippet" },
		d(1, gen_get_decl)
	),
}
