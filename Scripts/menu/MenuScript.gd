extends Node3D

@onready var camera: Camera3D = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera.rotate_y(0.3 * delta)


func _on_start_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/map.tscn")
	# Replace with function body.


func _on_quit_button_down() -> void:
	get_tree().quit()
