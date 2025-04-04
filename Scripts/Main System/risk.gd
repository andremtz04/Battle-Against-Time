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
					#print("Attempting to access: " + str(i) + " " + str(j))
					#print("col value" + str(r) + " " + str(c))
					riskTable[i][j] += SpTowerRisk[r][c]
			c += 1
		r += 1
	#print("Added risk!!")
	#print(riskTable)
	
func calcRisk() -> void:
	#reset all values to 0 in risktable
	for i in riskTable:
		for j in riskTable[i]:
			riskTable[i][j] = 0

	for row in TowerSpawner.mapGrid:
		for col in TowerSpawner.mapGrid[row]:
			updateRisk(TowerSpawner.mapGrid[row][col], row, col, false)
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_timer_timeout() -> void:
	pass # Replace with function body.
