-- I don't need local marks, but I really like global marks to jump between the files and lines
-- override local marks with global ones

local alphabet = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
	"u", "v", "w", "x", "y", "z" }

for _, letter in ipairs(alphabet) do
	local upper_letter = string.upper(letter)

	Keymap.normal("m" .. letter, "m" .. upper_letter)
	Keymap.normal("'" .. letter, "'" .. upper_letter)
	Keymap.normal("`" .. letter, "'" .. upper_letter)
end
