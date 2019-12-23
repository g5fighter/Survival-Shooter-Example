extends KinematicBody2D
var health = 100
var node
#export (int) var speed = 100
export (int) var distance
var playerFree
onready var anim = get_node("anim")

var playerFound = false

func _ready():
	add_to_group("enemy")

func start(pos):
    position = pos

func searchPlayer():
	var players = get_tree().get_nodes_in_group("player")
	for pl in players:
		if(!playerFound):
			node = pl
			playerFree = weakref(node)
			playerFound = true

func hit(damage):
	#print_debug("Soy el padre")
	health -= damage
	#print_debug(str(health)+str(damage))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(node==null&&!playerFound):
		searchPlayer()
	elif(playerFree.get_ref()):
		look_at(node.global_position)
	else:
		playerFound = false
	if(health<=0): queue_free()

func play_anim_golpear():
	if(not anim.is_playing()):
		anim.play("brazo golpeando")

func find_node_by_name(root, name):
    if(root.get_name() == name): return root
    for child in root.get_children():
        if(child.get_name() == name):
            return child
        var found = find_node_by_name(child, name)
        if(found): return found
    return null

func _on_Area2D_body_entered(body):
	if(body.get_name() == "player"):
		body.get_damage(20)
