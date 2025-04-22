extends AnimatedSprite3D

# Things to make sure each character has
# Inspector: 
# 	SpriteBase3D: 
#		Offset y = 50 px
# 		Flags: Billboard = True
# Update name to ui.gd, economy.gd, tower_spawner.gd
# Add to the correct group

const MAXHEALTH : int = 30
var health : int = MAXHEALTH

var tName : String = "Fist"
var damage : int = 5
var base_damage : int = 5
var age : int = 1
var tPosition : Vector3 = Vector3(0,0,0)
var attackingNode = null

var num_of_attacks : int = 0
var seconds : float = 0.0
var base_seconds : float = 0.0

var enemyQueue : Array

@onready var fist: AnimatedSprite3D = $"."
@onready var timer: Timer = $AttackTimer
@onready var hitbox_area: Area3D = $HitboxArea
@onready var health_bar: ProgressBar = $HealthBar/SubViewport/Panel/Health

func _ready() -> void:
	health_bar.max_value = MAXHEALTH
	fist.play("Idle")
	##IMPLEMENT AUDIO HERE ONCE DONE

# z = rows , x = columns
func _process(_delta: float) -> void:
	health_bar.value = health
	if health <= 0: # KYS
		queue_free()
	if enemyQueue.is_empty():
		timer.stop()
		attackingNode = null
		fist.play("Idle")


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
	attack()
	aging()

func attack() -> void:
	attackingNode = enemyQueue[0]
	if attackingNode != null:
		fist.play("Attacking")
		$FistAttack.play()
		attackingNode.health -= damage
		num_of_attacks = num_of_attacks + 1

func aging() -> void:
	if (num_of_attacks >= 15):
		if (age < 5):
			age = age + 1
		else:
			health -= MAXHEALTH * 0.2
		num_of_attacks = 0
		damage = base_damage + age
		seconds = age * 0.5
	
