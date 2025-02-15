extends Node2D

### Variables -----------------------------------------------------------------
## Score Data
# score
var total_score: int = 0
var total_wrong: int = 0
var total_correct: int = 0
var average_accuracy: float = 100.0
var longest_streak: int = 0
var player_level: int = 1
# hard characters
var hard_lowercase: Dictionary = {}
var hard_uppercase: Dictionary = {}
var hard_number: Dictionary = {}
var hard_symbol: Dictionary = {}
var hard_library: Array[Dictionary] = [hard_lowercase, hard_uppercase, hard_number, hard_symbol]


## Settings Data
# Difficulty
enum Sensitivity { LOW = 0, MEDIUM = 2, HIGH = 4, DELICATE = 8 }
var sensitivity: Sensitivity = Sensitivity.LOW

# Allowed Characters
# 0 - lowercase_allowed
# 1 - uppercase_allowed
# 2 - numbers_allowed
# 3 - symbols_allowed
var text_modifiers: Array[bool] = [true, true, true, true]

# Sound - works with audio_manager_tool.gd
# 0 - music on
# 1 - sound effects on
var sound_modifiers: Array[bool] = [true, true]
# how loud music and sound plays
var current_volume: float = 100.0
# current song by index
var current_song_index: int = 0
# current song playback position
var music_playback_pos: float = 0.0

# Display
# 0 - total score
# 1 - correct score
# 2 - wrong score
# 3 - accuracy
# 4 - streak
# 5 - hard characters
var score_modifiers: Array[bool] = [true, true, true, true, true, true]


# Data handling structure
var all_data: Dictionary = {
	"total_score": total_score,
	"total_wrong": total_wrong,
	"total_correct": total_correct,
	"average_accuracy": average_accuracy,
	"player_level": player_level,
	"hard_lowercase": hard_lowercase,
	"hard_library": hard_library,
	"longest_streak": longest_streak,
	"sensitivity": sensitivity,
	"text_modifiers": text_modifiers,
	"sound_modifiers": sound_modifiers,
	"current_volume" : current_volume,
	"current_song_index" : current_song_index,
	"music_playback_pos" : music_playback_pos,
	"score_modifiers": score_modifiers
}


## Constants
const _save_path: String = "res://saved_data.txt"
const CHAR_MAGNITUDE_CAP: float = 20.0

# Dictionaries with appropriate characters
const lowercase_letters: PackedStringArray = [
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
	"k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
	"u", "v", "w", "x", "y", "z"
]
const uppercase_letters: PackedStringArray = [
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
	"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
	"U", "V", "W", "X", "Y", "Z"
]
const numbers: PackedStringArray = [
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
]
const symbols: PackedStringArray = [
	"!", "@", "#", "$", "%", "^", "&", "*", "(", ")",
	"-", "_", "+", "=", "[", "]", "{", "}", ":", ";",
	"'", "\"", "<", ">", ",", ".", "?", "/", "`", "~"
]
# holds the dictionaries - enables picking them by index
const libraries: Array[Array] = [ lowercase_letters, uppercase_letters, numbers, symbols ]


## Functions -------------------------------------------------------------------
## Player Level
# updates player level
func update_level() -> void:
	# equation: sqrt(x)
	var level: int = all_data["player_level"]
	while (float(level) < sqrt(float(all_data["total_correct"]))):
		level += 1
	all_data["player_level"] = level - 1


## Saving and Loading Data
# saves data to save file
func save_data() -> void:
	var file = FileAccess.open(_save_path, FileAccess.WRITE)
	for key in all_data:
		file.store_var(all_data[key])
	file.close()
	#print("Data saved!")

# loads data
func load_data() -> void:
	var file: FileAccess = FileAccess.open(_save_path, FileAccess.READ)
	if (file == null):
		# if the file does not exist
		file = FileAccess.new.call()
		save_data()
		return
	
	for key in all_data:
		if (file != null):
			var value = file.get_var()
			if (typeof(value) == typeof(all_data[key])): all_data[key] = value
	
	file.close()
	#print("Data loaded!")

# prints all data
func print_all_data() -> void:
	for key in all_data:
		print(str(key) + " : " + str(all_data[key]))


## Resetting Data
# resets all score data
func reset_score_data() -> void:
	# reset all variables
	all_data["total_score"] = total_score
	all_data["total_wrong"] = total_wrong
	all_data["total_correct"] = total_correct
	all_data["average_accuracy"] = average_accuracy
	all_data["player_level"] = player_level
	all_data["longest_streak"] = longest_streak
	all_data["hard_library"] = hard_library
	save_data()
	#print("Scores reset!")

# resets all settings
func reset_settings() -> void:
	all_data["sensitivity"] = sensitivity
	all_data["text_modifiers"] = text_modifiers
	all_data["sound_modifiers"] = sound_modifiers
	all_data["current_volume"] = current_volume
	all_data["current_song_index"] = current_song_index
	all_data["music_playback_pos"] = music_playback_pos
	all_data["score_modifiers"] = score_modifiers
	save_data()
	#print("Settings reset!")
