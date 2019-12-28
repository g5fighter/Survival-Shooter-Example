extends KinematicBody2D
var followedNode
var distance

func _ready():
	add_to_group("follow")

func start(pos, node, dis):
	position = pos
	followedNode = node
	distance = dis
	
func play_anim_golpear():
	followedNode.play_anim_golpear()
