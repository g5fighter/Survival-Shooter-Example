extends Position2D

onready var gameScene = get_tree().get_root().get_node("MainScene")

# warning-ignore:unused_argument
func _process(delta):
	if(gameScene.playerFree.get_ref()):
		look_at(gameScene.player_node.global_position)
