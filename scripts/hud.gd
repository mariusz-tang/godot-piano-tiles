class_name HUD
extends CanvasLayer

signal start_pressed

@export var _score_label: Label
@export var _highscore_label: Label
@export var _start_button: Button


func update_scores(score: int, highscore: int) -> void:
	_score_label.text = str(score)
	_highscore_label.text = "Highscore: " + str(highscore)


func _on_start_button_pressed() -> void:
	_start_button.hide()
	start_pressed.emit()


func show_start() -> void:
	_start_button.show()
