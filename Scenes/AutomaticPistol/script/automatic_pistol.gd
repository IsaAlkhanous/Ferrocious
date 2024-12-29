extends Node3D

# @export ----------------------------------------------------------------------
# Set the rate of fire for the gun (time between shots in seconds).
@export var fire_rate: float = 0.2 
# Define the maximum ammo the gun can hold.
@export var max_ammo: int = 10
# Set the time it takes to reload the gun (in seconds).
@export var reload_time: float = 2.0
#-------------------------------------------------------------------------------

# @onready ---------------------------------------------------------------------
@onready var bullet_scene: PackedScene = preload("res://assets/AutomaticPistol/Pistol_Bullet.tscn")
@onready var bullet_spawn_point: Marker3D = $BulletSpawnPoint
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Initialize the current ammo count to the maximum ammo capacity.
var ammo: int = max_ammo
# Timer to manage the delay between consecutive shots.
var timer 
# Boolean flag to track if the gun is currently reloading.
var reloading: bool = false
#-------------------------------------------------------------------------------

func _ready():
    # Create and configure the timer for the gun's fire rate.
    timer = Timer.new()
    timer.wait_time = fire_rate
    timer.autostart = false
    timer.one_shot = true
    add_child(timer)

func _physics_process(_delta):
    # Check if the player has pressed the fire button and if the gun is ready to shoot.
    if Input.is_action_pressed("fire") and timer.is_stopped() and not reloading:
        if ammo > 0:
            fire()
        else:
            print("Out of ammo! Reload needed.")

    # Check if the player has pressed the reload button and if the gun is not already reloading.
    if Input.is_action_just_pressed("reload") and not reloading:
        reload()

func fire():
    # Instantiate a new bullet from the bullet scene.
    var bullet = bullet_scene.instantiate()
    
    # Add the bullet to the scene as a child of the gun's parent node.
    get_parent().add_child(bullet)
    
    # Now that the bullet is inside the scene tree, set its position and rotation.
    bullet.global_position = bullet_spawn_point.global_position
    bullet.rotation = bullet_spawn_point.rotation
    
    # Decrease the ammo count by 1 with each shot.
    ammo -= 1
    print("Pistol Ammo: " + str(ammo)) # Print the remaining ammo to the console.
    
    # Start the timer to enforce the fire rate delay.
    timer.start()


func reload():
    # Check if the ammo is not already full.
    if ammo < max_ammo:
        # Set the reloading flag to true to prevent firing during reload.
        reloading = true
        print("Reloading...")
        
        # Wait for the reload time to complete before refilling the ammo.
        await(get_tree().create_timer(reload_time).timeout)
        
        # Refill the ammo to the maximum capacity.
        ammo = max_ammo
        
        # Set the reloading flag back to false to allow firing again.
        reloading = false
        print("Reload complete. Ammo: " + str(ammo)) # Print the current ammo count to the console.
