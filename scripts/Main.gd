class_name Main
extends Node

const _TILE_HEIGHT: int = 720 / 4
const _TILE_WIDTH: int = 120
const _TILE_ACTIONS: Array[String] = ["tile_1", "tile_2", "tile_3", "tile_4"]

@export var _tile_scene: PackedScene

var _tiles: Array[Tile] = []
var _tile_positions: Array[int] = []


func _ready() -> void:
	_generate_initial_tiles()


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


func _shift() -> void:
	var bottom_tile: Tile = _tiles.pop_front()
	bottom_tile.queue_free()
	_tile_positions.remove_at(0)

	_generate_new_tile()
	for tile_index in range(_tiles.size()):
		var tile := _tiles[tile_index]
		var tween := tile.create_tween()
		var final_position := Vector2(
			tile.position.x, 720 - _TILE_HEIGHT * (tile_index + 1)
		)
		tween.tween_property(tile, "position", final_position, 0.1)
