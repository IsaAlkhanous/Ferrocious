extends Node3D


# Called when the node enters the scene tree for the first 
func _ready() -> void:
	$Timer.start()


func _on_timer_timeout():
	print("done")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Paint/results.tscn")
