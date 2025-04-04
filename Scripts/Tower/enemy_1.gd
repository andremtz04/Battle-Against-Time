extends Sprite3D

# Things to make sure each character has
# Inspector: 
# 	SpriteBase3D: 
#		Offset y = 50 px
# 		Flags: Billboard = True
# Update name to ui.gd, economy.gd, tower_spawner.gd
# Add to the correct group

var tName : String = "Enemy"
var damage : int = 2
var age : int = 0
var health : int = 10
var tPosition : Vector3 = Vector3(0,0,0)
var attackingNode = null

@onready var timer: Timer = $Timer
@onready var hitbox_area: Area3D = $HitboxArea
@onready var attack_area: Area3D = $AttackArea

signal stop_movement # signal that enemy sends to enemy_path.gd
signal start_movement

# z = rows , x = columns
func _process(_delta: float) -> void:
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


func _on_hitbox_area_area_entered(area: Area3D) -> void:
	stop_movement.emit() # Tells enemy_path.gd to stop moving


func _on_hitbox_area_area_exited(_area: Area3D) -> void:
	start_movement.emit()

func _on_timer_timeout() -> void: # idk maybe an attack cooldown
	if attackingNode != null:
		attackingNode.health -= damage

func _on_attack_area_area_exited(_area: Area3D) -> void:
	timer.stop()
	start_movement.emit()
