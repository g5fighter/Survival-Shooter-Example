extends KinematicBody2D
var health = 100
var speed = 200
var dstncToNode = 10
var node
var lastPos
export (int) var distance
onready var anim = get_node("anim")

var playerFound = false

func _ready():
	add_to_group("enemy")

func start(pos, followNode):
	position = pos
	node = followNode

func hit(damage):
	health -= damage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(position.distance_to(node.global_position)>dstncToNode):
		var dir = (node.global_position - global_position).normalized()
		move_and_collide(dir * speed * delta)
		rotation = dir.angle()
	if(health<=0):
		node.queue_free()
		queue_free()

func play_anim_golpear():
	if(not anim.is_playing()):
		anim.play("brazo golpeando")

func _on_Area2D_body_entered(body):
	if(body.get_name() == "player"):
		body.get_damage(20)
