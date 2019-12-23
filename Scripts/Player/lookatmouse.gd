extends Position2D

export (bool) var notRotate = false
export (int) var distance = 0
var distance2Mouse

export (NodePath) var player
onready var player_node = get_node(player)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#	pass
	distance2Mouse = player_node.position.distance_to(get_global_mouse_position())
	if(notRotate):
		if(distance2Mouse>distance):
			look_at(get_global_mouse_position())
	else:
		look_at(get_global_mouse_position())
#	pass
