extends KinematicBody2D
var health = 100
var speed = 200
var dstncToNode = 3
var golpeado = false
var node
var right = false
var left = false
export (int) var distance
onready var anim = get_node("anim")

func _ready():
	add_to_group("enemy")

func start(pos, followNode):
	position = pos
	node = followNode

func hit(damage):
	health -= damage
	if(health<=0):
		Stats.actual_kills+=1
		node.queue_free()
		queue_free()

func _physics_process(delta):
	if(position.distance_to(node.global_position)>dstncToNode):
		var dir = (node.global_position - global_position).normalized()
		$Line2D.global_rotation = dir.angle()
		move_and_collide(dir * speed * delta)
		rotation = dir.angle()


func play_anim_golpear():
	if(not anim.is_playing()):
		golpeado = false
		anim.play("brazo golpeando")

func _on_Area2D_body_entered(body):
	if(body.get_name() == "player"):
		if not golpeado:
			body.get_damage(20)
			golpeado = true
