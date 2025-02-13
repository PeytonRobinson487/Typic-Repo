extends Node2D

# bgm - background music
@onready var bgm: AudioStreamPlayer = $bgm
@onready var data_init: Node2D = $Data


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	data_init.load_data()
	bgm.stream = load(data_init.all_data["current_song"])
	bgm.volume_db = data_init.all_data["current_volume"]
	if (data_init.all_data["sound_modifiers"][0]):
		bgm.play()


# sets volume
func set_volume(new_volume: float) -> void:
	bgm.volume_db = linear_to_db(new_volume / 100.0)


# play new bg song
func set_song(new_song: String, data) -> void:
	if (!data.all_data["sound_modifiers"][0]):
		return
	
	if (new_song == ""):
		bgm.stop()
		return
	elif (data.all_data["current_song"] == new_song):
		bgm.stream = load(new_song)
		bgm.play(data.all_data["playback_pos"] + 0.17)
		return
	
	bgm.stop()
	bgm.stream = load(new_song)
	bgm.play()


# returns the playback position
func get_playback_pos() -> float:
	return bgm.get_playback_position()
