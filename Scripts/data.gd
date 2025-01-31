extends Node2D

const _save_path: String = "res://saved_data.txt"

### Variables --------------------------------------------------------------------------------------
## Score Data
var total_score: int = 0
var total_wrong: int = 0
var total_correct: int = 0
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
var text_modifiers: Array = [
	true,
	true,
	true,
	true
]

# Sound
# 0 - music_on
# 1 - sound_effects_on
var sound_modifiers: Array = [
	true,
	true
]

# Display
# 0 - total_score_displayed
# 1 - current_score_displayed
# 2 - missed_characters_displayed
# 3 - correct_characters_displayed
# 4 - hard_text_displayed
var score_modifiers: Array = [
	true,
	true,
	true,
	true,
	true
]

## Variable functions: hard_characters & hard_character_magnitude
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

### saving and loading -----------------------------------------------------------------------------
# saves data to save file
func save_data() -> void:
	var file = FileAccess.open(_save_path, FileAccess.WRITE)
	file.store_var(total_score)
	file.store_var(total_wrong)
	file.store_var(total_correct)
	file.store_var(average_accuracy)
	file.store_var(player_level)
	file.store_var(hard_characters)
	file.store_var(hard_character_magnitude)
	file.store_var(longest_streak)
	file.store_var(difficulty)
	print("Saving text_modifiers: " + str(text_modifiers))
	file.store_var(text_modifiers)
	file.store_var(sound_modifiers)
	file.store_var(score_modifiers)
	print("Data saved!")

# loads data from save file
func load_data() -> void:
	if (FileAccess.file_exists(_save_path) &&
			FileAccess.get_file_as_string(_save_path).length() != 0):
		
		var file: FileAccess = FileAccess.open(_save_path, FileAccess.READ)
		if !assign_variable(total_score, TYPE_INT, file, 0): total_score = 0
		if !assign_variable(total_wrong, TYPE_INT, file, 1): total_wrong = 0
		if !assign_variable(total_correct, TYPE_INT, file, 2): total_correct = 0
		if !assign_variable(average_accuracy, TYPE_FLOAT, file, 3): average_accuracy = 0.0
		if !assign_variable(player_level, TYPE_INT, file, 4): player_level = 1
		print("load hard_characters before: " + str(hard_characters))
		if !assign_variable(hard_characters, TYPE_ARRAY, file, 5): hard_characters.clear()
		print("load hard_characters after: " + str(hard_characters))
		if !assign_variable(hard_character_magnitude, TYPE_FLOAT, file, 6): hard_character_magnitude = 0.0
		if !assign_variable(longest_streak, TYPE_INT, file, 7): longest_streak = 0
		if !assign_variable(difficulty, TYPE_INT, file, 8): difficulty = Difficulty.EASY
		print("load text_modifiers before: " + str(text_modifiers))
		if !assign_variable(text_modifiers, TYPE_ARRAY, file, 9): text_modifiers = [true, true, true, true]
		print("load text_modifiers after: " + str(text_modifiers))
		if !assign_variable(sound_modifiers, TYPE_ARRAY, file, 10): sound_modifiers = [true, true]
		if !assign_variable(score_modifiers, TYPE_ARRAY, file, 11): score_modifiers = [true, true, true, true, true]
	else:
		print("Save file does not exist on path \"" + _save_path +"\"")
	print("Data loaded!")

# asigns a variable with the file.get_var() and error handling
func assign_variable(item, item_type, file: FileAccess, line: int) -> bool:
	var new_item = file.get_var()
	if (typeof(new_item) == item_type):
		item[0] = new_item
	else:
		print("Item type \"" + str(typeof(item)) + "\" does not match expected item type \"" + str(item_type) + "\". Variable reset on item " + str(line) + ".");
		return false;
	return true;

func print_all_data() -> void:
	print("Total variables: " + str(12))
	print("total_wrong: " + str(total_score))
	print("total_wrong: " + str(total_wrong))
	print("total_correct: " + str(total_correct))
	print("average_accuracy: " + str(average_accuracy))
	print("player_level: " + str(player_level))
	print("hard_characters: " + str(hard_characters))
	print("hard_character_magnitude: " + str(hard_character_magnitude))
	print("longest_streak: " + str(longest_streak))
	print("difficulty: " + str(difficulty))
	print("text_modifiers: " + str(text_modifiers))
	print("sound_modifiers: " + str(sound_modifiers))
	print("score_modifiers: " + str(score_modifiers))
