extends Node

var currentTower := "Test2"
var SpawnTower : PackedScene
var mapGrid : Array

var row : int = 10
var col : int = 10

var TowerDictionary : Dictionary = {
	"Test1" : preload("res://Scenes/test_tower_1.tscn"),
	"Test2" : preload("res://Scenes/test_tower_2.tscn")
}

func _ready() -> void:
	for r in row:
		mapGrid.append([])
		for c in col:
			mapGrid[r].append(0)

func _process(_delta: float) -> void:
	SpawnTower = TowerDictionary[currentTower]
