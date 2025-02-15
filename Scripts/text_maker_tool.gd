## CLASS DESCRIPTION
# The text maker is a tool that generates text for "game_page.gd"
# It can generate hard or normal characters

extends RichTextLabel

## Variables ------------------------------------------------------------------
# the computer text input line
@onready var text_maker = $"."


## Functions ------------------------------------------------------------------
## Driver Function
# generates text based on settings and hard characters
func generate_text(length: int, data: Node2D) -> String:
	# get relevant normal characters
	var normal_char_pool: Array = []
	for index in data.all_data["text_modifiers"].size():
		if (data.all_data["text_modifiers"][index]):
			normal_char_pool.append_array(data.libraries[index])
	# get relevant hard characters
	var hard_char_pool: Dictionary = {}
	for index in data.all_data["text_modifiers"].size():
		if (data.all_data["text_modifiers"][index]):
			hard_char_pool.merge(data.all_data["hard_library"][index])
	
	# generate characters
	var new_text: String = ""
	while (new_text.length() < length):
		new_text += get_character(hard_char_pool, normal_char_pool, data)
		if (new_text.length() == 0):
			new_text += "Error"
	
	return new_text

## Helper Functions
# returns a normal or hard char
func get_character(hard_char_pool: Dictionary, normal_char_pool: Array, data: Node2D) -> String:
	var new_char: String = ""
	var chance: float = randf() * data.CHAR_MAGNITUDE_CAP * (hard_char_pool.size() / 3.0) + 1
	
	var sum_magnitude: float
	for key in hard_char_pool:
		sum_magnitude += hard_char_pool.get(key)
	
	# hard character
	if (chance < sum_magnitude):
		new_char = get_hard_character(hard_char_pool)
		return new_char + normal_char_pool.pick_random()
	# normal character
	return normal_char_pool.pick_random()

# uses hard text to get a weak character for the player
func get_hard_character(hard_characters: Dictionary) -> String:
	var rand_key: int = sum_prefix_rand_key(sum_prefix(hard_characters))
	return hard_characters.keys()[rand_key]

# calculates a sum prefix using a dictionary
func sum_prefix(hard_characters: Dictionary) -> Array:
	var sum_prefix: Array = []
	var sum: float = 0.0
	var i: int = 1
	for key in hard_characters:
		sum += hard_characters[key]
		sum_prefix.push_back(sum)
	return sum_prefix

# chooses a random index in a sum prefix
func sum_prefix_rand_key(sum_prefix: Array) -> int:
	var rand_key: int = 0
	
	# compare random value and find which key to use
	var rand: float = randf() * sum_prefix[sum_prefix.size() - 1]
	var i = 0
	while (i < sum_prefix.size() && sum_prefix[i] < rand):
		i += 1
	
	return rand_key
