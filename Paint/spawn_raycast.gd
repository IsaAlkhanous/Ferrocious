extends RayCast3D

signal create(ray)
@onready var timer: Timer = $Timer

func _ready() -> void:
	var ran = randf_range(-0.5, 0.5)
	var ran_deg = randf_range(0,360)
	var pos = Vector2(cos(deg_to_rad(ran_deg)) * ran, sin(deg_to_rad(ran_deg))* ran)
	position.x += pos.x
	position.z += pos.y
	

func _on_timer_timeout() -> void:
	create.emit(self)
	get_parent().queue_free()
	
