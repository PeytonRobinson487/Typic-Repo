extends Node2D

const _SAVE_FILE: String = ""

## Score
static var total_score: int
static var total_wrong: int
static var total_correct: int
static var average_accuracy: float
static var level: int
static var hardest_characters: String

## Settings Data
## Difficulty
enum Difficulty {
	EASY,
	MEDIUM,
	HARD,
	PRO
}
static var difficulty: Difficulty = Difficulty.EASY
## Allowed Characters
static var lowercase_allowed: bool = true
var uppercase_allowed: bool = true
var numbers_allowed: bool = true
var symbols_allowed: bool = true
## Sound
var music_on: bool = true
var sound_effects_on: bool = true
## Display
# 1 - total_score_displayed
# 2 - current_score_displayed
# 3 - missed_characters_displayed
# 4 - correct_characters_displayed
# 5 - hard_text_displayed
var display_scores: Array = [
	false,
	false,
	false,
	false,
	false
]


func save_data_to_file():
	# save data to the save file
	pass


func load_data_from_file():
	# load data
	pass
