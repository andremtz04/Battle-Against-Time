extends Camera3D

@onready var map: Node3D = $".."
var buttonDown : bool = false

# Mouse tracking stuff
var rayLength : int = 1000
var rayCastResult : Dictionary
var instance


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
	print(buttonDown)


func _input(event) -> void:
	# Spawns the tower when you left click
	if event.is_action_pressed("Left Click") :
		instance = TowerSpawner.SpawnTower.instantiate()
		instance.position = rayCastResult["position"]
		map.add_child(instance)

	# Drags the tower around when left click is held
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && !rayCastResult.is_empty():
		instance.position = rayCastResult["position"]

	# Deletes the tower if it out of bounds
	if event.is_action_released("Left Click"):
		deleteTower()


func deleteTower() -> void:
	
	if rayCastResult.is_empty():
		instance.queue_free()
	elif rayCastResult["position"].y < 1:
		instance.queue_free()
	buttonDown = false

func _on_spawn_tower_1_button_down() -> void:
	TowerSpawner.currentTower = "Test1"
	buttonDown = true


func _on_spawn_tower_2_button_down() -> void:
	TowerSpawner.currentTower = "Test2"
	buttonDown = true
