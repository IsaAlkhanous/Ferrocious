extends Control
@onready var winner: Label = $Winner
@onready var loser: Label = $Loser

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Global.player_score_1 > Global.player_score_2:
		winner.text = "Winner is Player 1, with a score of %s" % [Global.player_score_1]
		loser.text = "Winner is Player 2, with a score of %s" % [Global.player_score_2]
	elif Global.player_score_2 > Global.player_score_1:
		winner.text = "Winner is Player 2, with a score of %s" % [Global.player_score_2]
		loser.text = "Winner is Player 1, with a score of %s" % [Global.player_score_1]
	else: 
		winner.text = "Its a draw with a score of : %s" % [Global.player_score_2]
		
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn") 
