extends CharacterBody3D

var speed : int = 1.5
var direction : Vector3
var genMoney : int
@onready var timer: Timer = $Timer

func _physics_process(_delta):
	velocity = direction * speed
	move_and_slide() # Is what makes it move

func _ready() -> void:
	timer.start()

func set_variables(origin : Node3D):
	genMoney = origin.damage
	direction = Vector3(0,0,-speed)

func _on_timer_timeout() -> void:
	Economy.totalMoney += 4
	print(Economy.totalMoney)
	queue_free()
