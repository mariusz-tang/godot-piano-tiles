class_name Main
extends Node

signal score_changed(new_score: int, new_highscore: int)
signal game_over

const _SAVE_FILE_PATH := "user://savegame.save"
const _CONFIG_FILE_PATH := "user://config.cfg"

@export var _hud: HUD
@export var _game: TilePlayer

var _config_file: ConfigFile
var _highscore: int = 0:
	get:
		return _highscore
	set(value):
		_highscore = value
		_hud.update_highscore(value)


func _ready() -> void:
	_hud.start_pressed.connect(_start_game)
	_hud.reset_highscore_pressed.connect(_reset_highscore)
	_hud.tile_colour_changed.connect(_update_tile_colour)
	_hud.quit_pressed.connect(get_tree().quit)

	_game.score_changed.connect(_hud.update_score)
	_game.game_over.connect(_on_game_over)
	_game.game_over.connect(_hud.show_fail_menu)
	_game.generate()

	_load_config()
	_load_highscore()
	_hud.show_menu()


func _start_game() -> void:
	_game.play(true)


func _update_tile_colour(colour: Color) -> void:
	_game.tile_colour = colour
	_config_file.set_value("Visuals", "tile_colour", colour)
	_config_file.save(_CONFIG_FILE_PATH)


func _reset_highscore() -> void:
	_highscore = 0
	_save_highscore()


func _on_game_over(final_score: int) -> void:
	_game.pause()

	if final_score > _highscore:
		_highscore = final_score
		_save_highscore()


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


func _load_config() -> void:
	_config_file = ConfigFile.new()

	var err := _config_file.load(_CONFIG_FILE_PATH)
	if err != OK:
		return

	var colour: Color = _config_file.get_value(
		"Visuals", "tile_colour", Color.BLACK
	)
	_update_tile_colour(colour)
	_hud.set_tile_colour(colour)
