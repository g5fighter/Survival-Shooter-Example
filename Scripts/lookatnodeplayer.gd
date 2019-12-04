extends Position2D

# Declare member variables here. Examples:
var ui_lab
var wr
# Called when the node enters the scene tree for the first time.
func _ready():
	ui_lab = find_node_by_name(get_tree().get_root(), "player")
	wr = weakref(ui_lab)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	pass
	if(wr.get_ref()):
		look_at(ui_lab.global_position)

func find_node_by_name(root, name):

    if(root.get_name() == name): return root

    for child in root.get_children():
        if(child.get_name() == name):
            return child

        var found = find_node_by_name(child, name)

        if(found): return found

    return null
