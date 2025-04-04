extends PathFollow3D

var moveSpeed : int = 3

@onready var isMoving : bool = true
@onready var enemy_1: Sprite3D = $Enemy1
@onready var enemy_path: PathFollow3D = $"."


func _ready() -> void:
	enemy_1.connect("start_movement", _start_movement) # Connects the signals from the enemy_1
	enemy_1.connect("stop_movement", _stop_movement)

func _stop_movement() -> void:
	isMoving = false

func _start_movement() -> void:
	isMoving = true

func _process(delta: float) -> void:
	if isMoving:
		enemy_path.progress += moveSpeed * delta
