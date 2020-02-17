extends Position2D

export (NodePath) var node_path
onready var node_obj = get_node(node_path)

func _process(_delta):
	look_at(node_obj.global_position)

