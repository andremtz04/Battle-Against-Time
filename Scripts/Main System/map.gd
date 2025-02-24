extends Node3D


var dragging_tower: Node3D = null
var valid_placement: bool = false
var raycast_origin: Camera3D  # Reference to your main camera



func _on_spawn_tower_1_button_down() -> void:
	TowerSpawner.currentTower = "Test1"
	print("T1")
	

func _on_spawn_tower_2_button_down() -> void:
	TowerSpawner.currentTower = "Test2"
	print("T2")
