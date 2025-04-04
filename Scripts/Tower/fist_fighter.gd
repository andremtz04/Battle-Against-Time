extends Sprite3D

# Things to make sure each character has
# Inspector: 
# 	SpriteBase3D: 
#		Offset y = 50 px
# 		Flags: Billboard = True
# Update name to ui.gd, economy.gd, tower_spawner.gd
# Add to the correct group

var tName : String = "Fist"
var damage : int = 5
var age : int = 0
var health : int = 10
var tPosition : Vector3 = Vector3(0,0,0)
var attackingNode = null

@onready var timer: Timer = $Timer
@onready var hitbox_area: Area3D = $HitboxArea

# z = rows , x = columns
func _process(_delta: float) -> void:
	if health <= 0:
		queue_free()


func _on_attack_area_area_entered(area: Area3D) -> void:
	if hitbox_area != area: # Ignores its own hitbox
		var parent = area.get_parent()
		#print(attackingNode)
		if parent.is_in_group("Enemy"): # Attack function
			attackingNode = parent
			timer.start()
			#pass


func _on_attack_area_area_exited(_area: Area3D) -> void:
	timer.stop()


func _on_timer_timeout() -> void:
	if attackingNode != null:
		attackingNode.health -= damage
		#print(attackingNode.health)
