# We are currently working on generating the hard character
# We need to figure out if the rand < sum_prefix[index] actually works right now
# The idea works, but I think I implemented it wrong
# It has deal with the while loop on line 88

extends RichTextLabel


@onready var text_maker = $"."


# generates text based on settings and hard characters
func generate_text(length: int, data: Node2D) -> String:
	# add the indexes of the true values
	var relevant_text_modifiers: Array
	for index in data.all_data["text_modifiers"].size():
		if (data.all_data["text_modifiers"][index]):
			relevant_text_modifiers.push_back(index)
	
	# get the size of all relevant arrays
	var relevant_chars: Dictionary = {}
	for index in relevant_text_modifiers:
		relevant_chars.merge(data.all_data["hard_library"][index])
	
	# generate characters
	var new_text: String = ""
	var index: int = 0
	while (new_text.length() < length && index < 100):
		# get chance for hard character
		var return_array: Array
		var chance: float = randf() * data.CHAR_MAGNITUDE_CAP * (relevant_chars.size() / 3.0) + 1
		
		# get a character
		if (chance < data.sum_magnitude(relevant_chars)):
			new_text += get_hard_character(relevant_chars)
		else:
			# normal character
			var rand_index: int = relevant_text_modifiers.pick_random()
			new_text += data.libraries[rand_index].pick_random()
		
		index += 1
	
	if (index == 100):
		# prevents the program from crashing, and prints an error message to the textbox
		print("text_maker while loop index: " + str(index))
		new_text = "S-8ySD,_Error_MSymf9"
	return new_text


# uses hard text to get a weak character for the player
func get_hard_character(hard_characters: Dictionary) -> String:
	# create sum prefix for chance_pool
	var sum_prefix: Array = []
	var sum: float = 0.0
	var i: int = 1
	for key in hard_characters:
		sum += hard_characters[key]
		sum_prefix.push_back(sum)
	
	# compare random value and find which key to use
	var rand: float = randf() * sum_prefix[sum_prefix.size() - 1]
	i = 0
	while (i < sum_prefix.size() && sum_prefix[i] < rand):
		i += 1
	
	return hard_characters.keys()[i]
