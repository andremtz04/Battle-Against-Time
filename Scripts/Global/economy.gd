extends Node

var totalMoney : int = 1000
var tempMoney : int

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

func enoughMoney() -> bool:
	tempMoney = totalMoney
	if tempMoney - moneyDictinary[TowerSpawner.currentTower] >= 0:
		return true
	else:
		return false
