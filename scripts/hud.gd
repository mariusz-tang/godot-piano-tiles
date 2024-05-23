class_name HUD
extends CanvasLayer

@export var score_label: Label
@export var highscore_label: Label


func update_scores(score: int, highscore: int) -> void:
	score_label.text = str(score)
	highscore_label.text = "Highscore: " + str(highscore)
