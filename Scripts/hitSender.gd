extends CollisionShape2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (NodePath) var lab
onready var ui_lab = get_node(lab)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func hit(damage):
	print_debug("I was hited")
	if ui_lab.has_method("hit"):
		ui_lab.hit(damage)
