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

var tName : String = "Enemy"
var damage : int = 2
var age : int = 0
var tPosition : Vector3 = Vector3(0,0,0)
var attackingNode = null

@onready var timer: Timer = $AttackTimer
@onready var hitbox_area: Area3D = $HitboxArea
@onready var attack_area: Area3D = $AttackArea
@onready var health_bar: ProgressBar = $HealthBar/SubViewport/Panel/Health

# signal that enemy sends to enemy_path.gd
signal stop_movement
signal start_movement

func _ready() -> void:
	health_bar.max_value = MAXHEALTH


# z = rows , x = columns
func _process(_delta: float) -> void:
	health_bar.value = health
	if health <= 0: # removes itself once it dies
		EnemySpawner.enemykilled += 1
		queue_free()

func _on_attack_area_area_entered(area: Area3D) -> void:
	if hitbox_area != area: # Ignores its own hitbox
		var parent = area.get_parent()
		if parent.is_in_group("Tower"): # Checks if the node is a tower
			attackingNode = parent
			timer.start() # Starts the attack
			stop_movement.emit() # Tells enemy_path.gd to stop moving

# Checks if there's something in its way
func _on_hitbox_area_area_entered(area: Area3D) -> void:
	stop_movement.emit() # Tells enemy_path.gd to stop moving

# Starts to move if nothing is in the way 
func _on_hitbox_area_area_exited(_area: Area3D) -> void:
	start_movement.emit()

# Attackingggg
func _on_timer_timeout() -> void: 
	if attackingNode != null:
		attackingNode.health -= damage

# Starts to move if there isn't anything in its way
func _on_attack_area_area_exited(_area: Area3D) -> void:
	timer.stop()
	start_movement.emit()
