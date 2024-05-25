class_name HUD
extends CanvasLayer

signal start_pressed

@export var score_label: Label
@export var highscore_label: Label
@export var start_button: Button


func update_scores(score: int, highscore: int) -> void:
	score_label.text = str(score)
	highscore_label.text = "Highscore: " + str(highscore)


func _on_start_button_pressed() -> void:
	start_button.hide()
	start_pressed.emit()
