extends Path3D

@onready var mainPath: Path3D = $"."
@onready var timer: Timer = $Timer

const ENEMY_PATH = preload("res://Scenes/enemy_path.tscn")

var moveSpeed : int = 3
var currEnemyTotal : int = 0
var roundStarted : bool = false

func _on_timer_timeout() -> void:
	var newEnemy = ENEMY_PATH.instantiate()
	mainPath.add_child(newEnemy)
	currEnemyTotal += 1


func _on_ui_start_round() -> void:
	if roundStarted:
		print("round start")
		timer.set_wait_time(EnemySpawner.path1D[EnemySpawner.roundCounter][1])
		timer.start()


func _process(_delta: float) -> void:
	if currEnemyTotal == EnemySpawner.path1D[EnemySpawner.roundCounter][0]:
		timer.stop()
		roundStarted = false
