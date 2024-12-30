extends Control

func _on_back_pressed() -> void: #back to menu
	get_tree().change_scene_to_file("res://Scenes/menu.tscn") 
