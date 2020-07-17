extends KinematicBody2D
var health = 100
var speed = 200
var damage = 20
var dstncToNode = 3
var golpeado = false
var node
var right = false
var left = false
export (int) var distance
onready var anim = get_node("anim")

var typeOfEnemy = -1

var damageList = [20,70,60,50,30,80,60]
var healthList = [100,150,200,60,55,20,70]
var speedList = [200,150,300,400,500,250,100]
#######
# Fila 0: Ornitorrinco
# Fila 1: Oso
# Fila 2: Perro
# Fila 3: Vaca
# Fila 4: Ardilla
# Fila 5: Jabali
# Fila 6: Rata

func _ready():
	add_to_group("enemy")

func start(pos:Vector2, followNode:Node, typeOfEnem:int):
	position = pos
	node = followNode
	typeOfEnemy = typeOfEnem
	health = healthList[typeOfEnemy]
	speed=speedList[typeOfEnemy]
	damage=damageList[typeOfEnemy]

func hit(dmg:int):
	health -= dmg
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
			body.get_damage(damage)
			golpeado = true
