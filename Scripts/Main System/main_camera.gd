extends Camera3D

#var tower := load(TowerSpawner.TowerDictionary[TowerSpawner.currentTower])
@onready var map: Node3D = $".."

func _input(event):
	if event.is_action_pressed("Left Click"):
		shoot_ray()


func shoot_ray() -> void:
	var mousePos = get_viewport().get_mouse_position()
	var rayLength = 1000
	var from = project_ray_origin(mousePos)
	var to = from + project_ray_normal(mousePos) * rayLength 
	var space = get_world_3d().direct_space_state
	var rayQuery = PhysicsRayQueryParameters3D.new()
	rayQuery.from = from
	rayQuery.to = to
	var rayCastResult = space.intersect_ray(rayQuery)
	print(rayCastResult)
	
	if !rayCastResult.is_empty():
		var instance = TowerSpawner.SpawnTower.instantiate()
		instance.position = rayCastResult["position"]
		map.add_child(instance)
