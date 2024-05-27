class_name HUD
extends Control

@export_group("Top HUD")
@export var _score_label: Label
@export var _highscore_label: Label

@export_group("Menus")
@export var _main_menu: MainMenu


func _ready() -> void:
	MetaEvents.game_over.connect(_main_menu.show_retry)
	_main_menu.show_main()


func update_score(new_score: int) -> void:
	_score_label.text = str(new_score)


func update_highscore(new_highscore: int) -> void:
	_highscore_label.text = "Highscore: " + str(new_highscore)
