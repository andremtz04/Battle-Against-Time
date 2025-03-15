extends Node3D

var tName : String = "enemy"
var price : int = 10
var attackRange : int = 2
var damage : int = 1
var age : int = 0
var health : int = 10
var tPosition : Vector3
@onready var timer: Timer = $Timer

var isPlaced = false
#Temp
func calculate_radius() -> void:
	pass
