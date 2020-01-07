extends Position2D

export (bool) var notRotate = false
export (int) var distance = 0
var distance2Mouse

export (NodePath) var player
onready var player_node = get_node(player)

# warning-ignore:unused_argument
func _process(delta):
	if(Input.is_action_pressed('click')&&player_node.mobile_input):
		if(player_node.search_for_near_enemie()!=null):
			look_at(player_node.search_for_near_enemie().global_position)
	else:
		if(player_node.mobile_input):
			if player_node.velocity.x!=0||player_node.velocity.y!=0:
				global_rotation = player_node.velocity.angle()
		elif player_node.use_joystick:
			if player_node.direction.x!=0||player_node.direction.y!=0:
				global_rotation = player_node.direction.angle()
		else:
			distance2Mouse = player_node.position.distance_to(get_global_mouse_position())
			if(notRotate):
				if(distance2Mouse>distance):
					look_at(get_global_mouse_position())
			else:
				look_at(get_global_mouse_position())
