extends AnimatedSprite3D

# Things to make sure each character has
# Inspector: 
# 	SpriteBase3D: 
#		Offset y = 50 px
# 		Flags: Billboard = True
# Update name to ui.gd, economy.gd, tower_spawner.gd
# Add to the correct group

var tName : String = "Mage"
var damage : int = 3
var age : int = 0
var health : int = 10
var tPosition : Vector3 = Vector3(0,0,0)
var attackingNode = null # To save the node that it is attacking

@onready var mage: AnimatedSprite3D = $"."
@onready var timer: Timer = $AttackTimer
@onready var hitbox_area: Area3D = $HitboxArea

# z = rows , x = columns
func _process(_delta: float) -> void:
	if health <= 0:
		queue_free()

# Checks if an enemy enters its strike range
func _on_attack_area_area_entered(area: Area3D) -> void:
	if hitbox_area != area: # Ignores its own hitbox
		var parent = area.get_parent()
		if parent.is_in_group("Enemy"): # Attack function
			attackingNode = parent
			timer.start()

# Stops attacking once they leaving the attacking area
func _on_attack_area_area_exited(_area: Area3D) -> void:
	timer.stop()
	mage.play("Idle")

# The attacking timer
func _on_timer_timeout() -> void:
	if attackingNode != null:
		mage.play("Attacking")
		attackingNode.health -= damage
