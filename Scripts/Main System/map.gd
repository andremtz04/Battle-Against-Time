extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_spawn_tower_1_button_down() -> void:
	TowerSpawner.currentTower = "Test1"
	print("T1")

func _on_spawn_tower_2_button_down() -> void:
	TowerSpawner.currentTower = "Test2"
	print("T2")
