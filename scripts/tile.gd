class_name Tile
extends Node2D
## Resizable piano tile

@export var _sprite: Sprite2D


## Set the size of the tile in pixels.
func set_size(x: int, y: int) -> void:
	var new_size := Vector2(x, y)
	_sprite.scale = new_size
	_sprite.position = new_size / 2


func fade_and_free(tween: Tween) -> void:
	tween.parallel().tween_property(_sprite, "scale", Vector2.ZERO, 0.1)
	tween.tween_callback(queue_free)
