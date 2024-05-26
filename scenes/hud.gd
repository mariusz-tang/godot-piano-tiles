class_name HUD
extends Control

signal start_pressed
signal reset_highscore_pressed
signal quit_pressed

@export var _menu: Container
@export var _start_button: Button
@export var _final_score_label: Label
@export var _score_label: Label
@export var _highscore_label: Label


func update_scores(score: int, highscore: int) -> void:
	_score_label.text = str(score)
	_highscore_label.text = "Highscore: " + str(highscore)


## Show the menu and focus the start button.
func show_menu() -> void:
	_start_button.text = "Start"
	_set_show_big_score(false)
	_menu.show()
	_start_button.grab_focus()


## Similar to [method HUD.show_menu] but show "Retry" instead of "Start" and
## display the score achieved.
func show_fail_menu(final_score: int) -> void:
	_start_button.text = "Retry"
	_final_score_label.text = str(final_score)
	_set_show_big_score(true)
	_menu.show()
	_start_button.grab_focus()


func _set_show_big_score(value: bool) -> void:
	if value:
		_final_score_label.show()
		_score_label.hide()
	else:
		_final_score_label.hide()
		_score_label.show()


func _on_start_button_pressed() -> void:
	_menu.hide()
	_set_show_big_score(false)
	start_pressed.emit()


func _on_reset_highscore_button_pressed() -> void:
	reset_highscore_pressed.emit()


func _on_quit_button_pressed() -> void:
	quit_pressed.emit()
