extends Node

var currentTower := "Test2"
var SpawnTower : PackedScene

var TowerDictionary : Dictionary = {
	"Test1" : preload("res://Scenes/test_tower_1.tscn"),
	"Test2" : preload("res://Scenes/test_tower_2.tscn")
}

func _process(_delta: float) -> void:
	SpawnTower = TowerDictionary[currentTower]
