extends Node

var riskTable : Array = []

var towerRisk : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in TowerSpawner.row:
		riskTable.append([])
		for j in TowerSpawner.col:
			riskTable[i].append(0)
	#print(riskTable)
	
	towerRisk = {
		"Mage" : [[0,0,1,0,0],[0,1,2,1,0],[1,2,3,2,1],[0,1,2,1,0],[0,0,1,0,0]],
		"Fist" : [[3,3,3],[3,5,3],[3,3,3]],
		"Enemy" : [[0]],
		null : [[0]],
		"Healer": [[0]]
	}

func updateRisk(towerName, row, col, delete) -> int:
	var SpTowerRisk:Array
	if towerName in towerRisk:
		SpTowerRisk = towerRisk[towerName]
	else:
		#function fail
		return 0
	@warning_ignore("integer_division", "shadowed_global_identifier")
	var range : int = SpTowerRisk.size()/2
	var r : int = 0
	var c : int = 0
	#print("Row: " + str(row) + " Col: " + str(col) + "Range: " + str(range))
	for i in range(row-range, row+range+1):
		c = 0
		for j in range(col-range, col+range+1):
			if(i < 0 || i >= riskTable.size() || j < 0 || j >= riskTable[0].size()):
				pass
			else:
				if(delete == true):
					riskTable[i][j] -= SpTowerRisk[r][c]
				else:
					#print("Attempting to access: " + str(i) + " " + str(j))
					#print("col value " + str(r) + " " + str(c))
					riskTable[i][j] += SpTowerRisk[r][c]
			c += 1
		r += 1
	#function success
	return 1
	#print("Added risk!!")
	#print(riskTable)

func calcRisk() -> void:
	#reset all values to 0 in risktable
	for i in riskTable.size():
		for j in riskTable[i].size():
			riskTable[i][j] = 0
	
	#DEBUG: PRINT MAPGRID
	#print("PRINTING MAPGRID")
	#print2DArray(TowerSpawner.mapGrid)

	for row in TowerSpawner.mapGrid.size():
		for col in TowerSpawner.mapGrid[row].size():
			#print(TowerSpawner.mapGrid[row][col])
			updateRisk(TowerSpawner.mapGrid[row][col], row, col, false)

func calculate_path(startPos:Vector2i, goalPos:Vector2i) -> Array:
	if(startPos.x < 0 || goalPos.x < 0 || startPos.x > goalPos.x || goalPos.x > riskTable[0].size()):
		return ["ERROR pls provide proper vectors for starting"] # this is error
	#ideally start on the left and try to reach the right center/goal area
	calcRisk()
	#print2DArray(riskTable)
	var path : Array = []
	for i in TowerSpawner.row:
		path.append([])
		for j in TowerSpawner.col:
			path[i].append(0)
	#unneeded atm
	#var currentPos:Vector2i = startPos
	#var endX:int = goalPos.x
	#var randCheck:float
	var upRisk:int
	var midRisk:int
	var downRisk:int
	var col = startPos.x
	var row = startPos.y
	path[row][col] = 1
	###### FIRST ITERATION #######
	#find the path of least resistance with some funny quirks because itll keep stuff fresh ig
	#if this does not shut off it is likely because the bounds are wrong (fix)
	#short-sighted loop to find immediate path of least resistance and avoid backtracking or going backwards (very ass)
	while(col != goalPos.x || row != goalPos.y):
		
		####FUCK UP #1 #####
		####BECAUSE OF HOW ARRAYS WORK, currentPos.x REALLY REFERS TO Y AND currentPos.y REALLY REFERS TO X#####
		####DON'T FORGET!!! CHANGING x TO COL AND y TO ROW######
		##IT WORKS ATM##
		
		#DEBUG
		#print(str(row) +", " + str(col) + ": " + str(riskTable[row][col]))
		
		#Is the current position against the bounds of the array?
		if(col == riskTable[0].size() - 1 || row == 0 || row == riskTable.size()-1):
			#at end
			if(col == riskTable[0].size()-1):
				if(row < goalPos.y):
					row += 1
				else:
					row -= 1
			#at top
			elif(row == 0):
				midRisk = riskTable[row][col+1]
				downRisk = riskTable[row+1][col]
				if (midRisk <= downRisk || path[row+1][col] == 1):
					col += 1
				else:
					row += 1
			#at bottom
			elif(row == riskTable.size()-1):
				upRisk = riskTable[row-1][col]
				midRisk = riskTable[row][col+1]
				if (midRisk <= upRisk || path[row-1][col] == 1):
					col += 1
				else:
					row -= 1
			else:
				print("Big oopsies in the vicinity")
		
		#currentpos is away from boundaries
		else:
			#find risk above, below, in front of current path
			upRisk = riskTable[row-1][col]
			midRisk = riskTable[row][col+1]
			downRisk = riskTable[row+1][col]
			
			#convoluted if else block to determine what path to take (prioritize middle)
			if(midRisk <= downRisk && midRisk <= upRisk || midRisk <= downRisk && path[row-1][col] == 1 || midRisk <= upRisk && path[row+1][col] == 1):
				col += 1
			elif(downRisk < upRisk || path[row-1][col] == 1):
				row += 1
			elif(upRisk < downRisk || path[row+1][col] == 1):
				row -= 1
			elif(downRisk == upRisk):
				#random direction up or down if equal
				if(randi()%2 == 0):
					row -= 1
				else:
					row += 1
			else:
				print("some big oopsie happened here")
		#notate current position in path
		path[row][col] = 1
		
	return path

#PRINT ARRAY FOR DEBUGGING PURPOSES
func print2DArray(arr:Array) -> void:
	for i in arr.size():
		print(arr[i])
	print()
