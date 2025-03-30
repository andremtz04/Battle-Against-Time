extends Node

var riskTable : Array = []
var towerRisk : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in TowerSpawner.row:
		riskTable.append([])
		for j in TowerSpawner.col:
			riskTable[i].append(0)
	print(riskTable)
	
	towerRisk = {
		"Test1" : [[0,0,1,0,0],[0,1,2,1,0],[1,2,3,2,1],[0,1,2,1,0],[0,0,1,0,0]],
		"Test2" : [[3,3,3],[3,5,3],[3,3,3]],
		"None" : [[0]]
	}

func updateRisk(towerName, row, col, delete) -> void:
	var SpTowerRisk : Array = towerRisk[towerName]
	var range : int = towerRisk.size()/2
	var r : int = 0
	var c : int = 0
	for i in range(row-range, row+range):
		c = 0
		for j in range(col-range, col+range):
			if(i < 0 || i > riskTable.size() || j < 0 || j > riskTable[0].size()):
				pass
			else:
				if(delete == true):
					riskTable[i][j] -= SpTowerRisk[r][c]
				else:
					print("Attempting to access: " + str(i) + " " + str(j))
					print("col value" + str(r) + " " + str(c))
					riskTable[i][j] += SpTowerRisk[r][c]
			c += 1
		r += 1
<<<<<<< Updated upstream
	print("Added risk!!")
=======
	#print("Added risk!!")
>>>>>>> Stashed changes
	print(riskTable)
	
#calcRisk just calls update risk for every tower in the thing
func calcRisk() -> void:
	#reset all values to 0 in risktable
	for i in riskTable:
		for j in riskTable[i]:
			riskTable[i][j] = 0

	for row in TowerSpawner.mapGrid:
		for col in TowerSpawner.mapGrid[row]:
			updateRisk(TowerSpawner.mapGrid[row][col], row, col, false)

func calculate_path(startPos:Vector2i, goalPos:Vector2i) -> Array:
	if(startPos.x < 0 || goalPos.x < 0 || startPos.x > goalPos.x || goalPos.x > riskTable[0].size()):
		return ["ERROR pls provide proper vectors for starting"] # this is error
	#ideally start on the left and try to reach the right center/goal area
	calcRisk()
	var path : Array = []
	for i in TowerSpawner.row:
		path.append([])
		for j in TowerSpawner.col:
			path[i].append(0)
	var currentPos:Vector2i = startPos
	var endX:int = goalPos.x
	var upRisk:int
	var midRisk:int
	var downRisk:int
	var randCheck:float
	path[currentPos.y][currentPos.x] = 1
	###### FIRST ITERATION #######
	#find the path of least resistance with some funny quirks because itll keep stuff fresh ig
	#if this does not shut off it is likely because the bounds are wrong (fix)
	#short-sighted loop to find immediate path of least resistance and avoid backtracking or going backwards (very ass)
	while(currentPos.x != goalPos.x || currentPos.y != goalPos.y):
		#Is the current position against the bounds of the array?
		if(currentPos.x == riskTable[0].size()-1 || currentPos.y == 0 || currentPos.y == riskTable.size()-1):
			#at end
			if(currentPos.x == riskTable[0].size()-1):
				if(currentPos.y < goalPos.y):
					currentPos.y += 1
				else:
					currentPos.y -= 1
			#at top
			elif(currentPos.y == 0):
				midRisk = riskTable[currentPos.x+1][currentPos.y]
				downRisk = riskTable[currentPos.x][currentPos.y+1]
				if (midRisk <= downRisk || path[currentPos.x][currentPos.y+1] == 1):
					currentPos.x += 1
				else:
					currentPos.y += 1
			#at bottom
			elif(currentPos.y == riskTable.size()-1):
				upRisk = riskTable[currentPos.x][currentPos.y-1]
				midRisk = riskTable[currentPos.x+1][currentPos.y]
				if (midRisk <= upRisk || path[currentPos.x][currentPos.y-1] == 1):
					currentPos.x += 1
				else:
					currentPos.y -= 1
			else:
				print("Big oopsies in the vicinity")
		
		#currentpos is away from boundaries
		else:
			#find risk above, below, in front of current path
			upRisk = riskTable[currentPos.x][currentPos.y-1]
			midRisk = riskTable[currentPos.x+1][currentPos.y]
			downRisk = riskTable[currentPos.x][currentPos.y+1]
			
			#convoluted if else block to determine what path to take (prioritize middle)
			if(midRisk <= downRisk && midRisk <= upRisk || midRisk <= downRisk && path[currentPos.x][currentPos.y-1] == 1 || midRisk <= upRisk && path[currentPos.x][currentPos.y+1] == 1):
				currentPos.x += 1
			elif(downRisk < upRisk || path[currentPos.x][currentPos.y-1] == 1):
				currentPos.y += 1
			elif(upRisk < downRisk || path[currentPos.x][currentPos.y+1] == 1):
				currentPos.y -= 1
			elif(downRisk == upRisk):
				if(randi()%2 == 0):
					currentPos.y -= 1
				else:
					currentPos.y += 1
			else:
				print("some big oopsie happened here")
		#notate current position in path
		path[currentPos.y][currentPos.x] = 1
		
	
	
	return path
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
