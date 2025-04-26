extends Camera3D

@onready var map: Node3D = $".."

# Mouse tracking stuff
var rayLength : int = 1000
var rayCastResult : Dictionary
var instance
var dummyInstance
var inPos
var testNum = 0

const DUMMY_TOWER = preload("res://Scenes/towers/dummy_tower.tscn")

signal placedTower

func _ready():
	TowerSpawner.reset_map()
	EnemySpawner.enemykilled = 0
	 #this is basically for audio
	$Audio/WhimsyPlayer.play()
	$Audio/WompPlayer.play()
	$Audio/KickPlayer.play()
	$Audio/BassPlayer.play()
	$Audio/HiTunePlayer.play()
	$Audio/Ticking1.play()
	$Audio/Ticking2.play()
	$Audio/Ticking3.play()
	$Audio/Ticking4.play()
	$Audio/FinalRound.play()
	
	
	#effectively mutes buses
	AudioServer.set_bus_volume_db(3,-80) #Bass
	AudioServer.set_bus_volume_db(4,-80) #Womp
	AudioServer.set_bus_volume_db(5,-80) #Whimsy
	AudioServer.set_bus_volume_db(6,-80) #HiTune
	AudioServer.set_bus_volume_db(7,-80) #FinalRound
	AudioServer.set_bus_volume_db(8,-80) #Ticking1
	AudioServer.set_bus_volume_db(9,-80) #Ticking2
	AudioServer.set_bus_volume_db(10,-80) #Ticking3
	AudioServer.set_bus_volume_db(11,-80) #Ticking4
	#AudioServer.set_bus_mute(AudioServer.get_bus_index("Kick"),1)
	
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
		if !rayCastResult.is_empty() and TowerSpawner.SpawnTower != null:
			inPos = rayCastResult["position"]
			dummyInstance = DUMMY_TOWER.instantiate()
			map.add_child(dummyInstance)
			dummyInstance.position = Vector3(inPos.x, inPos.y, inPos.z)
			

	# Drags the tower around when left click is held
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && !rayCastResult.is_empty() && dummyInstance:
		inPos = rayCastResult["position"]
		#if inPos != null:
		dummyInstance.position = inPos

	# Deletes the tower if it out of bounds
	if event.is_action_released("Left Click") && dummyInstance:
		dummyInstance.queue_free()
		spawn_tower()
		if delete_tower():
			$Audio/BadAction.play()
			pass
		else:
			instance.position = Vector3(inPos.x + 0.5, inPos.y, inPos.z + 1)
			TowerSpawner.mapGrid[inPos.z][inPos.x] = TowerSpawner.currentTower
			#print(instance.global_position, " ", inPos.z, " ", inPos.x)
			#update risk table
			testNum = Risk.updateRisk(TowerSpawner.currentTower, round(inPos.z), round(inPos.x), false)

			
			#DEBUG
			if testNum:
				#Risk.print2DArray(Risk.riskTable)
				pass
			else:
				print("TOWER NOT RECOGNIZED/CODED: " + TowerSpawner.currentTower)
			
			instance.tPosition = inPos
			instance.timer.start()
			placedTower.emit()
			

func delete_tower() -> bool:
	if instance:
		inPos = Vector3(floor(inPos.x), round(inPos.y), floor(inPos.z))
		if rayCastResult.is_empty():
			instance.queue_free()
		elif inPos.y < 1 || inPos.y > 1:
			instance.queue_free()
		elif TowerSpawner.mapGrid[inPos.z][inPos.x] != null:
			instance.queue_free()
		elif !Economy.enoughMoney():
			instance.queue_free()
		else:
			return false
	return true


func spawn_tower() -> void:
	if !rayCastResult.is_empty() and TowerSpawner.SpawnTower != null:
		inPos = rayCastResult["position"]
		instance = TowerSpawner.SpawnTower.instantiate()
		instance.position = inPos
		map.add_child(instance)



func _on_mute_button_pressed() -> void: #mute or unmute for our earsss
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),!AudioServer.is_bus_mute(AudioServer.get_bus_index("Master")))
