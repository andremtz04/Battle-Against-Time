extends Node

var totalMoney : int = 1000

var moneyDictinary : Dictionary = {
	"None" : 0,
	"Test1" : 10, 
	"Test2" : 20,
	"Test3" : 30
}

func deduct_money() -> void:
	totalMoney -= moneyDictinary[TowerSpawner.currentTower]
