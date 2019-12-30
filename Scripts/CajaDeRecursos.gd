extends KinematicBody2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer = null
var typeOfBox = 1
var typeOfGun = 0
var estaRecogiendo = false
var isPlayer = false
var bodyEntering

export (NodePath) var lab
onready var ui_lab = get_node(lab)

export (NodePath) var parent
onready var node_parent = get_node(parent)

export (NodePath) var colorRect
onready var ui_color_rect = get_node(colorRect)

export (NodePath) var collisionShape
onready var colShape = get_node(collisionShape)
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(3)
	timer.connect("timeout", self,"on_timeout_complete")
	add_child(timer)
	add_to_group("obstacles")
	get_tree().get_root().get_node("MainScene").find_node("Navigation2D")._obstacle(colShape,node_parent)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_timeout_complete():
	if(typeOfBox==0):
		bodyEntering.get_recursos()
		node_parent.queue_free()
	elif(typeOfBox==1):
		get_tree().get_root().get_node("MainScene").instantiate_gun(position)
		node_parent.queue_free()


func is_running():
   return timer.get_time_left() > 0

# warning-ignore:unused_argument
func _process(delta):
	if(isPlayer):
		if Input.is_action_pressed('takeObj'):
			estaRecogiendo = true
		else:
			estaRecogiendo = false
			timer.stop()
		if(estaRecogiendo):
			if(!is_running()):
				timer.start()
			ui_color_rect.show()
			ui_lab.set_text(str(int(timer.get_time_left())))
		else:
			ui_color_rect.hide()

func _on_CajaDeRecursos_body_entered(body):
	if(body.get_name()=="player"):
		bodyEntering = body
		isPlayer = true


# warning-ignore:unused_argument
func _on_CajaDeRecursos_body_exited(body):
	isPlayer = false
	timer.stop()
