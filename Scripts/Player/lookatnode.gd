extends Position2D

export (NodePath) var lab
onready var ui_lab = get_node(lab)

# warning-ignore:unused_argument
func _process(delta):
	look_at(ui_lab.global_position)

