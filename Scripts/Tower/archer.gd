extends AnimatedSprite3D

# Things to make sure each character has
# Inspector: 
# 	SpriteBase3D: 
#		Offset y = 50 px
# 		Flags: Billboard = True
# Update name to ui.gd, economy.gd, tower_spawner.gd
# Add to the correct group

const MAXHEALTH : int = 15
const MAXAGE : int = 5
const BASEDAMAGE : int = 2

var health : float = MAXHEALTH
var tName : String = "Archer"
var damage : int = 3
var age : int = 1
var tPosition : Vector3 = Vector3(0,0,0)
var attackingNode = null # To save the node that it is attacking

var opacity : float = 0
var num_of_attacks : int = 0
var seconds : float = 0.0

var enemyQueue : Array

@onready var archer: AnimatedSprite3D = $"."
@onready var timer: Timer = $AttackTimer
@onready var hitbox_area: Area3D = $HitboxArea
@onready var health_bar: ProgressBar = $HealthBar/SubViewport/Panel/Health
@onready var map : Node3D = archer.get_parent_node_3d()

const PROJECTILE = preload("res://Scenes/towers/projectile/projectile.tscn")

func _ready() -> void:
	health_bar.max_value = MAXHEALTH
	archer.play("Idle")

# z = rows , x = columns
func _process(_delta: float) -> void:
	archer.material_overlay.set_shader_parameter("opacity",opacity)
	health_bar.value = health
	if health <= 0:
		TowerSpawner.mapGrid[global_position.z-1][floor(global_position.x)] = null
		queue_free()
	if enemyQueue.is_empty():
		timer.stop()
		attackingNode = null
		archer.play("Idle")


# Checks if an enemy enters its strike range
func _on_attack_area_area_entered(area: Area3D) -> void:
	if hitbox_area != area: # Ignores its own hitbox
		var parent = area.get_parent()
		if parent.is_in_group("Enemy"): # Attack function
			attackingNode = parent
			enemyQueue.append(parent)
			attack()
			aging()
			timer.start()

# Stops attacking once they leaving the attacking area
func _on_attack_area_area_exited(area: Area3D) -> void:
	if hitbox_area != area:
		var parent = area.get_parent()
		if parent.is_in_group("Enemy"):
			var i = 0
			for enemy in enemyQueue:
				if enemy == parent:
					enemyQueue.remove_at(i)
				i += 1

# The attacking timer
func _on_timer_timeout() -> void:
	await get_tree().create_timer(seconds).timeout
	attack()
	aging()

func attack() -> void:
	attackingNode = enemyQueue[0]
	if attackingNode != null:
		archer.play("Attacking")
		num_of_attacks = num_of_attacks + 1				#keeps track of number of attacks for age
		spawn_projectile()
		await get_tree().create_timer(seconds).timeout
		archer.play("Idle")

func spawn_projectile() -> void:
	var instance = PROJECTILE.instantiate()
	map.add_child(instance)
	instance.global_position = Vector3(archer.global_position.x, archer.global_position.y+1, archer.global_position.z)
	instance.set_variables(attackingNode, archer)
	
func aging() -> void:
	if (num_of_attacks >= 1 && age <= MAXAGE):
		if (age <= MAXAGE):
			age = age + 1
			opacity += 0.1
		else:
			health -= MAXHEALTH * 0.25
		num_of_attacks = 0
		damage = BASEDAMAGE + floor(age/2)
		seconds = age * 0.5
	
