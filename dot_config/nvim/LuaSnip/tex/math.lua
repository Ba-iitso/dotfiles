local in_mathzone = function()
  -- The `in_mathzone` function requires the VimTeX plugin
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

return {
s({trig = '([^%a])ff', regTrig = true, wordTrig = false},
  fmta(
    [[<>\frac{<>}{<>}]],
    {
      f( function(_, snip) return snip.captures[1] end ),
      i(1),
      i(2)
    }
  )
),
}
