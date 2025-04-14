extends Camera3D

@onready var map: Node3D = $".."

# Mouse tracking stuff
var rayLength : int = 1000
var rayCastResult : Dictionary
var instance
var inPos
var testNum = 0;

signal placedTower


func _process(_delta: float) -> void:
	# Gets the mouse position
	var mousePos := get_viewport().get_mouse_position()
	var from := project_ray_origin(mousePos)
	var to := from + project_ray_normal(mousePos) * rayLength 
	var space := get_world_3d().direct_space_state
	var rayQuery := PhysicsRayQueryParameters3D.new()
	rayQuery.from = from
	rayQuery.to = to
	rayCastResult = space.intersect_ray(rayQuery)
	#print(rayCastResult)


func _input(event) -> void:
	# Spawns the tower when you left click
	if event.is_action_pressed("Left Click"):
		spawn_tower()

	# Drags the tower around when left click is held
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && !rayCastResult.is_empty() && instance:
		inPos = rayCastResult["position"]
		instance.position = inPos

	# Deletes the tower if it out of bounds
	if event.is_action_released("Left Click"):
		if delete_tower():
			pass
		else:
			instance.position = Vector3(inPos.x + 0.5, inPos.y, inPos.z + 1)
			TowerSpawner.mapGrid[inPos.z][inPos.x] = TowerSpawner.currentTower
			#update risk table
			testNum = Risk.updateRisk(TowerSpawner.currentTower, round(inPos.z), round(inPos.x), false)
			#DEBUG
			if testNum:
				#Risk.print2DArray(Risk.riskTable)
				pass
			else:
				print("TOWER NOT RECOGNIZED/CODED: " + TowerSpawner.currentTower)
			
			instance.tPosition = inPos
			#instance.calculate_radius()
			instance.timer.start()
			placedTower.emit()

func delete_tower() -> bool:
	if instance:
		inPos = Vector3(floor(inPos.x), round(inPos.y), floor(inPos.z))
		if rayCastResult.is_empty():
			instance.queue_free()
		elif inPos.y < 0.95:
			instance.queue_free()
		elif TowerSpawner.mapGrid[inPos.z][inPos.x] != null:
			instance.queue_free()
		else:
			#print(TowerSpawner.mapGrid[inPos.z][inPos.x])
			return false
	return true


func spawn_tower() -> void:
	if !rayCastResult.is_empty() and TowerSpawner.SpawnTower != null:
		inPos = rayCastResult["position"]
		instance = TowerSpawner.SpawnTower.instantiate()
		instance.position = Vector3(inPos.x, inPos.y, inPos.z)
		map.add_child(instance)
