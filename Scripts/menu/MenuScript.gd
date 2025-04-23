extends Node3D

@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	EnemySpawner.didWin = false # don't erase

func _process(delta: float) -> void:
	camera.rotate_y(0.3 * delta)


func _on_start_button_down() -> void:
	Economy.totalMoney = Economy.STARTINGMONEY
	get_tree().change_scene_to_file("res://Scenes/map.tscn")


func _on_quit_button_down() -> void:
	get_tree().quit()
