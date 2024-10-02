extends Node

@onready var user_line = %User_line
@onready var computer_text = %computer_text
@onready var hard_text_display = %hard_text_display
@onready var letter_count = %letter_count
@onready var letter_options = %Letter_Options

# Called when the node enters the scene tree for the first time.
func _ready():	
	# initialize elements
	letter_count.initialize_counts("", 0, 0, 0)
	
	# display the initialized count for each letter count
	hard_text_display.display_hard_char()
	letter_count.display_letter_counts()
	
	# put focus on user_line input box
	user_line.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# only check if the user's text has any character that is not a letter
	if !is_text_valid(user_line.text):
		# reset user text and check again
		user_line.text = ""
		return
	
	## answers
	# correct answer
	if user_line.text.similarity(computer_text.text.substr(0, 1)) == 1:
		computer_text.delete_text(0, 1)
		
		# subtract from the character from the frequency map
		if hard_text_display.has_character(computer_text.text.substr(0, 1)):
			hard_text_display.divide_key_value(computer_text.text.substr(0, 1), 2)
		
		letter_count.add_count("correct", 1)
	# wrong answer
	else:
		# add to the character to the frequency map
		if !hard_text_display.has_character(computer_text.text.substr(0, 1)):
			hard_text_display.add_key(computer_text.text.substr(0, 1), 1)
		else:
			hard_text_display.increment_key_value(computer_text.text.substr(0, 1), 1)
		
		letter_count.add_count("wrong", 1)
		
		
		
		# computer_text.wrong_answer_animation()
	
	## updates
	# delete the first character
	user_line.delete_text(0, 1)
	
	# update letter count
	letter_count.add_count("total", 1)
	
	# Generate more computer text
	computer_text.generate_character(1, hard_text_display.character_frequency)
	
	# update text displays
	hard_text_display.display_hard_char()
	letter_count.display_letter_counts()


## Utility
# checks string
# O(n) time
# O(1) space
func is_alpha(text: String):
	const ALPHABET: Dictionary = {
		"a": 0, "b": 1, "c": 2, "d": 3, "e": 4, "f": 5, "g": 6, "h": 7, "i": 8, "j": 9,
		"k": 10, "l": 11, "m": 12, "n": 13, "o": 14, "p": 15, "q": 16, "r": 17, "s": 18, "t": 19,
		"u": 20, "v": 21, "w": 22, "x": 23, "y": 24, "z": 25,
		"A": 26, "B": 27, "C": 28, "D": 29, "E": 30, "F": 31, "G": 32, "H": 33, "I": 34, "J": 35,
		"K": 36, "L": 37, "M": 38, "N": 39, "O": 40, "P": 41, "Q": 42, "R": 43, "S": 44, "T": 45,
		"U": 46, "V": 47, "W": 48, "X": 49, "Y": 50, "Z": 51
	}
	
	for c in text:
		if ALPHABET.has(str(c)):
			return true
	return false
func is_digit(text: String):
	const NUMBERS: Dictionary = {
		"0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9
	}
	
	for c in text:
		if NUMBERS.has(c):
			return true
	return false
func is_symbol(text: String):
	const SYMBOLS: Dictionary = {
		0: "!", 1: "@", 2: "#", 3: "$", 4: "%", 5: "^", 6: "&", 7: "*", 8: "(", 9: ")", 10: "-", 11: "_", 12: "+", 13: "=", 14: "[", 15: "]", 16: "{", 17: "}", 18: ";", 19: "'", 20: ":", 21: "\"", 22: ",", 23: "<", 24: ".", 25: ">", 26: "/", 27: "?",
	}
	
	for c in text:
		if SYMBOLS.has(c):
			return true
	return false

# checks the user input
func is_text_valid(new_text):
	if new_text.length() > 0:
		return true
	return false
