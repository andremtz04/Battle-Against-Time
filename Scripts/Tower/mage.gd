extends AnimatedSprite3D

# Things to make sure each character has
# Inspector: 
# 	SpriteBase3D: 
#		Offset y = 50 px
# 		Flags: Billboard = True
# Update name to ui.gd, economy.gd, tower_spawner.gd
# Add to the correct group

const MAXHEALTH : int = 10
var health : int = MAXHEALTH

var tName : String = "Mage"
var damage : int = 1
var base_damage : int = 1
var age : int = 1
var tPosition : Vector3 = Vector3(0,0,0)
var attackingNode = null # To save the node that it is attacking

var num_of_attacks : int = 0
var seconds : float = 0.0

@onready var mage: AnimatedSprite3D = $"."
@onready var timer: Timer = $AttackTimer
@onready var hitbox_area: Area3D = $HitboxArea
@onready var health_bar: ProgressBar = $HealthBar/SubViewport/Panel/Health
@onready var map : Node3D = mage.get_parent_node_3d()

const PROJECTILE = preload("res://Scenes/towers/projectile.tscn")

func _ready() -> void:
	health_bar.max_value = MAXHEALTH
	mage.play("Idle")

# z = rows , x = columns
func _process(_delta: float) -> void:
	health_bar.value = health
	if health <= 0:
		queue_free()

# Checks if an enemy enters its strike range
func _on_attack_area_area_entered(area: Area3D) -> void:
	if hitbox_area != area: # Ignores its own hitbox
		var parent = area.get_parent()
		if parent.is_in_group("Enemy"): # Attack function
			attackingNode = parent
			attack()
			aging()
			timer.start()

# Stops attacking once they leaving the attacking area
func _on_attack_area_area_exited(_area: Area3D) -> void:
	attackingNode = null
	timer.stop()
	mage.play("Idle")

# The attacking timer
func _on_timer_timeout() -> void:
	await get_tree().create_timer(seconds).timeout
	attack()
	aging()

func attack() -> void:
	if attackingNode != null:
		mage.play("Attacking")
		num_of_attacks = num_of_attacks + 1				#keeps track of number of attacks for age
		print("num of attacks, ", num_of_attacks)		#to see results, should delete later
		print("damage is, ", damage)					#to see results, should delete later
		print("health is, ", health)					#to see results, should delete later
		spawn_projectile()

func spawn_projectile() -> void:
	var instance = PROJECTILE.instantiate()
	map.add_child(instance)
	instance.global_position = Vector3(mage.global_position.x, mage.global_position.y+1, mage.global_position.z)
	instance.set_variables(attackingNode, mage)
	
func aging() -> void:
	if (num_of_attacks >= 5):
		if (age <= 5):
			age = age + 1
		else:
			health -= 2
		num_of_attacks = 0
		damage = base_damage + age
		seconds = age * 0.5
	
