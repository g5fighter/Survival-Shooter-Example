extends KinematicBody2D
var health = 100
var node
export (int) var speed = 100
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy")
	node = find_node_by_name(get_tree().get_root(), "player")
	if(node): printt(node, node.get_name())
	
func hit(damage):
	print_debug("Soy el padre")
	health -= damage
	print_debug(str(health)+str(damage))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#	pass
	if(health<=0): queue_free()
	look_at(node.global_position)
	var dir = (node.global_position - global_position).normalized()
	move_and_collide(dir * speed * delta)

	
func find_node_by_name(root, name):

    if(root.get_name() == name): return root

    for child in root.get_children():
        if(child.get_name() == name):
            return child

        var found = find_node_by_name(child, name)

        if(found): return found

    return null