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
	var filtered_text_modifiers: Array
	for index in data.text_modifiers.size():
		if (data.text_modifiers[index]):
			filtered_text_modifiers.push_back(index)
	
	# generate characters
	var new_text: String = ""
	var index: int = 0
	while (new_text.length() < length && index < 100):
		# get chance for hard character
		var return_array: Array
		calculate_chance(data, filtered_text_modifiers, return_array)
		
		# get a character
		var relevant_magnitude: float = return_array[0]
		var chance: float = return_array[1]
		new_text += get_character(filtered_text_modifiers, libraries, data, relevant_magnitude, chance)
		index += 1
	
	if (index == 100):
		# prevents the program from crashing, and prints an error message to the textbox
		print("text_maker while loop index: " + str(index))
		new_text = "S-8ySD,_Error_MSymf9"
	return new_text


# calculates the chance for getting a hard character
func calculate_chance(data: Node2D, filtered_text_modifiers: Array, variables: Array) -> void:
	# count number of relevant characters
	var number_of_relevant_characters: int = 1
	var relevant_magnitude: float = 0.0
	var hard_char_index: int = 0
	while (hard_char_index < data.hard_characters.size() - 1):
		for i in filtered_text_modifiers:
			if (libraries[i].has(data.hard_characters[hard_char_index])):
				number_of_relevant_characters += 1
				relevant_magnitude += data.hard_characters[hard_char_index + 1]
		hard_char_index += 2
	var chance: float = randf() * data.CHAR_MAGNITUDE_CAP * (number_of_relevant_characters / 3.0) + 1
	
	# update return array
	variables.push_back(relevant_magnitude)
	variables.push_back(chance)

# gets a character
func get_character(filtered_text_modifiers: Array, libraries: Array, data: Node2D, relevant_magnitude: float, chance: float) -> String:
	var new_character: String = ""
	if (chance < relevant_magnitude):
		new_character = get_hard_character(data)
	if (chance >= relevant_magnitude):
		new_character = get_normal_character(filtered_text_modifiers)
	else:
		# check if the character is allowed according to char settings
		var j: int = 0
		for i in filtered_text_modifiers:
			if (libraries[i].has(new_character)):
				j += 1
		if (j < filtered_text_modifiers.size()):
			# character is not allowed
			new_character = get_normal_character(filtered_text_modifiers)
	return new_character


# generates a random character from one of the character dictionaries
func get_normal_character(filtered_text_modifiers: Array) -> String:
	var rand_index: int = filtered_text_modifiers.pick_random()
	return libraries[rand_index].find_key(randi() % libraries[rand_index].size() + 1)

# uses hard text to get a weak character for the player
func get_hard_character(data: Node2D) -> String:
	# create sum prefix for chance_pool
	var sum_prefix: Array
	var sum: float = 0.0
	var i: int = 1;
	while (i < data.hard_characters.size()):
		sum += data.hard_characters[i]
		sum_prefix.push_back(sum)
		i += 2
	
	# compare random value and find which key to use
	var rand: float = randf() * sum_prefix[sum_prefix.size() - 1]
	i = 0
	while (i < sum_prefix.size() && rand > sum_prefix[i]):
		i += 1
	
	var new_char: String = data.hard_characters[i * 2]
	return new_char
