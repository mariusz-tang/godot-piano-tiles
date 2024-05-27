class_name TilePlayer
extends Node
## A gameplay manager class. Handles tile generation and parses gameplay inputs.

signal score_changed(new_score: int)

const _TILE_HEIGHT: int = 720 / 4
const _TILE_WIDTH: int = 120
const _TILE_ACTIONS: Array[String] = ["tile_1", "tile_2", "tile_3", "tile_4"]

@export var _tile_scene: PackedScene
@export_group("Audio")
@export var _audio_player: SoundEffectPlayer2D
@export var _success_sound: AudioStream
@export var _fail_sound: AudioStream

var tile_colour: Color:
	get:
		return tile_colour
	set(value):
		tile_colour = value
		for tile in _tiles:
			tile.set_colour(value)

var _tiles: Array[Tile] = []
var _tile_positions: Array[int] = []
var _score: int = 0:
	get:
		return _score
	set(value):
		_score = value
		score_changed.emit(value)


func _ready() -> void:
	# Begin in a paused state until play is called.
	pause()
	MetaEvents.game_started.connect(play.bind(true))
	MetaEvents.tile_colour_changed.connect(
		func(c: Color) -> void: tile_colour = c
	)


func _unhandled_input(event: InputEvent) -> void:
	for action_ix in range(_TILE_ACTIONS.size()):
		if event.is_action_pressed(_TILE_ACTIONS[action_ix]):
			_handle_tile_pressed(action_ix)
			get_viewport().set_input_as_handled()


## Clear any existing tiles and generate a new set.
func generate() -> void:
	while _tiles.size() > 0:
		var tile: Tile = _tiles.pop_back()
		tile.queue_free()
	_tile_positions.clear()

	_generate_initial_tiles()


## Enable input processing. If [param regenerate] is set to [code]true[/code],
## [method TilePlayer.generate] is called first.
func play(regenerate: bool = false) -> void:
	if regenerate:
		_score = 0
		generate()
	set_process_unhandled_input(true)


## Disable input processing. Call [method TilePlayer.play] to unpause.
func pause() -> void:
	set_process_unhandled_input(false)


func _generate_initial_tiles() -> void:
	while _tiles.size() == 0 or _tiles[-1].position.y > 0:
		_generate_new_tile()


func _generate_new_tile() -> void:
	var tile: Tile = _tile_scene.instantiate()
	add_child(tile)
	tile.set_size(_TILE_WIDTH, _TILE_HEIGHT)
	tile.set_colour(tile_colour)

	var tile_x_pos := randi() % 4
	var x := tile_x_pos * _TILE_WIDTH

	var last_tile_y_pos: int = 720
	if _tiles.size() != 0:
		last_tile_y_pos = _tiles[-1].position.y
	var y := last_tile_y_pos - _TILE_HEIGHT

	tile.position = Vector2(x, y)

	_tiles.append(tile)
	_tile_positions.append(tile_x_pos)


func _handle_tile_pressed(index: int) -> void:
	assert(index >= 0 and index <= 3)
	if _tile_positions[0] == index:
		_shift()
		_score += 1
		_audio_player.play_stream(_success_sound)
	else:
		pause()
		_audio_player.play_stream(_fail_sound)
		MetaEvents.game_over.emit(_score)


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
			tile.shrink_and_free(tween)

	_tiles.remove_at(0)
	_tile_positions.remove_at(0)
