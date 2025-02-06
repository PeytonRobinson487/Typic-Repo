# We are working on changing the data in the data folder.
# This will require us to change everything that calls the data.
# But it is easy to use and makes it easier to do some functions.
# We are changing this file right now: reset(), save(), and load()
# We are currently looking at load()

extends Node2D

const _save_path: String = "res://saved_data.txt"

const CHAR_MAGNITUDE_CAP: float = 20.0

### Variables --------------------------------------------------------------------------------------
## Score Data
var total_wrong: int = 0
var total_correct: int = 0
var total_score: int = 0
var average_accuracy: float = 100.0
var longest_streak: int = 0
var player_level: int = 1

var hard_lowercase: Dictionary = {}
var hard_uppercase: Dictionary = {}
var hard_number: Dictionary = {}
var hard_symbol: Dictionary = {}

## Settings Data
# Difficulty
enum Difficulty { EASY = 0, MEDIUM = 1, HARD = 2, PRO = 3 }
var difficulty: Difficulty = Difficulty.EASY

# Allowed Characters
# 0 - lowercase_allowed
# 1 - uppercase_allowed
# 2 - numbers_allowed
# 3 - symbols_allowed
var text_modifiers: Array[bool] = [true, true, true, true]

# Sound
# 0 - music_on
# 1 - sound_effects_on
var sound_modifiers: Array[bool] = [true, true]

# Display
# 0 - correct_score_displayed
# 1 - wrong_score_displayed
# 2 - accuracy displayed
# 3 - hard_text_displayed
var score_modifiers: Array[bool] = [true, true, true, true, true]

## Data handling structure
var data: Dictionary = {
	"total_score": total_score,
	"total_wrong": total_wrong,
	"total_correct": total_correct,
	"average_accuracy": average_accuracy,
	"player_level": player_level,
	"hard_lowercase": hard_lowercase,
	"hard_uppercase": hard_uppercase,
	"hard_number": hard_number,
	"hard_symbol": hard_symbol,
	"longest_streak": longest_streak,
	"difficulty": difficulty,
	"text_modifiers": text_modifiers,
	"sound_modifiers": sound_modifiers,
	"score_modifiers": score_modifiers
}

## Variable functions: hard_characters & hard_character_magnitude ----------------------------------
# updates average accuracy
func update_average_accuracy():
	if (total_wrong > 0.0): average_accuracy = total_score / total_wrong * 100

### saving and loading -----------------------------------------------------------------------------
# saves data to save file
func save_data() -> void:
	var file = FileAccess.open(_save_path, FileAccess.WRITE)
	for item in data:
		file.store_var(item)
	print("Data saved!")

# loads data
func load_data() -> void:
	var file: FileAccess = FileAccess.open(_save_path, FileAccess.READ)
	if (file == null):
		# if the file does not exist
		file = FileAccess.new.call()
		save_data()
		return
	
	for key in data:
		if (file != null):
			var value = file.get_var()
			if (typeof(value) == typeof(data[key])): data[key] = value
	
	file.close()
	print("Data loaded!")

# prints all data
func print_all_data() -> void:
	for key in data:
		var value = data[key]
		print(str(key) + " | " + str(value))

# resets all data
func reset_data() -> void:
	data
	#total_wrong = 0
	#total_correct = 0
	#total_score = 0
	#average_accuracy = 0.0
	#player_level = 0
	#hard_characters = []
	#hard_character_magnitude = 0.0
	#longest_streak = 0
	#difficulty = Difficulty.EASY
	#text_modifiers = []
	#sound_modifiers = []
	#score_modifiers = []
	save_data()
	print("Data reset!")
