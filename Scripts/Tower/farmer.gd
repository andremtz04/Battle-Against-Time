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

var tName : String = "Farmer"
var damage : int = 5
var base_damage : int = 1
var age : int = 1
var tPosition : Vector3 = Vector3(0,0,0)

var num_of_attacks : int = 0
var seconds : float = 0.0

@onready var farmer: AnimatedSprite3D = $"."
@onready var timer: Timer = $AttackTimer
@onready var hitbox_area: Area3D = $HitboxArea
@onready var health_bar: ProgressBar = $HealthBar/SubViewport/Panel/Health
@onready var map : Node3D = farmer.get_parent_node_3d()

const PROJECTILE = preload("res://Scenes/towers/projectile/farmer_money.tscn")

func _ready() -> void:
	health_bar.max_value = MAXHEALTH
	farmer.play("Idle")
	timer.start()

# z = rows , x = columns
func _process(_delta: float) -> void:
	health_bar.value = health
	if health <= 0:
		queue_free()

# The attacking timer
func _on_timer_timeout() -> void:
	await get_tree().create_timer(seconds).timeout
	attack()
	aging()

func attack() -> void:
	farmer.play("Attacking")
	num_of_attacks = num_of_attacks + 1
	spawn_projectile()

func spawn_projectile() -> void:
	var instance = PROJECTILE.instantiate()
	map.add_child(instance)
	instance.global_position = Vector3(farmer.global_position.x, farmer.global_position.y+1, farmer.global_position.z)
	instance.set_variables(farmer)
	
func aging() -> void:
	if (num_of_attacks >= 20):
		if (age <= 5):
			age = age + 1
		else:
			health -= 2
		num_of_attacks = 0
		damage = base_damage + age
		seconds = age * 0.5
	
