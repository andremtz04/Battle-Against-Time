extends Node

var riskTable : Array = []
var towerRisk : Dictionary
var blockLocation:Array = []
var bestRisk:int = 200
var tripped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in TowerSpawner.row:
		riskTable.append([])
		for j in TowerSpawner.col:
			riskTable[i].append(0)
	#print(riskTable)
	towerRisk = {
		"Mage" : [[1,1,1,1,1],[1,2,2,2,1],[1,2,-2,2,1],[1,2,2,2,1],[1,1,1,1,1]],
		"Fist" : [[3,3,3],[3,-1,3],[3,3,3]],
		"Enemy" : [[0]],
		null : [[0]],
		"Healer": [[-5]],
		"Tank" : [[1,1,1],[1,-1,1],[1,1,1]],
		"Farmer": [[-5]],
		"Archer" : [[1,1,1,1,1],[1,2,2,2,1],[1,2,-2,2,1],[1,2,2,2,1],[1,1,1,1,1]]
	}

func updateRisk(towerName, row, col, delete) -> int:
	var SpTowerRisk:Array
	
	if towerName in towerRisk:
		SpTowerRisk = towerRisk[towerName]
	else:
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

func INIT(blocks:Array):
	blockLocation = blocks

func walls():
#old, moved to calcrisk
	for block in blockLocation:
		Risk.riskTable[block.z][block.x] = 99 
	print(Risk.riskTable)

func calcRisk() -> void:
	#reset all values to 0 in risktable
	for i in riskTable.size():
		for j in riskTable[i].size():
			riskTable[i][j] = 0
	
	
	#DEBUG: PRINT MAPGRID
	#print("PRINTING MAPGRID")
	#print2DArray(TowerSpawner.mapGrid)
	walls()
	
	for row in TowerSpawner.mapGrid.size():
		for col in TowerSpawner.mapGrid[row].size():
			#print(TowerSpawner.mapGrid[row][col])
			updateRisk(TowerSpawner.mapGrid[row][col], row, col, false)

func calc_path(startPos:Vector2i, goalPos:Vector2i) -> Array:
	if(startPos.x < 0 || goalPos.x < 0 || startPos.x > goalPos.x || goalPos.x > riskTable[0].size()):
		return ["ERROR pls provide proper vectors for starting"] # this is error
	#ideally start on the left and try to reach the right center/goal area
	
	calcRisk()
	#UNCOMMENT IF THINGS START GETTING WIERD (remember to implement blocks into this function)
	
	
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

func new_calculate_path(currPos:Vector2i, goalPos:Vector2i, currentPath:Array = [], iteration:int = 0, risk:int = 0) -> Array:
	if(iteration == 0):
		calcRisk()
		for i in TowerSpawner.row:
			currentPath.append([])
			for j in TowerSpawner.col:
				currentPath[i].append(0)
		bestRisk = 200
		tripped = false
		var ultPath:Array = new_calculate_path(currPos,goalPos,currentPath,iteration + 1)[0]
		print2DArray(ultPath)
		return ultPath
	
	#####SECOND ITERATION#####
	if(risk >= bestRisk || riskTable[currPos.y][currPos.x] >= 50 || tripped):
		return [[],999]
	
	var optionUp:Array = [[],999]
	var optionDown:Array = [[],999]
	var optionLeft:Array = [[],999]
	var optionRight:Array = [[],999]
	
	var pathCopy = []
	for i in currentPath.size():
		pathCopy.append([])
		for j in currentPath[i]:
			pathCopy[i].append(j)
	
	pathCopy[currPos.y][currPos.x] = iteration
	
	if(currPos == goalPos):
		bestRisk = risk
		tripped = true
		print("SUCCESS " + str(risk))
		print2DArray(pathCopy)
		return [pathCopy, risk]
	
	risk += riskTable[currPos.y][currPos.x] + 1
	
	if(currPos.x != riskTable[0].size()-1 && pathCopy[currPos.y][currPos.x+1] == 0):
		currPos.x += 1
		optionRight = new_calculate_path(currPos, goalPos, pathCopy, iteration+1, risk)
		currPos.x -= 1
	
	if(currPos.y != 0 && currentPath[currPos.y-1][currPos.x] == 0):
		currPos.y -= 1
		optionUp = new_calculate_path(currPos, goalPos, pathCopy, iteration+1, risk)
		currPos.y += 1
		
	if(currPos.y != riskTable.size()-1 && currentPath[currPos.y+1][currPos.x] == 0):
		currPos.y += 1
		optionDown = new_calculate_path(currPos, goalPos, pathCopy, iteration+1, risk)
		currPos.y -= 1
	
	var options:Array = [optionUp,optionDown,optionLeft,optionRight]
	var index:int = 0
	var leastRisk:int = 998
	for i in options.size():
		if(options[i][1] <= leastRisk):
			leastRisk = options[i][1]
			index = i
	return options[index]

class mapNode:
	
	var risk:int
	var position:Vector2i 
	var path:Array
	
	func _init(r:int, pos:Vector2i, p:Array):
		risk = r
		position = pos
		path = p

func calculate_path(startPos:Vector2i, goalPos:Vector2i) -> Array:
	var finish = false
	var check = false
	var currentPath = []
	var currNodes = []
	var trashedNodes = []
	var potentialLoc:Vector2i
	var index = 0
	var currNode:mapNode = mapNode.new(0,startPos,[])
	
	calcRisk()
	print2DArray(riskTable)
	
	currNodes.append(currNode)
	
	print("starting node added to currNodes")
	
	#TENTATIVE A* ALGORITHM
	while(!finish):
		#determine focus node for group based on least risk
		index = 0
		for i in currNodes.size():
			if(currNode.risk > currNodes[i].risk):
				index = i
				currNode = currNodes[i]
				
		if(currNode.position == goalPos):
			
			for i in riskTable.size():
				currentPath.append([])
				for j in riskTable[0].size():
					currentPath[i].append(0)
					
			finish = true
			for node in currNode.path + [currNode]:
				currentPath[node.position.y][node.position.x] = 1
			break
			#IMPLEMENT PATH GETTER
		
		print("Evaluating current node:")
		print("Risk: " + str(currNode.risk) + ", position: (" + str(currNode.position.x) + ", " + str(currNode.position.y) +"), Amount of nodes before: " + str(currNode.path.size()))
		
		check = true
		for node in trashedNodes:
			if node.position == currNode.position:
				check = false
		
		if(currNode.risk<100 && check):
			
			if(currNode.position.x < riskTable[0].size()-1):
				#check = true
				potentialLoc = Vector2i(currNode.position.x+1,currNode.position.y)
				#for node in currNode.path:
					#if node.position == potentialLoc:
						#check=false
						#break
				#if check:
				currNodes.append(mapNode.new(currNode.risk+riskTable[currNode.position.y][currNode.position.x+1]+1,potentialLoc,currNode.path+[currNode]))
			
			if(currNode.position.y < riskTable.size()-1):
				#check = true
				potentialLoc = Vector2i(currNode.position.x,currNode.position.y+1)
				#for node in currNode.path:
					#if node.position == potentialLoc:
						#check=false
						#break
				#if check:
				currNodes.append(mapNode.new(currNode.risk+riskTable[currNode.position.y+1][currNode.position.x]+1,potentialLoc,currNode.path+[currNode]))
			
			if(currNode.position.y > 0):
				#check = true
				potentialLoc = Vector2i(currNode.position.x,currNode.position.y-1)
				#for node in currNode.path:
					#if node.position == potentialLoc:
						#check=false
						#break
				#if check:
				currNodes.append(mapNode.new(currNode.risk+riskTable[currNode.position.y-1][currNode.position.x]+1,potentialLoc,currNode.path+[currNode]))
				
			
		else:
			print("Trashing node")
			pass
		
		print()
		trashedNodes.append(currNode)
		currNodes.remove_at(index)
		
		if(currNodes.is_empty()):
			print("NODES EXHAUSTED, NO POSSIBLE PATH OR ERROR")
			break
		
		currNode = currNodes[0]
		
	print("While loop complete!\n")
	print2DArray(currentPath)
	
	return currentPath

#PRINT ARRAY FOR DEBUGGING PURPOSES
func print2DArray(arr:Array) -> void:
	for i in arr.size():
		print(arr[i])
	print()
