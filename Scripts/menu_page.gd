## CLASS DESCRIPTION
# The menu page where the player can choose where to go.
# The player can click on the buttons or type the button's text.
# There are easter eggs hidden within the text box.
# Also, the title is editable

extends Node2D


## Variables ------------------------------------------------------------------
## OnReady
# data - - -
@onready var data: Node2D = $Data

# sound - - -
@onready var audio_manager_tool: Node2D = $"Audio Manager Tool"

# graphics - - -
@onready var scene_transition_tool: Node2D = $"Graphics/Scene Transition Tool"

# buttons - - -
# controls the user input
@onready var user_input: LineEdit = $"Buttons/User Input"
# available scenes to switch to
@onready var page_list: ItemList = $"Buttons/Page List"


## Constants
# special:
# + "fire" - plays "fire-in-the-hole"
# + "r" - random characters
# + "?"
# + "!"
const CUSTOM_RESPONSE_NORMAL: Dictionary = {
	"HI": ["HEY", "YO", "HI"],
	
	"typic": ["You are playing as we speak."],
	
	"hi": ["Hi! How are you?", "Hey! How have you been?", "Greetings, Sire. The desert--awaits."],
	"hello": ["Hi! How are you?", "Hey! How have you been?", "Greetings, Sire. The desert--awaits."],
	"hoi": ["Hi! How are you?", "Hey! How have you been?", "Greetings, Sire. The desert--awaits."],
	"hey": ["Hi! How are you?", "Hey! How have you been?", "Greetings, Sire. The desert--awaits."],
	"yo": ["Hi! How are you?", "Hey! How have you been?", "Greetings, Sire. The desert--awaits."],
	
	"no": ["Yes", "Yessss"],
	"yes": ["No", "Noooo"],
	
	"whats up": ["How's it goin?", "Yo. How you doin?"],
	"what's up": ["How's it goin?", "Yo. How you doin?"],
	"wut up": ["How's it goin?", "Yo. How you doin?"],
	"what up": ["How's it goin?", "Yo. How you doin?"],
	"wuz up": ["How's it goin?", "Yo. How you doin?"],
	
	"who": ["I am the sub-machine."],
	
	" ": ["._.", ".-."],
	
	":)": ["=)", "=]", "|&", "(=", "[=", "=}"] ,
	"=)": ["=)", "=]", "|&", "(=", "[=", "=}"] ,
	
	"lol": ["haha", "teehee", "heh"],
	
	"good": ["That's good to hear!", "Excellent!", "Splendid!", "Nice!"],
	"great": ["Fantastic!", "Wonderful!", "Super!", "Awesome!"],
	"bad": ["Oh no!", "That's terrible!", "Boo!", "Aw, shucks."],
	"sad": ["Cheer up!", "Don't be sad!", "It'll be okay!", ":("],
	
	"help": ["I'm here to assist!", "How can I help you?", "What do you need?", "Let me know."],
	"thanks": ["You're welcome!", "No problem!", "My pleasure!", "Anytime!"],
	"thank you": ["You're very welcome!", "It was my pleasure.", "Glad I could help!", "Don't mention it."],
	
	"what": ["What do you mean?", "What are you talking about?", "What's the question?", "Huh?"],
	"why": ["That's a good question.", "Let me think...", "Because... reasons.", "Why not?"],
	"when": ["Soon.", "Later.", "When the time is right.", "Eventually."],
	"where": ["Over there.", "Somewhere.", "In a magical land.", "I don't know."],
	
	"bored": ["Let's play a game!", "I have some jokes.", "Want to hear a story?", "Try typing 'typic'."],
	"sleepy": ["Get some rest!", "Go to bed!", "Zzz...", "Sweet dreams!"],
	"hungry": ["Go eat something!", "I'm hungry too!", "Food is good.", "Want a recipe?"],
	
	"bye": ["Goodbye!", "See you later!", "Farewell!", "Until next time!"],
	"goodbye": ["Have a good day!", "Take care!", "So long!", "Adios!"],
	
	"gg": ["Good game!", "Well played!", "Nice try!", "GG!"],
	"wp": ["Well played!", "Good job!", "You did great!", "WP!"],
	
	"brb": ["Okay, I'll be here.", "See you soon!", "Back in a bit.", "BRB!"],
	"afk": ["Alright, I'll wait.", "Let me know when you're back.", "AFK!", "Gone for now."],
	
	"noob": ["Everyone starts somewhere.", "We were all noobs once.", "Practice makes perfect.", "Don't worry, you'll get better."],
	"pro": ["Wow, you're skilled!", "A true master!", "Impressive!", "You're a pro!"],
	
	"nice": ["Sweet!", "Cool!", "Awesome!", "Nice!"],
	"cool": ["Rad!", "Awesome!", "Groovy!", "Cool!"],
	
	"gg ez": ["...", "That wasn't very nice.", "Try to be respectful.", "GG, I guess."],
	"ez": ["Easy peasy lemon squeezy.", "Too easy!", "Piece of cake!", "EZ!"],
	
	"palworld" : ["The better pokemon.", "Try it!", "YES.", "Feybreak was awesome."],
	
	"hollow knight" : ["Nice.", "You played!?", "Pantheons...", "Great music!", "Great art!", "Great gameplay", "Great great!"],
	
	"enter" : ["Yup. You did that.", "Recieved", "Yeah..."]
}


## Functions -------------------------------------------------------------------
## Initialization
# constructor
func _ready() -> void:
	# load data
	data.load_data()
	user_input.grab_focus()
	
	# initialize sound and play scene transition
	audio_manager_tool.set_volume(linear_to_db(data.all_data["current_volume"] / 100.0))
	audio_manager_tool.play_music(data.all_data["current_song_index"], data.all_data["sound_modifiers"][0], data.all_data["music_playback_pos"])
	$"Graphics/Background/Animation Player".play("pop_in")
	$"Graphics/Transition/Animation Player".play_backwards("fade")


## Text Box
# user enters text
func _on_user_input_text_submitted(new_text: String) -> void:
	audio_manager_tool.play_sound(1, data.all_data["sound_modifiers"][1])
	
	var two_letters: String = new_text.substr(0, 2).to_lower()
	if (two_letters == "pl"):
		_on_page_list_item_clicked(0, 0, 0)
	elif (two_letters == "se"):
		_on_page_list_item_clicked(1, 0, 0)
	elif (two_letters == "sc"):
		_on_page_list_item_clicked(2, 0, 0)
	elif (two_letters == "cr"):
		_on_page_list_item_clicked(3, 0, 0)
	elif (two_letters == "qu"):
		_on_page_list_item_clicked(4, 0, 0)
	else:
		custom_input(new_text)

# responds to various inputs from the user
func custom_input(new_text: String) -> void:
	user_input.text = ""
	
	# normal cases
	for key in CUSTOM_RESPONSE_NORMAL:
		if (new_text.substr(0, key.length()).to_lower() == key):
			var value: Array = CUSTOM_RESPONSE_NORMAL.get(key)
			user_input.placeholder_text = " " + value.pick_random()
			return
	
	# special cases
	if (new_text.length() == 0):
		var responses: Array = ["You did not even type anything.", "...", "..", ".", ""]
		user_input.placeholder_text = responses.pick_random()
	elif (new_text.substr(0, 1).to_lower() == "r"):
		for i in randi() % 10:
			user_input.placeholder_text = data.libraries[randi() % 4].pick_random()
	elif (new_text.substr(0, 1) == "?"):
		for i in new_text.length():
			user_input.placeholder_text += "!"
	elif (new_text.substr(0, 1) == "!"):
		for i in new_text.length():
			user_input.placeholder_text += "?"
	elif (new_text.substr(0, 4).to_lower() == "fire"):
		audio_manager_tool.play_sound(0, data.all_data["sound_modifiers"][1])
		var responses: Array = ["FiRe In ThE hOlE!i!", "Fire in the hole!", "FIRE IN THE HOLE!", "fIrE iN tHe HoLei!i"]
		user_input.placeholder_text = responses.pick_random()
	else:
		var responses: Array = ["Unkonwn page.", "What?", "Huh?", "Try again.", "What does that mean?", "Say what?", "???"]
		user_input.placeholder_text = responses.pick_random()
	
	user_input.placeholder_text = " " + user_input.placeholder_text

# changes placeholder text if the user types
func _on_user_input_text_changed(_new_text: String) -> void:
	user_input.placeholder_text = " Type the page here"


## Scene switching
# switches the scene
func _on_page_list_item_clicked(index, _at_position, _mouse_button_index):
	audio_manager_tool.play_sound(1, data.all_data["sound_modifiers"][1])
	
	# page transition
	$"Graphics/Background/Animation Player".play_backwards("pop_in")
	$"Graphics/Transition/Animation Player".play("fade")
	await get_tree().create_timer(0.3).timeout
	
	data.all_data["music_playback_pos"] = audio_manager_tool.get_music_playback_pos()
	match index:
		0:
			data.save_data()
			get_tree().change_scene_to_file("res://Scenes/Game Page.tscn")
		1:
			data.save_data()
			get_tree().change_scene_to_file("res://Scenes/Settings Page.tscn")
		2: 
			data.save_data()
			get_tree().change_scene_to_file("res://Scenes/Score Page.tscn")
		3:
			data.save_data()
			get_tree().change_scene_to_file("res://Scenes/Credits Page.tscn")
		4:
			data.all_data["music_playback_pos"] = 0.0
			data.save_data()
			get_tree().quit()
		'_':
			print("Entered default branch. Unknown error has occured.");
			data.save_data()
			get_tree().quit()
