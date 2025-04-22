extends AnimatedSprite3D

# Things to make sure each character has
# Inspector: 
# 	SpriteBase3D: 
#		Offset y = 50 px
# 		Flags: Billboard = True
# Update name to ui.gd, economy.gd, tower_spawner.gd
# Add to the correct group

const MAXHEALTH : int = 15
var health : int = MAXHEALTH

var tName : String = "Healer"
var damage : int = 5

var age : int = 1
var tPosition : Vector3 = Vector3(0,0,0)
var attackingNode = null # To save the node that it is attacking

var num_of_attacks : int = 0
var seconds : float = 0.0

var enemyQueue : Array

@onready var healer: AnimatedSprite3D = $"."
@onready var timer: Timer = $AttackTimer
@onready var hitbox_area: Area3D = $HitboxArea
@onready var health_bar: ProgressBar = $HealthBar/SubViewport/Panel/Health
@onready var map : Node3D = healer.get_parent_node_3d()

const PROJECTILE = preload("res://Scenes/towers/projectile/projectile_heal.tscn")

func _ready() -> void:
	health_bar.max_value = MAXHEALTH
	healer.play("Idle")

# z = rows , x = columns
func _process(_delta: float) -> void:
	health_bar.value = health
	if health <= 0:
		queue_free()
	if enemyQueue.is_empty():
		timer.stop()
		attackingNode = null
		healer.play("Idle")

# Checks if an enemy enters its strike range
func _on_attack_area_area_entered(area: Area3D) -> void:
	if hitbox_area != area: # Ignores its own hitbox
		var parent = area.get_parent()
		if parent.is_in_group("Tower"): # Attack function
			attackingNode = parent
			enemyQueue.append(parent)
			attack()
			aging()
			timer.start()

# Stops attacking once they leaving the attacking area
func _on_attack_area_area_exited(area: Area3D) -> void:
	if hitbox_area != area:
		var parent = area.get_parent()
		if parent.is_in_group("Tower"):
			var i = 0
			for enemy in enemyQueue:
				if enemy == parent:
					enemyQueue.remove_at(i)
				i += 1

func attack() -> void:
	if !enemyQueue.is_empty():
		attackingNode = enemyQueue[0]
		for tower in enemyQueue:
			if tower.health < attackingNode.health:
				attackingNode = tower
		
		healer.play("Attacking")
		num_of_attacks = num_of_attacks + 1				#keeps track of number of attacks for age
		spawn_projectile()
		await get_tree().create_timer(.50).timeout
		healer.play("Idle")

func spawn_projectile() -> void:
	if attackingNode.health < attackingNode.MAXHEALTH:
		var instance = PROJECTILE.instantiate()
		map.add_child(instance)
		instance.global_position = Vector3(healer.global_position.x, healer.global_position.y+1, healer.global_position.z)
		instance.set_variables(attackingNode, healer)
	
func aging() -> void:
	if (num_of_attacks >= 10):
		if (age <= 5):
			age = age + 1
		else:
			health -= 2
		num_of_attacks = 0
		seconds = age * 0.5
	

func _on_attack_timer_timeout() -> void:
	await get_tree().create_timer(seconds).timeout
	attack()
	aging()
