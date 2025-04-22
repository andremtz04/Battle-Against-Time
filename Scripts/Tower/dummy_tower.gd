extends Sprite3D

@onready var dummy_tower: Sprite3D = $"."
var frameNum = null

var SpritePos : Dictionary = {
	"null" : 0,
	"Mage" : 2,
	"Fist" : -1,
	"Healer" : 1,
	"Tank" : 3,
	"Archer" : 0,
	"Farmer" : 0,
	"Enemy" : 0
}

func _ready() -> void:
	frameNum = SpritePos[TowerSpawner.currentTower]
	if frameNum != -1:
		dummy_tower.frame = frameNum
