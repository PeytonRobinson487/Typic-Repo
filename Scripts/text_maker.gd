# We are currently working on generating the hard character
# We need to figure out if the rand < sum_prefix[index] actually works right now
# The idea works, but I think I implemented it wrong
# It has deal with the while loop on line 88

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
# holds the dictionaries - enables picking them by index
var libraries: Array = [
	lowercase_letters,
	uppercase_letters,
	numbers,
	symbols
]

# generates text based on settings and hard characters
func generate_text(length: int, data: Node2D) -> String:
	# add the indexes of the true values
	var relevant_text_modifiers: Array
	for index in data.all_data["text_modifiers"].size():
		if (data.all_data["text_modifiers"][index]):
			relevant_text_modifiers.push_back(index)
	
	# get the size of all relevant arrays
	var relevant_chars: Dictionary = {}
	for index in relevant_text_modifiers:
		relevant_chars.merge(data.all_data["hard_library"][index])
	
	# generate characters
	var new_text: String = ""
	var index: int = 0
	while (new_text.length() < length && index < 100):
		# get chance for hard character
		var return_array: Array
		var chance: float = randf() * data.CHAR_MAGNITUDE_CAP * (relevant_chars.size() / 3.0) + 1
		
		# get a character
		if (chance < data.get_char_magnitude(relevant_chars)):
			new_text += get_hard_character(relevant_chars)
		else:
			# normal character
			var rand_index: int = relevant_text_modifiers.pick_random()
			new_text += libraries[rand_index].find_key(randi() % libraries[rand_index].size() + 1)
		
		index += 1
	
	if (index == 100):
		# prevents the program from crashing, and prints an error message to the textbox
		print("text_maker while loop index: " + str(index))
		new_text = "S-8ySD,_Error_MSymf9"
	return new_text


# uses hard text to get a weak character for the player
func get_hard_character(hard_characters: Dictionary) -> String:
	# create sum prefix for chance_pool
	var sum_prefix: Array = []
	var sum: float = 0.0
	var i: int = 1
	for key in hard_characters:
		sum += hard_characters[key]
		sum_prefix.push_back(sum)
	
	# compare random value and find which key to use
	var rand: float = randf() * sum_prefix[sum_prefix.size() - 1]
	i = 0
	while (i < sum_prefix.size() && sum_prefix[i] < rand):
		i += 1
	
	return hard_characters.keys()[i]
