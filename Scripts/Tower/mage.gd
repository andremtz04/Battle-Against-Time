extends Sprite3D

# Things to make sure each character has
# Inspector: 
# 	SpriteBase3D: 
#		Offset y = 50 px
# 		Flags: Billboard = True
# Update name to ui.gd, economy.gd, tower_spawner.gd
# Add to the correct group

var tName : String = "Mage"
var attackRange : int = 5 
var damage : int = 1
var age : int = 0
var health : int = 10
var tPosition : Vector3 = Vector3(0,0,0)

var zUp
var zDown
var xLeft
var xRight

@onready var timer: Timer = $Timer

# z = rows , x = columns
func attack() -> void:
	for r in range(zUp, zDown+1):
		for c in range(xLeft, xRight+1):
			var currSlot : Node3D = TowerSpawner.mapGrid[r][c]
			if not is_instance_valid(currSlot):
				pass
			if is_instance_valid(currSlot):
				if currSlot.is_in_group("Enemy"):
					currSlot.health -= damage


func calculate_radius() -> void:
	zUp = tPosition.z - attackRange
	zDown = tPosition.z + attackRange
	xLeft = tPosition.x - attackRange
	xRight = tPosition.x + attackRange
	if (zUp < 0):
		zUp = 0
	if (zDown >= TowerSpawner.row):
		zDown = TowerSpawner.row - 1
	if (xLeft < 0):
		xLeft = 0
	if (xRight >= TowerSpawner.col):
		xRight = TowerSpawner.col - 1


func _on_timer_timeout() -> void:
	attack()
