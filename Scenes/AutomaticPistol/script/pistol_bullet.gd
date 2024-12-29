extends RigidBody3D

# @export ----------------------------------------------------------------------
# Define the amount of damage the bullet will deal to an enemy.
@export var damage: int = 10
# Set the speed at which the bullet will travel.
@export var speed: float = 100.0
# Determine how long the bullet will exist before disappearing (in seconds).
@export var lifetime: float = 5.0
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Timer to control the bullet's lifetime.
var timer: Timer
#-------------------------------------------------------------------------------

func _ready():
    # Create and configure the timer to manage the bullet's lifetime.
    timer = Timer.new()
    timer.wait_time = lifetime # Set the timer to the bullet's lifetime.
    timer.autostart = true # Start the timer automatically.
    timer.one_shot = true # Ensure the timer only triggers once.
    add_child(timer) # Add the timer as a child of the bullet.
    
    # Connect the timer's timeout signal to the _on_timeout function.
    timer.connect("timeout", _on_timeout)
    
    # Set the bullet's initial movement direction and speed.
    linear_velocity = -global_transform.basis.z * speed

func _on_timeout():
    # Free the bullet from the scene once its lifetime has expired.
    queue_free()
