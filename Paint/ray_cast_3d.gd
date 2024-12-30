extends RayCast3D

const SPAWN_RAYCAST = preload("res://Scenes/spawn_raycast.tscn") 
@onready var world: Node3D = $"../../../../.."
@onready var multi_mesh_instance_3d: MultiMeshInstance3D = $"../../../../../MultiMeshInstance3DWhite"
var all_transform: Array[Transform3D]
var norm: Vector3 = Vector3.UP
var posit_hit1
var transform_3d
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Shoot"):
		var colider = get_collider()
		
		if colider:
			
			posit_hit1 = get_collision_point()
			

			var norm1 = global_position - posit_hit1
			var axis = Vector3(0, 1, 0).cross(norm1).normalized()
			var angle = Vector3.UP.angle_to(norm1)
			var rotation_basis
			if axis != Vector3(0,0,0):
				rotation_basis = Basis().rotated(axis, angle)
			else:
				rotation_basis = basis
			transform_3d = Transform3D(rotation_basis, posit_hit1)
			
			for i in randi_range(30,50):
				var ray = SPAWN_RAYCAST.instantiate()
				world.add_child(ray)
				ray.transform = transform_3d 
				ray.get_child(0).create.connect(Add_splash_To_List)
				
				
func Add_splash_To_List(Ray) -> void:
	var colider = Ray.get_collider()
	
	if colider:
		norm = Ray.get_collision_normal()
		var axis = Vector3(0, 1, 0).cross(norm).normalized()
		var angle = Vector3.UP.angle_to(norm)
			#var circle = SHOT.instantiate()
		var currentInstanceNumber = multi_mesh_instance_3d.multimesh.instance_count
		var rotation_basis
		if axis != Vector3(0,0,0):
			rotation_basis = Basis().rotated(axis, angle)
		else:
			rotation_basis = basis
		var posit = Ray.get_collision_point()
		var transform_3 = Transform3D(rotation_basis, posit)
		all_transform.append(transform_3)
		multi_mesh_instance_3d.multimesh.instance_count = all_transform.size()
		for aech in multi_mesh_instance_3d.multimesh.instance_count:
			multi_mesh_instance_3d.multimesh.set_instance_transform(aech, all_transform[aech])
