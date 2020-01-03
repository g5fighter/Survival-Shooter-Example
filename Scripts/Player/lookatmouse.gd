extends Position2D

export (bool) var notRotate = false
export (int) var distance = 0
var distance2Mouse

export (NodePath) var player
onready var player_node = get_node(player)

# warning-ignore:unused_argument
func _process(delta):
	distance2Mouse = player_node.position.distance_to(get_global_mouse_position())
	if(notRotate):
		if(distance2Mouse>distance):
			look_at(get_global_mouse_position())
	else:
		look_at(get_global_mouse_position())
