extends Node

var totalMoney : int = 1000

var moneyDictinary : Dictionary = {
	"None" : 0,
	"Fist" : 10, 
	"Healer" : 20,
	"Mage" : 30,
	"Enemy" : 0
}

func deduct_money() -> void:
	totalMoney -= moneyDictinary[TowerSpawner.currentTower]
