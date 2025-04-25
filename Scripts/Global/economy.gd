extends Node

const STARTINGMONEY : int = 100
var totalMoney : int = STARTINGMONEY
var tempMoney : int

var moneyDictinary : Dictionary = {
	"null" : 0,
	"Fist" : 15, 
	"Healer" : 30,
	"Mage" : 50,
	"Tank" : 40,
	"Archer" : 30,
	"Farmer" : 80,
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
