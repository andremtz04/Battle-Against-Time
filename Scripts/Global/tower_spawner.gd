extends Node

var currentTower := "None"
var SpawnTower : PackedScene
var mapGrid : Array

var row : int = 15
var col : int = 20

enum { EMPTY, TOWER, ENEMY, BLOCK }

var TowerDictionary : Dictionary = {
	"None" : null,
	"Test1" : preload("res://Scenes/test_tower_1.tscn"),
	"Test2" : preload("res://Scenes/test_tower_2.tscn"),
	"Test3" : preload("res://Scenes/test_tower_3.tscn")
}

func _ready() -> void:
	for r in row:
		mapGrid.append([])
		for c in col:
			mapGrid[r].append("None")
	#print(mapGrid)

func _process(_delta: float) -> void:
	SpawnTower = TowerDictionary[currentTower]
