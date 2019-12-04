extends KinematicBody2D
var health = 100
var node
export (int) var speed = 100
var distance2Mouse
export (int) var distance = 0
export (NodePath) var player
onready var player_node = get_node(player)
var playerFree
onready var anim = get_node("anim")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy")
	node = find_node_by_name(get_tree().get_root(), "player")
	playerFree = weakref(node)

func hit(damage):
	#print_debug("Soy el padre")
	health -= damage
	#print_debug(str(health)+str(damage))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(playerFree.get_ref()):
		distance2Mouse = player_node.position.distance_to(node.position)
	#print_debug(distance2Mouse)
		look_at(node.global_position)
		if(distance2Mouse>distance):
			var dir = (node.global_position - global_position).normalized()
			move_and_collide(dir * speed * delta)
		elif(not anim.is_playing()):
			anim.play("brazo golpeando")
#		pass
	if(health<=0): queue_free()


	
func find_node_by_name(root, name):

    if(root.get_name() == name): return root

    for child in root.get_children():
        if(child.get_name() == name):
            return child

        var found = find_node_by_name(child, name)

        if(found): return found

    return null

func _on_Area2D_body_entered(body):
	body.get_damage(20)
