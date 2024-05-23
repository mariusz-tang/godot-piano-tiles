class_name Main
extends Node

signal score_changed(new_score: int, new_highscore: int)

const _TILE_HEIGHT: int = 720 / 4
const _TILE_WIDTH: int = 120
const _TILE_ACTIONS: Array[String] = ["tile_1", "tile_2", "tile_3", "tile_4"]

@export var _hud: HUD
@export var _tile_scene: PackedScene
@export var _tile_sound_player: AudioStreamPlayer2D
@export var _success_sound: AudioStream
@export var _fail_sound: AudioStream

var _tiles: Array[Tile] = []
var _tile_positions: Array[int] = []
var _score: int = 0:
	get:
		return _score
	set(value):
		_score = value
		_highscore = max(value, _highscore)
		score_changed.emit(value, _highscore)
var _highscore: int = 0


func _ready() -> void:
	_generate_initial_tiles()
	score_changed.connect(_hud.update_scores)


func _input(event: InputEvent) -> void:
	for action_ix in range(_TILE_ACTIONS.size()):
		if event.is_action_pressed(_TILE_ACTIONS[action_ix]):
			_handle_tile_pressed(action_ix)


func _generate_initial_tiles() -> void:
	while _tiles.size() == 0 or _tiles[-1].position.y > 0:
		_generate_new_tile()


func _generate_new_tile() -> void:
	var tile: Tile = _tile_scene.instantiate()
	add_child(tile)
	tile.set_size(_TILE_WIDTH, _TILE_HEIGHT)

	var position := randi() % 4
	var x := position * _TILE_WIDTH

	var last_tile_y_pos: int = 720
	if _tiles.size() != 0:
		last_tile_y_pos = _tiles[-1].position.y
	var y := last_tile_y_pos - _TILE_HEIGHT

	tile.position = Vector2(x, y)

	_tiles.append(tile)
	_tile_positions.append(position)


func _handle_tile_pressed(index: int) -> void:
	assert(index >= 0 and index <= 3)
	if _tile_positions[0] == index:
		_shift()
		_tile_sound_player.stream = _success_sound
		_score += 1
	else:
		_tile_sound_player.stream = _fail_sound
		_score = 0
	_tile_sound_player.play()


func _shift() -> void:
	_generate_new_tile()
	for tile_index in range(_tiles.size()):
		var tile := _tiles[tile_index]
		var tween := tile.create_tween()
		var final_position := Vector2(
			tile.position.x, 720 - _TILE_HEIGHT * tile_index
		)
		tween.tween_property(tile, "position", final_position, 0.1)
		if tile_index == 0:
			tile.fade_and_free(tween)

	_tiles.remove_at(0)
	_tile_positions.remove_at(0)
