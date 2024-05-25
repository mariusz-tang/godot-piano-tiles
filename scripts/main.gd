class_name Main
extends Node

signal score_changed(new_score: int, new_highscore: int)
signal game_over

const _TILE_HEIGHT: int = 720 / 4
const _TILE_WIDTH: int = 120
const _TILE_ACTIONS: Array[String] = ["tile_1", "tile_2", "tile_3", "tile_4"]

@export var _hud: HUD
@export var _game: TilePlayer
@export var _tile_sound_player: AudioStreamPlayer2D
@export var _success_sound: AudioStream
@export var _fail_sound: AudioStream

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

	_game.good_press.connect(_add_point)
	_game.bad_press.connect(_game_over)
	_game.generate()


func _start_game() -> void:
	_game.play(true)


func _add_point() -> void:
	_score += 1
	_play_sound(_success_sound)


func _game_over() -> void:
	_score = 0
	_game.pause()
	_play_sound(_fail_sound)
	game_over.emit()


func _play_sound(sound: AudioStream) -> void:
	_tile_sound_player.stream = sound
	_tile_sound_player.play()
