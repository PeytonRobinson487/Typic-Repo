extends Node2D

const _save_path: String = "res://saved_data.txt"

### Variables --------------------------------------------------------------------------------------
## Score Data
var total_wrong: int = 0
var total_correct: int = 0
var total_score: int = 0
var average_accuracy: float = 100.0
var player_level: int = 1
# odds indexes: characters
# even indexes: error weight
var hard_characters: Array = []
var hard_character_magnitude: float = 0
var longest_streak: int = 0

const CHAR_MAGNITUDE_CAP: float = 20.0

## Settings Data
# Difficulty
enum Difficulty {
	EASY = 0,
	MEDIUM = 1,
	HARD = 2,
	PRO = 3
}
var difficulty: Difficulty = Difficulty.EASY

# Allowed Characters
# 0 - lowercase_allowed
# 1 - uppercase_allowed
# 2 - numbers_allowed
# 3 - symbols_allowed
var text_modifiers: Array[bool] = [
	true,
	true,
	true,
	true
]

# Sound
# 0 - music_on
# 1 - sound_effects_on
var sound_modifiers: Array[bool] = [
	true,
	true
]

# Display
# 0 - correct_score_displayed
# 1 - wrong_score_displayed
# 2 - accuracy displayed
# 3 - hard_text_displayed
var score_modifiers: Array[bool] = [
	true,
	true,
	true,
	true,
	true
]

## Variable functions: hard_characters & hard_character_magnitude ----------------------------------
# updates the magnitude for a specific character
func update_hard_char_magnitude(hard_char: String, magnitude: float) -> void:
	# look for the index of the hard character
	var i: int = 0
	while (i < hard_characters.size() && hard_characters[i] != hard_char):
		i += 2
	
	if (i == hard_characters.size()):
		return
	
	# update the magnitude
	hard_characters[i + 1] += magnitude
	hard_character_magnitude += magnitude
	# if over the magnitude character cap, adjust magnitude and character magnitude
	if (hard_characters[i + 1] > CHAR_MAGNITUDE_CAP):
		hard_character_magnitude -= hard_characters[i + 1] - CHAR_MAGNITUDE_CAP
		hard_characters[i + 1] = CHAR_MAGNITUDE_CAP
	
	# update the position of the hard character to maintain decreasing order
	while ((i > 0) && (hard_characters.size() > 2) && (hard_characters[i + 1] > hard_characters[i - 1])):
		var temp_char: String = hard_characters[i]
		var temp_magnitude: float = hard_characters[i + 1]
		hard_characters[i] = hard_characters[i - 2]
		hard_characters[i + 1] = hard_characters[i - 1]
		hard_characters[i - 2] = temp_char
		hard_characters[i - 1] = temp_magnitude
		i -= 2

# returns the magnitude for a specific character
func get_hard_char_magnitude(hard_char: String) -> float:
	var i: int = 0
	while (i < hard_characters.size() && hard_characters[i] != hard_char):
		i += 2
	
	if (i == hard_characters.size()):
		return 0.0
	
	return hard_characters[i + 1]

# returns the index of the character in hard_characters
func return_hard_char_index(character: String) -> int:
	var i: int = 0
	while (i < hard_characters.size() && hard_characters[i] != character):
		i += 2
	return i


# updates average accuracy
func update_average_accuracy():
	if (total_wrong > 0.0): average_accuracy = total_score / total_wrong * 100

### saving and loading -----------------------------------------------------------------------------
# saves data to save file
func save_data() -> void:
	var file = FileAccess.open(_save_path, FileAccess.WRITE)
	file.store_var(total_wrong)
	file.store_var(total_correct)
	file.store_var(total_score)
	file.store_var(average_accuracy)
	file.store_var(player_level)
	file.store_var(hard_characters)
	file.store_var(hard_character_magnitude)
	file.store_var(longest_streak)
	file.store_var(difficulty)
	file.store_var(text_modifiers)
	file.store_var(sound_modifiers)
	file.store_var(score_modifiers)
	print("Data saved!")

# loads data
func load_data() -> void:
	var file: FileAccess = FileAccess.open(_save_path, FileAccess.READ)
	if (file == null):
		# if the file does not exist
		file = FileAccess.new.call()
		save_data()
		return
	
	var item
	if (file != null):
		item = file.get_var()
		if (typeof(item) == TYPE_INT): total_wrong = item
	if (file != null):
		item = file.get_var()
		if (typeof(item) == TYPE_INT): total_correct = item
	if (file != null):
		item = file.get_var()
		if (typeof(item) == TYPE_INT): total_score = item
	if (file != null):
		item = file.get_var()
		if (typeof(item) == TYPE_FLOAT): average_accuracy = item
	if (file != null):
		item = file.get_var()
		if (typeof(item) == TYPE_INT): player_level = item
	if (file != null):
		item = file.get_var()
		if (typeof(item) == TYPE_ARRAY): hard_characters = item
	if (file != null):
		item = file.get_var()
		if (typeof(item) == TYPE_FLOAT): hard_character_magnitude = item
	if (file != null):
		item = file.get_var()
		if (typeof(item) == TYPE_INT): longest_streak = item
	if (file != null):
		item = file.get_var()
		if (typeof(item) == TYPE_INT): difficulty = item
	if (file != null):
		item = file.get_var()
		if (typeof(item) == TYPE_ARRAY && item.size() == text_modifiers.size()): text_modifiers = item
	if (file != null):
		item = file.get_var()
		if (typeof(item) == TYPE_ARRAY && item.size() == sound_modifiers.size()): sound_modifiers = item
	if (file != null):
		item = file.get_var()
		if (typeof(item) == TYPE_ARRAY && item.size() == score_modifiers.size()): score_modifiers = item
	
	file.close()
	print("Data loaded!")

# prints all data
func print_all_data() -> void:
	print("Total variables: " + str(12))
	print("total_wrong: " + str(total_wrong))
	print("total_correct: " + str(total_correct))
	print("total_score: " + str(total_score))
	print("average_accuracy: " + str(average_accuracy))
	print("player_level: " + str(player_level))
	print("hard_characters: " + str(hard_characters))
	print("hard_character_magnitude: " + str(hard_character_magnitude))
	print("longest_streak: " + str(longest_streak))
	print("difficulty: " + str(difficulty))
	print("text_modifiers: " + str(text_modifiers))
	print("sound_modifiers: " + str(sound_modifiers))
	print("score_modifiers: " + str(score_modifiers))

# resets all data
func reset_data() -> void:
	total_wrong = 0
	total_correct = 0
	total_score = 0
	average_accuracy = 0.0
	player_level = 0
	hard_characters = []
	hard_character_magnitude = 0.0
	longest_streak = 0
	difficulty = Difficulty.EASY
	text_modifiers = []
	sound_modifiers = []
	score_modifiers = []
	save_data()
	print("Data reset!")
