extends Node3D

var speed = 300

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@export var destination: Vector3 = Vector3.ZERO
@onready var ray_cast_3d: RayCast3D = $RayCast3D
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass



## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	translate(Vector3(0, 0, -speed * delta))
	ray_cast_3d.force_raycast_update()
	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		var collider_pos = ray_cast_3d.get_collision_point()
		queue_free()
		print(collider, collider_pos)
	


#func _on_area_3d_body_entered(body: Node3D) -> void:
	#ray_cast_3d.get_collision_point()
	#ray_cast_3d.get_collision_normal()
