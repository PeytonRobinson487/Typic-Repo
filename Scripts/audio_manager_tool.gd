## CLASS DESCRIPTION
# controls the music and sound cross-scene - through multiple scenes

extends Node2D

## Variables ------------------------------------------------------------------
## OnReady
# data - - -
@onready var data: Node2D = $Data

# audio - - -
# controls music
@onready var background_music: AudioStreamPlayer = $"Background Music"
# controls sound effects
@onready var sound_control: AudioStreamPlayer = $"Sound Control"


## Constants
# song library
const SONGS: Array = [
	"res://Assets/Music/Lukrembo - Biscuit (freetouse.com).mp3",
	"res://Assets/Music/Lukrembo - Boba Tea (freetouse.com).mp3",
	"res://Assets/Music/Lukrembo - Bread (freetouse.com).mp3",
	"res://Assets/Music/Lukrembo - Butter (freetouse.com).mp3",
	"res://Assets/Music/Lukrembo - Chocolate (freetouse.com).mp3",
	"res://Assets/Music/Lukrembo - Imagine (freetouse.com).mp3",
	"res://Assets/Music/Lukrembo - Marshmallow (freetouse.com).mp3",
	"res://Assets/Music/Lukrembo - Onion (freetouse.com).mp3",
	"res://Assets/Music/Lukrembo - Rose (freetouse.com).mp3",
	"res://Assets/Music/Lukrembo - Sunset (freetouse.com).mp3",
	"res://Assets/Music/Psyqui - Start Up feat. Such.mp3"
]
# sound library
const SOUND_EFFECTS: PackedStringArray = [
	"res://Assets/SFX/fire-in-the-hole-geometry-dash.mp3",
	"res://Assets/SFX/light click - 666HeroHero.mp3",
	"res://Assets/SFX/mechanical keyboard - freesound_community.mp3"
]


## Dynamic
# holds current song
var current_song_index: int = 0
var current_volume: float = 1.0


## Functions -------------------------------------------------------------------
## Music
# sets volume
func set_volume(new_volume: float) -> void:
	current_volume = new_volume
	background_music.volume_db = new_volume
	sound_control.volume_db = new_volume

# returns volume
func get_volume() -> float:
	return current_volume

# returns music's playback position
func get_music_playback_pos() -> float:
	return background_music.get_playback_position()

# plays the song at the specified playback_pos
func play_music(song_index: int, music_on: bool, music_playback_pos: float) -> void:
	current_song_index = song_index
	
	if (!music_on):
		background_music.stop()
		return
	
	background_music.stop()
	background_music.volume_db = current_volume
	background_music.stream = load(SONGS[current_song_index])
	background_music.play(music_playback_pos)

# plays a random song
func play_random_music(music_on: bool) -> void:
	play_music(randi() % SONGS.size(), music_on, 0.0)

# returns the current song
func get_current_song() -> int:
	return current_song_index


## Sound Effects
# plays a sound effect in SOUND_EFFECTS
func play_sound(sound_index: int, sound_on: bool) -> void:
	# only proceed if sound is on
	if (!sound_on):
		return
	
	sound_control.pitch_scale = randf() / 10 + 0.95
	sound_control.volume_db = current_volume
	sound_control.stream = load(SOUND_EFFECTS[sound_index])
	sound_control.play()
