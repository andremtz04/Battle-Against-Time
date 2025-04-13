extends Path3D

@onready var mainPath: Path3D = $"."
@onready var timer: Timer = $Timer

const ENEMY_PATH = preload("res://Scenes/enemy_path.tscn")

var moveSpeed : int = 3
var currEnemyTotal : int = 0
var roundStarted : bool = false

func newCurve() -> Curve3D:
	#construct curve for path (CHANGE THIS INGAME)
	
	var x = 0
	var y = 1
	var z = 5
	var endX = 19
	var endZ = 14
	#y in this case is steps down, x is steps to right
	var startPos = Vector2i(x,z)
	var endPos = Vector2i(endX,endZ)
	print("Calculating path (Curve)\n path:\n")
	var path:Array = Risk.calculate_path(startPos,endPos)
	Risk.print2DArray(path)
	
	var zVector = Vector3(0,0,0)
	var index = 1
	
	print("Successfully accessed")
	curve.add_point(Vector3(x,y,z),zVector,zVector,0)
	
	path[z][x] = 0
	
	while(x != endX || z != endZ):
		#print("This is fine")
		if(x == endX):
			if(z<endZ):
				z += 1
			else:
				z -= 1
		elif(z == 0 || z == path.size()-1):
			if(path[z][x+1] == 1):
					x += 1
			else:
				if(z == 0):
					z+= 1
				else:
					z -= 1
		else:
			if(path[z][x+1] == 1):
					x += 1
			elif(path[z+1][x] == 1):
					z += 1
			elif(path[z-1][x] == 1):
					z -= 1
			else:
				print("problem occurred here")
				x += 1
		
		
		curve.add_point(Vector3(x,y,z),zVector,zVector,index)
		index += 1
		path[z][x] = 0
		#ensures no backtracking by accident
		
		#debug
		#print("New point at x:" + str(x) + ", z:" + str(z))
		
		
		# end loop
	#final point added (endpos)
	curve.add_point(Vector3(x,y,z),zVector,zVector,index)
	return curve

func _on_timer_timeout() -> void:
	var newEnemy = ENEMY_PATH.instantiate()
	mainPath.add_child(newEnemy)
	currEnemyTotal += 1


func _on_ui_start_round() -> void:
	#print("Creating Curve") #debug
	#Risk.print2DArray(Risk.calculate_path(Vector2i(0,0),Vector2i(19,14)))
	#var curve:Curve3D = $"../Path3D".newCurve()
	self.curve = newCurve()
	if !roundStarted:
		print("round start")
		timer.set_wait_time(EnemySpawner.path1D[EnemySpawner.roundCounter][1])
		timer.start()


func _process(_delta: float) -> void:
	if currEnemyTotal == EnemySpawner.path1D[EnemySpawner.roundCounter][0]:
		timer.stop()
	if EnemySpawner.enemykilled == EnemySpawner.path1D[EnemySpawner.roundCounter][0]:
		print("round over")
		currEnemyTotal = 0
		EnemySpawner.enemykilled = 0
		if EnemySpawner.roundCounter < EnemySpawner.totalRounds:
			EnemySpawner.roundCounter += 1
		roundStarted = false
