extends Node2D
var Player = preload("res://objetos/player.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	_instantiate_player() # Replace with function body.

func _instantiate_player():
	var player = Player.instance()
	self.add_child(player)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
