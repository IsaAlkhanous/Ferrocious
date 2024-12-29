extends CharacterBody3D
@onready var head: Node3D = $head
@onready var standing_collision: CollisionShape3D = $standingCollision
@onready var crouching_collision: CollisionShape3D = $crouchingCollision
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var eyes: Node3D = $head/eyes
@export var player_id = 1
@onready var gun_anim = $head/eyes/Camera3D/Pistol/AnimationPlayer
@onready var gun_barrel = $head/eyes/Camera3D/Pistol/RayCast3D
@onready var marker_3d: Marker3D = $head/eyes/Camera3D/Marker3D

#bullets
var bullet = load("res://Scenes/bullet.tscn")
var instance

# Speed Variables
var current_speed = 5.0 #current speed 
const WALKING_SPEED =4.5 
const SPRINTING_SPEED = 7.5
const CROUCHING_SPEED = 3.0
const SLIDE_SPEED = 10.0

#Jumping Variables
const JUMP_VELOCITY = 6.5
var jump_count = 0
const MAX_JUMP = 2

# Mouse Varaibles
const MOUSE_SENS = 0.2 

# Lerp variables
var lerp_speed = 10.0
var direction = Vector3.ZERO

# crouching variables
const CROUCHING_DEPTH = 0.5

# Sliding variables
var slide_timer = 0
const MAX_SLIDE = 1
var sliding = false
var slide_vector = Vector2.ZERO

# Current player state
var sprinting = false
var crouching = false
var walking = false

#HeadBob Variables
var head_bobbing_sprinting_speed = 22.0
var head_bobbing_walking_speed = 14.0
var head_bobbing_crouching_speed = 10.0

var head_bobbing_sprinting_intensity = 0.2
var head_bobbing_walking_intensity = 0.1
var head_bobbing_crouching_intensity = 0.05

var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 0.0
var head_bobbing_intensity = 0.0
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #lock mouse into game window
	
	# handle camera movement using the mouse (and Quit)
func _input(event):
	if event is InputEventMouseMotion and player_id == 1: #handle mouse rotation
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
		head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))	
	if Input.is_action_just_pressed("Quit_%s" % [player_id]): #Press Esc to Quit the Scene
		get_tree().quit()
		
	# Movement mechanics
func _physics_process(delta: float) -> void:
	# Getting movement input
	var input_dir := Input.get_vector("left_%s" % [player_id], "right_%s" % [player_id], "forwards_%s" % [player_id], "backwards_%s" % [player_id])
	
	#crouch mechanics
	if Input.is_action_pressed("crouch_%s" % [player_id]) || sliding: # it sets the speed to crouch speed and also added lerp to look more natural
		current_speed = CROUCHING_SPEED 
		head.position.y = lerp(head.position.y, 1.2 - CROUCHING_DEPTH,delta * lerp_speed)
		standing_collision.disabled = true
		crouching_collision.disabled = false
		
		if sprinting && input_dir != Vector2.ZERO:
			sliding= true
			slide_vector = input_dir
			slide_timer = MAX_SLIDE
		
		crouching = true
		sprinting = false
		walking = false
		
	elif !ray_cast_3d.is_colliding(): #checks if there is nothing ontop of the player using RayCast
		standing_collision.disabled = false 
		crouching_collision.disabled = true
		head.position.y = lerp(head.position.y, 1.2, delta * lerp_speed)
		crouching = false
		# add the sprinting by changing current speed
		if Input.is_action_pressed("sprint_%s" % [player_id]):
			current_speed = SPRINTING_SPEED
			sprinting = true
			walking = false
		else: # This is when the character is walking
			current_speed = WALKING_SPEED
			sprinting = false
			walking = true
	if sliding:
		slide_timer -= delta
		if slide_timer <= 0:
			sliding = false
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump, counts jump number and jumps if its less than 2.
	if Input.is_action_just_pressed("jump_%s" % [player_id]) and jump_count < MAX_JUMP-1:
		velocity.y = JUMP_VELOCITY
		jump_count = jump_count + 1
		sliding = false
	if is_on_floor() :
		jump_count = 0
	if is_on_floor():
		direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*lerp_speed)
	else:
		if input_dir != Vector2.ZERO:
			direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*lerp_speed)
			
	if sliding:
		direction = (transform.basis * Vector3(slide_vector.x,0,slide_vector.y)).normalized()
		head.rotation.z = lerp(head.rotation.z,deg_to_rad(-2),delta*lerp_speed)
		
	# handle headbob
	if crouching:
		head_bobbing_intensity = head_bobbing_crouching_intensity
		head_bobbing_index += head_bobbing_crouching_speed*delta
	elif sprinting:
		head_bobbing_intensity = head_bobbing_sprinting_intensity
		head_bobbing_index += head_bobbing_sprinting_speed*delta
	elif walking:
		head_bobbing_intensity = head_bobbing_walking_intensity
		head_bobbing_index += head_bobbing_walking_speed*delta
		
	if is_on_floor() and !sliding and input_dir !=Vector2.ZERO:
		head_bobbing_vector.y = sin(head_bobbing_index)
		head_bobbing_vector.x = sin(head_bobbing_index/2)+0.5
		
		eyes.position.y = lerp(eyes.position.y,head_bobbing_vector.y*(head_bobbing_intensity/2.0),delta*lerp_speed)
		eyes.position.x = lerp(eyes.position.x,head_bobbing_vector.x*(head_bobbing_intensity),delta*lerp_speed)
	else:
		eyes.position.y = lerp(eyes.position.y,0.0,delta*lerp_speed)
		eyes.position.x = lerp(eyes.position.x,0.0,delta*lerp_speed)
	if not sliding:
		head.rotation.z = lerp(head.rotation.z,deg_to_rad(0),delta*lerp_speed)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	
		if sliding:
			velocity.x = direction.x * (slide_timer + 0.1) * SLIDE_SPEED
			velocity.z = direction.z * (slide_timer + 0.1) * SLIDE_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		
	# CONTROLLER
	var x_axis = Input.get_action_strength("look_right_%s" % [player_id]) - Input.get_action_strength("look_left_%s" % [player_id])
	var y_axis = Input.get_action_strength("look_down_%s" % [player_id]) - Input.get_action_strength("look_up_%s" % [player_id])
	var joystick_sens = 3.0  # Tweak to taste
	rotate_y(-x_axis * joystick_sens * delta)
	head.rotate_x(-y_axis * joystick_sens * delta)
	head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	#Shooting mechanics
	if Input.is_action_just_pressed("shooting_%s" % [player_id]):
		if !gun_anim.is_playing():
			gun_anim.play("shoot") 
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.destination = marker_3d.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)
	move_and_slide()