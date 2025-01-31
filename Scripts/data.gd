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

# loads data
func load_data() -> void:
	if FileAccess.file_exists(_save_path) and FileAccess.get_file_as_string(_save_path).length() != 0:
		var file: FileAccess = FileAccess.open(_save_path, FileAccess.READ)
		
		# Use a dictionary to map variable names to their references and types
		var variables = {
			"total_wrong": [total_wrong, TYPE_INT],
			"total_correct": [total_correct, TYPE_INT],
			"average_accuracy": [average_accuracy, TYPE_FLOAT],
			"player_level": [player_level, TYPE_INT],
			"hard_characters": [hard_characters, TYPE_ARRAY],
			"hard_character_magnitude": [hard_character_magnitude, TYPE_FLOAT],
			"longest_streak": [longest_streak, TYPE_INT],
			"difficulty": [difficulty, TYPE_INT], # Assuming Difficulty is an enum
			"text_modifiers": [text_modifiers, TYPE_ARRAY],
			"sound_modifiers": [sound_modifiers, TYPE_ARRAY],
			"score_modifiers": [score_modifiers, TYPE_ARRAY]
		}
		
		for name in variables:
			var variable_data = variables[name]
			var variable = variable_data[0] # The actual variable itself
			var type = variable_data[1] # The type of the variable
			
			if !assign_variable(variable, type, file): # No line number needed
				# Reset to default value if loading fails
				match type:
					TYPE_INT: variable = 0
					TYPE_FLOAT: variable = 0.0
					TYPE_ARRAY: variable.clear()
					# ... handle other types as needed ...
					
				print("Failed to load " + name + ". Resetting to default.")
				
		file.close() # Good practice to close the file
		print("Data loaded!")
		
	else:
		print("Save file does not exist on path \"" + _save_path +"\"")
	print("Data loaded!")


# Assigns a variable from the file, with error handling
func assign_variable(variable, item_type, file: FileAccess) -> bool:
	var new_item = file.get_var()
	if typeof(new_item) == item_type:
		# Directly assign to the variable now
		if item_type == TYPE_ARRAY: #arrays are passed by reference
			variable.clear()
			variable.append_array(new_item)
		else:
			variable = new_item
		return true
	else:
		return false # Just return false on failure

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
