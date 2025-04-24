extends Sprite3D

@onready var dummy_tower: Sprite3D = $"."
var frameNum = null

var SpritePos : Dictionary = {
	"null" : 0,
	"Mage" : 3,
	"Fist" : 5, # Change to 5
	"Healer" : 1,
	"Tank" : 4,
	"Archer" : 0,
	"Farmer" : 2,
	"Enemy" : 0
}

func _ready() -> void:
	frameNum = SpritePos[TowerSpawner.currentTower]
	if frameNum != -1:
		dummy_tower.frame = frameNum
