extends CharacterBody3D

var speed : int = 13
var target_node : Node3D
var direction : Vector3
var damage : int

func _physics_process(_delta):
	if is_instance_valid(target_node): # Checks if it has a target
		velocity = direction * speed
		move_and_slide() # Is what makes it move


func set_variables(target: Node3D, origin : Node3D):
	print(origin.name)
	damage = origin.damage
	if origin.name == "Mage":
		$Sprite3D.frame = 0
	if origin.name == "Archer":
		$Sprite3D.frame = 1
	target_node = target
	direction = (target_node.global_position - global_position).normalized() # Sets where it wants to go
	#direction.y += 0.25 # Makes it so it doesn't attack their feet


# Damge dectection
func _on_area_3d_area_entered(area: Area3D) -> void: 
	var parent = area.get_parent()
	if parent.is_in_group("Enemy"):
		parent.health -= damage
		queue_free()


func _on_timeout_timeout() -> void:
	queue_free()
