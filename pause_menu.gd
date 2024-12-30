extends Control

# Pause and resume when Pause is pressed
func Resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = false
func Pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true
func Test_Esc():
	if Input.is_action_just_pressed("Pause") and get_tree().paused == false:
		Pause()
	elif  Input.is_action_just_pressed("Pause") and get_tree().paused == true:
		Resume()
		
func Restart():
	Resume()
	get_tree().reload_current_scene()
func Settings():
	pass
func Main_Menu():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _ready():
	$AnimationPlayer.play("RESET")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Test_Esc()


func _on_resume_pressed() -> void:
	Resume()
	
func _on_restart_pressed() -> void:
	Restart()
	
func _on_settings_pressed() -> void:
	Settings()

func _on_main_menu_pressed() -> void:
	Main_Menu()