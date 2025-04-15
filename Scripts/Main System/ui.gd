extends Control

@onready var moneyLabel : RichTextLabel = $Money
signal start_round

func _ready() -> void:
	moneyLabel.text = str(Economy.totalMoney)


# Spawn Tower Buttons
func _on_spawn_tower_2_button_down() -> void:
	TowerSpawner.currentTower = "Fist"
func _on_spawn_tower_1_button_down() -> void:
	TowerSpawner.currentTower = "Healer"
func _on_spawn_tower_3_button_down() -> void:
	TowerSpawner.currentTower = "Mage"
func _on_spawn_tower_4_button_down() -> void:
	TowerSpawner.currentTower = "Tank"
func _on_spawn_tower_5_button_down() -> void:
	TowerSpawner.currentTower = "Archer"
func _on_spawn_tower_6_button_down() -> void:
	TowerSpawner.currentTower = "Farmer"


# What UI things should update when a tower is placed
func _on_camera_3d_placed_tower() -> void:
	Economy.deduct_money()
	moneyLabel.text = str(Economy.totalMoney)


func _on_play_button_button_down() -> void:
	start_round.emit()
	$"../Path1".roundStarted = true


func _on_button_button_down() -> void:
	TowerSpawner.currentTower = "Enemy"
