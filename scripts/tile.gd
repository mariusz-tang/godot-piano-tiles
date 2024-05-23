class_name Tile
extends Area2D
## Resizable piano tile

@export var _collider: CollisionShape2D
@export var _sprite: Sprite2D

@onready var _collision_shape: RectangleShape2D = _collider.shape


func _ready() -> void:
	set_size(45, 100)


## Set the size of the tile in pixels.
func set_size(x: int, y: int) -> void:
	var new_size := Vector2(x, y)
	var new_position := new_size / 2

	_collision_shape.size = new_size
	_sprite.scale = new_size

	# Adjust the positions since the origin is in the centre of the rectangle.
	_collider.position = new_position
	_sprite.position = new_position


func fade_and_free(tween: Tween) -> void:
	tween.parallel().tween_property(_sprite, "scale", Vector2.ZERO, 0.1)
	tween.tween_callback(queue_free)
