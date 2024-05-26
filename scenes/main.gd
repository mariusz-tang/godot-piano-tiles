class_name Main
extends Node

signal score_changed(new_score: int, new_highscore: int)
signal game_over

const _SAVE_FILE_PATH := "user://savegame.save"
const _CONFIG_FILE_PATH := "user://config.cfg"
const _TILE_HEIGHT: int = 720 / 4
const _TILE_WIDTH: int = 120
const _TILE_ACTIONS: Array[String] = ["tile_1", "tile_2", "tile_3", "tile_4"]

@export var _hud: HUD
@export var _game: TilePlayer

@export_group("Audio")
@export var _tile_sound_player: AudioStreamPlayer2D
@export var _success_sound: AudioStream
@export var _fail_sound: AudioStream

var _config_file: ConfigFile
var _score: int = 0:
	get:
		return _score
	set(value):
		_score = value
		_highscore = max(value, _highscore)
		score_changed.emit(value, _highscore)
var _highscore: int = 0


func _ready() -> void:
	score_changed.connect(_hud.update_scores)
	game_over.connect(func() -> void: _hud.show_fail_menu(_score))
	_hud.start_pressed.connect(_start_game)
	_hud.reset_highscore_pressed.connect(_reset_highscore)
	_hud.tile_colour_changed.connect(_update_tile_colour)
	_hud.quit_pressed.connect(get_tree().quit)

	_game.good_press.connect(_add_point)
	_game.bad_press.connect(_game_over)
	_game.generate()

	_load_config()
	_load_highscore()
	_hud.show_menu()


func _start_game() -> void:
	_score = 0
	_game.play(true)


func _add_point() -> void:
	_score += 1
	_play_sound(_success_sound)


func _game_over() -> void:
	_save_highscore()
	_game.pause()
	_play_sound(_fail_sound)
	game_over.emit()


func _reset_highscore() -> void:
	_highscore = 0
	_save_highscore()
	score_changed.emit(_score, _highscore)


func _update_tile_colour(colour: Color) -> void:
	_game.tile_colour = colour
	_config_file.set_value("Visuals", "tile_colour", colour)
	_config_file.save(_CONFIG_FILE_PATH)


func _play_sound(sound: AudioStream) -> void:
	_tile_sound_player.stream = sound
	_tile_sound_player.play()


func _save_highscore() -> void:
	var save_file := FileAccess.open(_SAVE_FILE_PATH, FileAccess.WRITE)
	save_file.store_line(str(_highscore))


func _load_highscore() -> void:
	if not FileAccess.file_exists(_SAVE_FILE_PATH):
		return

	var save_file := FileAccess.open(_SAVE_FILE_PATH, FileAccess.READ)
	var line: String = save_file.get_line()

	if not line.is_valid_int():
		return

	_highscore = int(line)
	score_changed.emit(_score, _highscore)


func _load_config() -> void:
	_config_file = ConfigFile.new()

	var err := _config_file.load(_CONFIG_FILE_PATH)
	if err != OK:
		return

	var colour: Color = _config_file.get_value(
		"Visuals", "tile_colour", Color.BLACK
	)
	_update_tile_colour(colour)
