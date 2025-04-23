extends Node2D

@onready var victory_defeat: RichTextLabel = $Victory_Defeat


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if EnemySpawner.didWin:
		victory_defeat.text = "Victory"
	else:
		victory_defeat.text = "Defeat"


func _on_return_menu_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_quit_button_down() -> void:
	get_tree().quit()
