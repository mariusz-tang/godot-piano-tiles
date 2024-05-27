class_name MainMenu
extends Container

@export var _final_score_label: Label
@export var _start_button: Button


## Show the menu and focus the start button.
func show_main() -> void:
	_start_button.text = "Start"
	_final_score_label.hide()
	show()
	_start_button.grab_focus()


## Similar to [method MainMenu.show_main] but show "Retry" instead of "Start"
## and display the score achieved.
func show_retry(final_score: int) -> void:
	_start_button.text = "Retry"
	_final_score_label.text = str(final_score)
	_final_score_label.show()
	show()
	_start_button.grab_focus()


func _on_start_pressed() -> void:
	hide()
	MetaEvents.game_started.emit()


func _on_reset_highscore_pressed() -> void:
	MetaEvents.highscore_reset_requested.emit()


func _on_tile_colour_changed(new_colour: Color) -> void:
	MetaEvents.tile_colour_changed.emit(new_colour)


func _on_quit_pressed() -> void:
	get_tree().quit()
