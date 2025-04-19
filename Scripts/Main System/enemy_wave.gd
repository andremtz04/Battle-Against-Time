extends Path3D

@onready var mainPath: Path3D = $"."
@onready var timer: Timer = $Timer

const ENEMY_PATH = preload("res://Scenes/enemy_path.tscn")
@onready var main_map: GridMap = $"../Main Map"

var moveSpeed : int = 3
var currEnemyTotal : int = 0
var roundStarted : bool = false
var blockLocation : Array = []
var roundCount : int = 0

func newCurve(startPos:Vector2i,rows:int,cols:int) -> Curve3D:
	#construct curve for path (CHANGE THIS INGAME)
	
	var x = startPos.x
	var y = 0
	var z = startPos.y
	var endX = rows
	var endZ = cols
	#endX = 19
	#endZ = 14
	#y in this case is steps down, x is steps to right
	#var startPos = Vector2i(x,z)
	var endPos = Vector2i(endX,endZ)
	#print("Calculating path (Curve)\n path:\n")
	var path:Array = Risk.calculate_path(startPos,endPos)
	#Risk.print2DArray(path)
	
	var zVector = Vector3(0,0,0)
	var index = 1
	
	#print("Successfully accessed")
	curve.add_point(Vector3(x,y,z),zVector,zVector,0)
	
	#debug
	#print("New point at x:" + str(x) + ", z:" + str(z))

	path[x][z] = 0
	
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
				print("problem occurred here : " + str(x) + " " + str(z))
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
	
	#DEBUG
	#print(curve.get_baked_points())
	
	return curve

func newPath() -> void:
	var startPos:Vector2i = Vector2i(0.5,0.5)
	var rows = TowerSpawner.col - 1 #(x)
	var cols = TowerSpawner.row - 1 #(z)
	self.curve = newCurve(startPos,rows,cols)


func music(round:int) -> void:
	#print(AudioServer.get_bus_volume_db(3))
	if roundStarted:
		var setVol:float = AudioServer.get_bus_volume_db(3)/1.06
		if setVol >= -0.05:
			setVol = 0;
		if setVol < 0:
			match(round):
				4:
					AudioServer.set_bus_volume_db(6,setVol)
					AudioServer.set_bus_volume_db(5,setVol)
					AudioServer.set_bus_volume_db(4,setVol)
					AudioServer.set_bus_volume_db(3,setVol)
				3:
					AudioServer.set_bus_volume_db(5,setVol)
					AudioServer.set_bus_volume_db(4,setVol)
					AudioServer.set_bus_volume_db(3,setVol)
				2:
					AudioServer.set_bus_volume_db(4,setVol)
					AudioServer.set_bus_volume_db(3,setVol)
				1:
					AudioServer.set_bus_volume_db(3,setVol)
				0:
					pass
				_:
					print("Error: fadeIn: Uncoded round")
	else:
		var setVol:float = AudioServer.get_bus_volume_db(3) * 1.02
		if setVol == 0:
			setVol = -.1
		if setVol >= -100:
			match(round):
				4:
					AudioServer.set_bus_volume_db(6,setVol)
					AudioServer.set_bus_volume_db(5,setVol)
					AudioServer.set_bus_volume_db(4,setVol)
					AudioServer.set_bus_volume_db(3,setVol)
				3:
					AudioServer.set_bus_volume_db(5,setVol)
					AudioServer.set_bus_volume_db(4,setVol)
					AudioServer.set_bus_volume_db(3,setVol)
				2:
					AudioServer.set_bus_volume_db(4,setVol)
					AudioServer.set_bus_volume_db(3,setVol)
				1:
					AudioServer.set_bus_volume_db(3,setVol)
				0:
					pass
				_:
					print("Error: fadeIn: Uncoded round")


func _on_timer_timeout() -> void:
	var newEnemy = ENEMY_PATH.instantiate()
	mainPath.add_child(newEnemy)
	currEnemyTotal += 1

func _on_ui_start_round() -> void:
	#print("Creating Curve") #debug
	#Risk.print2DArray(Risk.calculate_path(Vector2i(0,0),Vector2i(19,14)))
	#var curve:Curve3D = $"../Path3D".newCurve()
	if !roundStarted:
		newPath()
		print("round start: ")
		roundCount += 1
		print(roundCount)
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
	music(roundCount)

func _ready() -> void:
	var used_cells = main_map.get_used_cells()
	for cell in used_cells:
		var world_position = main_map.map_to_local(cell)
		if world_position.y == 1.5:
			blockLocation.append(floor(world_position))
	
	for block in blockLocation:
		Risk.riskTable[block.z][block.x] = 99 
	print(Risk.riskTable)
