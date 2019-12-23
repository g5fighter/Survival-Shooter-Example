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
func _process(delta):
	if(player_node==null&&!playerFound):
		searchPlayer()
	elif(wr.get_ref()):
		look_at(player_node.global_position)
	else:
		playerFound = false

func find_node_by_name(root, name):

    if(root.get_name() == name): return root

    for child in root.get_children():
        if(child.get_name() == name):
            return child

        var found = find_node_by_name(child, name)

        if(found): return found

    return null
