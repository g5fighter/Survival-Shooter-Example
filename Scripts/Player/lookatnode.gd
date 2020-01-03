extends Position2D

export (NodePath) var lab
onready var ui_lab = get_node(lab)

func _process(delta):
	look_at(ui_lab.global_position)

