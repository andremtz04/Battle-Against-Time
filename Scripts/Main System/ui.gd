extends Control

@onready var moneyLabel : RichTextLabel = $TextContain/Money
@onready var healthLabel: RichTextLabel = $TextContain/Health
@onready var roundLabel: RichTextLabel = $TextContain/Round
@onready var path_1: Path3D = $"../Path1"


var health = 20
var isButtonDown : bool = false
signal start_round

func _ready() -> void:
	EnemySpawner.roundStarted = false
	
	$TowerPrice/HealerPrice.text = "$" + str(Economy.moneyDictinary["Healer"])
	$TowerPrice/FistPrice.text = "$" + str(Economy.moneyDictinary["Fist"])
	$TowerPrice/MagePrice.text = "$" + str(Economy.moneyDictinary["Mage"])
	$TowerPrice/TankPrice.text = "$" + str(Economy.moneyDictinary["Tank"])
	$TowerPrice/ArcherPrice.text = "$" + str(Economy.moneyDictinary["Archer"])
	$TowerPrice/FarmerPrice.text = "$" + str(Economy.moneyDictinary["Farmer"])


func _process(_delta: float) -> void:
	if health <= 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
	moneyLabel.text = "Money: " + str(Economy.totalMoney)
	healthLabel.text = "Health: " + str(health)
	roundLabel.text = "Round: " + str(path_1.roundCount) + "/5"


# Spawn Tower Buttons
func _on_spawn_tower_1_button_down() -> void:
	TowerSpawner.currentTower = "Healer"
func _on_spawn_tower_2_button_down() -> void:
	TowerSpawner.currentTower = "Fist"
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
	EnemySpawner.roundStarted = true


func _on_button_button_down() -> void:
	TowerSpawner.currentTower = "Enemy"
