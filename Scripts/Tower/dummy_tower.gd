extends Sprite3D

@onready var dummy_tower: Sprite3D = $"."
var frameNum = null

var SpritePos : Dictionary = {
	"null" : -1,
	"Mage" : 0,
	"Fist" : 1,
	"Healer" : 2,
	"Tank" : 0,
	"Archer" : 0,
	"Farmer" : 0,
	"Enemy" : 3
}

func _ready() -> void:
	frameNum = SpritePos[TowerSpawner.currentTower]
	if frameNum != -1:
		dummy_tower.frame = frameNum
