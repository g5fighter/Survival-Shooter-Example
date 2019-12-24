extends KinematicBody2D
var followedNode
var distance
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("follow")

func start(pos, node, dis):
	position = pos
	followedNode = node
	distance = dis
	
func play_anim_golpear():
	followedNode.play_anim_golpear()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
