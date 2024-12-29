extends Node


func _ready() -> void:
	ControllerIcons.update_player_device(ControllerIcons.PlayerDevices.Player1,0)
	ControllerIcons.update_player_device(ControllerIcons.PlayerDevices.Player2,1)
	
	ControllerIcons.reload.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
