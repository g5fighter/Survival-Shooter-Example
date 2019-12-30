extends Position2D

# Declare member variables here. Examples:
var player_node
var wr
var playerFound = false
# Called when the node enters the scene tree for the first time.
func searchPlayer():
	var players = get_tree().get_nodes_in_group("player")
	for pl in players:
		if(!playerFound):
			player_node = pl
			wr = weakref(player_node)
			playerFound = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	if(player_node==null&&!playerFound):
		searchPlayer()
	elif(wr.get_ref()):
		look_at(player_node.global_position)
	else:
		playerFound = false
