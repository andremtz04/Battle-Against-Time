extends Path3D

@onready var mainPath: Path3D = $"."
@onready var timer: Timer = $Timer
@onready var path: Array = []
@onready var startPos:Vector2i = Vector2i(0,5)
@onready var endPos:Vector2i = Vector2i(TowerSpawner.col-1,5)


const ENEMY_PATH = preload("res://Scenes/enemy_path.tscn")

var moveSpeed : int = 3
var currEnemyTotal : int = 0

func makePath() -> void:
	path = Risk.calculate_path(startPos,endPos)

func _on_timer_timeout() -> void:
	var newEnemy = ENEMY_PATH.instantiate()
	mainPath.add_child(newEnemy)
	currEnemyTotal += 1


func _on_ui_start_round() -> void:
	timer.set_wait_time(EnemySpawner.path1D[EnemySpawner.roundCounter][1])
	timer.start()


func _process(delta: float) -> void:
	if currEnemyTotal == EnemySpawner.path1D[EnemySpawner.roundCounter][0]:
		timer.stop()
