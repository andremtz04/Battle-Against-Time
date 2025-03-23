extends PathFollow3D

var isMoving : bool = true
var moveSpeed : int = 3
var currPosition : Vector3

@onready var enemy_1: Sprite3D = $Enemy1
@onready var enemy_path: PathFollow3D = $"."

func _ready() -> void:
	var hitbox = enemy_1.get_node("HitboxArea")
	hitbox.connect("area_entered", _on_hitbox_area_entered)
	#hitbox.connect("area_exited", _on_hitbox_area_exit)


# Checks if collision with another body
func _on_hitbox_area_entered(_area: Area3D) -> void:
	print("stop moving")
	isMoving = false

# Checks if it leaves collision
#func _on_hitbox_area_exit(_area: Area3D) -> void:
	#print("start moving")
	#isMoving = true

func _process(delta: float) -> void:
	if isMoving:
		enemy_path.progress += moveSpeed * delta
