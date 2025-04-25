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

var tName : String = "Enemy"
var damage : int = 5
var age : int = 0
var tPosition : Vector3 = Vector3(0,0,0)
var attackingNode = null
var enemyQueue : Array

@onready var timer: Timer = $AttackTimer
@onready var hitbox_area: Area3D = $HitboxArea
@onready var attack_area: Area3D = $AttackArea
@onready var health_bar: ProgressBar = $HealthBar/SubViewport/Panel/Health
@onready var enemy1: AnimatedSprite3D = $"."

# signal that enemy sends to enemy_path.gd
signal stop_movement
signal start_movement

func _ready() -> void:
	enemy1.play("Walking")
	health_bar.max_value = MAXHEALTH


# z = rows , x = columns
func _process(_delta: float) -> void:
	health_bar.value = health
	if health <= 0: # removes itself once it dies
		EnemySpawner.enemykilled += 1
		$EnemyDeath.play() ### DOES NOT WORK ATM DUE TO NODE DELETION. CONSIDER "DEATH" STATE.
		Economy.totalMoney += 15
		queue_free()
	if enemyQueue.is_empty():
		timer.stop()
		attackingNode = null
		enemy1.play("Walking")
		start_movement.emit()

func _on_attack_area_area_entered(area: Area3D) -> void:
	if hitbox_area != area: # Ignores its own hitbox
		var parent = area.get_parent()
		if parent.is_in_group("Tower"): # Checks if the node is a tower
			attackingNode = parent
			enemyQueue.append(parent)
			attack()
			timer.start() # Starts the attack
			stop_movement.emit() # Tells enemy_path.gd to stop moving


# Attackingggg
func _on_timer_timeout() -> void: 
	attack()


# Starts to move if there isn't anything in its way
func _on_attack_area_area_exited(area: Area3D) -> void:
	if hitbox_area != area:
		var parent = area.get_parent()
		if parent.is_in_group("Tower"):
			var i = 0
			for tower in enemyQueue:
				if tower == parent || tower.is_queued_free():
					enemyQueue.remove_at(i)
				i += 1

func attack():
	attackingNode = enemyQueue[0]
	if attackingNode != null:
		enemy1.play("Attacking")
		#print("attacking", attackingNode)
		attackingNode.health -= damage
