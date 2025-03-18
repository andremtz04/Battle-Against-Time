extends Node

var currentTower : String = "null"
var SpawnTower : PackedScene
var mapGrid : Array

var row : int = 15
var col : int = 20

enum { EMPTY, TOWER, ENEMY, BLOCK }


var TowerDictionary : Dictionary = {
	"null" : null,
	"Fist" : preload("res://Scenes/towers/fist_fighter.tscn"),
	"Healer" : preload("res://Scenes/towers/healer.tscn"),
	"Mage" : preload("res://Scenes/towers/mage.tscn"),
	"Enemy" : preload("res://Scenes/towers/enemy_1.tscn")
}

func _ready() -> void:
	for r in row:
		mapGrid.append([])
		for c in col:
			mapGrid[r].append(null)

func _process(_delta: float) -> void:
	SpawnTower = TowerDictionary[currentTower]
