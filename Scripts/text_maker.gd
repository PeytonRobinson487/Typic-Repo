extends RichTextLabel


@onready var text_maker = $"."


## Dictionarys with appropriate charactesr
# lowercase letters
var lowercase_letters: Dictionary = {
	"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6, "g": 7, "h": 8, "i": 9, "j": 10,
	"k": 11, "l": 12, "m": 13, "n": 14, "o": 15, "p": 16, "q": 17, "r": 18, "s": 19, "t": 20,
	"u": 21, "v": 22, "w": 23, "x": 24, "y": 25, "z": 26
}
# uppercase letters
var uppercase_letters = {
	"A": 1, "B": 2, "C": 3, "D": 4, "E": 5, "F": 6, "G": 7, "H": 8, "I": 9, "J": 10,
	"K": 11, "L": 12, "M": 13, "N": 14, "O": 15, "P": 16, "Q": 17, "R": 18, "S": 19, "T": 20,
	"U": 21, "V": 22, "W": 23, "X": 24, "Y": 25, "Z": 26
}
# numbers
var numbers: Dictionary = {
	"0": 1, "1": 2, "2": 3, "3": 4, "4": 5, "5": 6, 
	"6": 7, "7": 8, "8": 9, "9": 10
}
# symbols
var symbols: Dictionary = {
	"!": 1, "@": 2, "#": 3, "$": 4, "%": 5, "^": 6, 
	"&": 7, "*": 8, "(": 9, ")": 10, "-": 11, "_": 12, 
	"+": 13, "=": 14, "[": 15, "]": 16, "{": 17, "}": 18, 
	":": 19, ";": 20, "'": 21, '\"': 22, "<": 23, ">": 24, 
	",": 25, ".": 26, "?": 27, "/": 28, "\\": 29
}
# holds the libraries - enables picking them by index
var libraries: Array = [
	lowercase_letters,
	uppercase_letters,
	numbers,
	symbols
]

# generates text based on settings and hard characters
func generate_text(length: int, data) -> String:
	# only permit true values
	var filtered_text_modifiers: Dictionary
	for index in data.text_modifiers.size():
		if (data.text_modifiers.get(index) == true):
			filtered_text_modifiers[index] = true
	
	# generate characters
	var new_text: String = ""
	while (new_text.length() < length):
		# 0 - lowercase_allowed
		# 1 - uppercase_allowed
		# 2 - numbers_allowed
		# 3 - symbols_allowed
		
		# gets a garunteed true text modifier from the dictionary
		var rand_index: int = filtered_text_modifiers.keys().pick_random()
		var current_dictionary: Dictionary
		current_dictionary.merge(libraries[rand_index], false)
		new_text += current_dictionary.find_key(randi() % current_dictionary.size() + 1)
	
	return new_text
