extends Node3D

@onready var spawn_points: Array = get_children()  # Automatically get all spawn points
@onready var player_1: CharacterBody3D = $"../GridContainer/SubViewportContainer/SubViewport/player1"
@onready var player_2: CharacterBody3D = $"../GridContainer/player_2_screen/SubViewport/player2"


func spawn_player(player_instance: CharacterBody3D) -> void:
	# Randomly choose a spawn point and remove it from the list
	if spawn_points.size() > 0:
		var random_index = randi() % spawn_points.size()
		var spawn_point = spawn_points[random_index]
		spawn_points.remove_at(random_index)  # Remove this point to avoid duplicates

		# Position the player at the chosen spawn point
		player_instance.global_transform.origin = spawn_point.global_transform.origin

func _ready():
	# Seed random number generator
	randomize()
	# Spawn Player 1 and Player 2
	spawn_player(player_1)
	spawn_player(player_2)
