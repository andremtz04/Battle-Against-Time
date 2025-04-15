extends Node

var totalMoney : int = 1000

var moneyDictinary : Dictionary = {
	"null" : 0,
	"Fist" : 10, 
	"Healer" : 20,
	"Mage" : 30,
	"Tank" : 30,
	"Archer" : 10,
	"Farmer" : 50,
	"Enemy" : 0
}

func deduct_money() -> void:
	totalMoney -= moneyDictinary[TowerSpawner.currentTower]
