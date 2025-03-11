extends Control

@onready var moneyLabel : RichTextLabel = $Money


func _ready() -> void:
	moneyLabel.text = str(Economy.totalMoney)


func _on_spawn_tower_2_button_down() -> void:
	TowerSpawner.currentTower = "Test1"


func _on_spawn_tower_1_button_down() -> void:
	TowerSpawner.currentTower = "Test2"


func _on_spawn_tower_3_button_down() -> void:
	TowerSpawner.currentTower = "Test3"


# What UI things should update when a tower is placed
func _on_camera_3d_placed_tower() -> void:
	Economy.deduct_money()
	moneyLabel.text = str(Economy.totalMoney)
