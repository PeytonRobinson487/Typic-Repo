extends Node2D

const _SAVE_FILE: String = ""

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
var display_scores: Array = [
	false,
	false,
	false,
	false,
	false
]

## Functions
func save_data_to_file():
	# save data to the save file
	pass


func load_data_from_file():
	# load data
	pass
