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
	var towerRisk : Array = towerRisk[towerName]
	var range : int = floor(towerRisk.size()/2)
	var r : int = 0
	var c : int = 0
	for i in range(row-range, row+range):
		for j in range(col-range, col+range):
			if(i < 0 || i > riskTable.size() || j < 0 || j > riskTable[0].size()):
				pass
			else:
				if(delete == true):
					riskTable[i][j] -= towerRisk[r][c]
				else:
					riskTable[i][j] += towerRisk[r][c]
			c += 1
		r += 1
	
func calcRisk(towers) -> void:
	#reset all values to 0 in risktable
	for i in riskTable:
		for j in riskTable[i]:
			riskTable[i][j] = 0

	for row in towers:
		for col in towers[row]:
			updateRisk(towers[row][col], row, col, false)
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
