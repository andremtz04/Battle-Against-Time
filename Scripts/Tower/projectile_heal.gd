extends CharacterBody3D

var speed : int = 10
var target_node : Node3D
var direction : Vector3
var damage : int
var origin_tower

func _physics_process(_delta):
	if is_instance_valid(target_node): # Checks if it has a target
		velocity = direction * speed
		move_and_slide() # Is what makes it move


func set_variables(target: Node3D, origin : Node3D):
	origin_tower = origin
	damage = origin.damage
	target_node = target
	direction = (target_node.global_position - global_position).normalized() # Sets where it wants to go
	direction.y += 0.25 # Makes it so it doesn't attack their feet


# Damge dectection
func _on_area_3d_area_entered(area: Area3D) -> void: 
	var parent = area.get_parent()
	if parent.is_in_group("Tower") && !parent.is_in_group("Healer"):
		parent.health += damage
		if parent.age > 1:
			parent.age -= 1
			parent.opacity -= 0.1
		if parent.health > parent.MAXHEALTH:
			parent.health = parent.MAXHEALTH
			
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
