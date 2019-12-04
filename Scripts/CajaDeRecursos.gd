extends KinematicBody2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer = null
export (int) var typeOfBox = 0
var estaRecogiendo = false
var isPlayer = false
var bodyEntering

export (NodePath) var lab
onready var ui_lab = get_node(lab)

export (NodePath) var parent
onready var node_parent = get_node(parent)

export (NodePath) var colorRect
onready var ui_color_rect = get_node(colorRect)
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(3)
	timer.connect("timeout", self,"on_timeout_complete")
	add_child(timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_timeout_complete():
	bodyEntering.get_recursos()
	node_parent.queue_free()


func is_running():
   return timer.get_time_left() > 0

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


func _on_CajaDeRecursos_body_exited(body):
	isPlayer = false
	timer.stop()
