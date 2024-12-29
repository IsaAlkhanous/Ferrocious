There are TSCNs
  L AutomaticPistol.tscn :   This is the pistol scene
  L Pistol_Bullet.tscn   :   This one is the bullet scene

1. In first time: Don't forget to adjust 'input map' to match your in-game keys! You change this in pistol's script 'automatic_pistol.gd'
[At: script/automatic_pistol.gd]----------------------
Input.is_action_just_pressed("fire")
Input.is_action_just_pressed("reload")
-----------------------------------------------------------

2. And edit this to match your directory
[At: script/automatic_pistol.gd]----------------------
@onready var bullet_scene: PackedScene = preload("res://assets/Pistol/Pistol_Bullet.tscn")
-----------------------------------------------------------
