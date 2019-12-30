extends Position2D

# Declare member variables here. Examples:
export (NodePath) var lab
onready var ui_lab = get_node(lab)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
#	pass
	look_at(ui_lab.global_position)

