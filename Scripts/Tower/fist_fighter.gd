extends Sprite3D

# Things to make sure each character has
# Inspector: 
# 	SpriteBase3D: 
#		Offset y = 50 px
# 		Flags: Billboard = True
# Update name to ui.gd, economy.gd, tower_spawner.gd
# Add to the correct group

var tName : String = "Fist"
var attackRange : int = 1
var damage : int = 1
var age : int = 0
var health : int = 10
var tPosition : Vector3 = Vector3(0,0,0)

@onready var timer: Timer = $Timer
@onready var hitbox_area: Area3D = $HitboxArea

# z = rows , x = columns
func attack(node : Sprite3D) -> void:
	print("attacking ", node.tName)


func _on_timer_timeout() -> void:
	pass
	#attack()


func _on_attack_area_area_entered(area: Area3D) -> void:
	if hitbox_area != area: # Ignores its own hitbox
		var parent = area.get_parent()
		if parent.is_in_group("Enemy"): # Attack function
			attack(parent)
