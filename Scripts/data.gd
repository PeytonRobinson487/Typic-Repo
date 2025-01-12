extends Node2D

const _save_path: String = "res://saved_data.txt"

### Variables --------------------------------------------------------------------------------------
## Score Data
var total_score: int = 0
var total_wrong: int = 0
var total_correct: int = 0
var average_accuracy: float = 100.0
var player_level: int = 1
var hardest_characters: String = ""
var longest_streak: int = 0

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
var text_modifiers: Dictionary = {
	0 : true,
	1 : true,
	2 : true,
	3 : true
}

# Sound
# 0 - music_on
# 1 - sound_effects_on
var sound_modifiers: Dictionary = {
	0 : true,
	1 : true
}

# Display
# 0 - total_score_displayed
# 1 - current_score_displayed
# 2 - missed_characters_displayed
# 3 - correct_characters_displayed
# 4 - hard_text_displayed
var score_modifiers: Dictionary = {
	0 : true,
	1 : true,
	2 : true,
	3 : true,
	4 : true
}


### saving and loading -----------------------------------------------------------------------------
# saves data to save file
func save_data():
	var file = FileAccess.open(_save_path, FileAccess.WRITE)
	file.store_var(total_score)
	file.store_var(total_wrong)
	file.store_var(total_correct)
	file.store_var(average_accuracy)
	file.store_var(player_level)
	file.store_var(player_level)
	file.store_var(hardest_characters)
	file.store_var(longest_streak)
	file.store_var(difficulty)
	file.store_var(text_modifiers)
	file.store_var(sound_modifiers)
	file.store_var(score_modifiers)

# loads data from save file
func load_data():
	if (FileAccess.file_exists(_save_path) && FileAccess.get_file_as_string(_save_path).length() != 0):
		var file = FileAccess.open(_save_path, FileAccess.READ)
		total_score = file.get_var()
		total_wrong = file.get_var()
		total_correct = file.get_var()
		average_accuracy = file.get_var()
		player_level = file.get_var()
		player_level = file.get_var()
		hardest_characters = file.get_var()
		longest_streak = file.get_var()
		difficulty = file.get_var()
		text_modifiers = file.get_var()
		sound_modifiers = file.get_var()
		score_modifiers = file.get_var()
	else:
		print("Save file does not exist on path \"" + _save_path +"\"")
