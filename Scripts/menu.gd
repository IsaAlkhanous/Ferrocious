extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://First_Level.tscn")


func _on_how_to_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/how_to_play.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
