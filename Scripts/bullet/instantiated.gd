extends KinematicBody2D
var timer = null
export (float) var wait = 0.1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.


func start(pos, dir):
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.connect("timeout", self,"on_timeout_complete")
	timer.set_wait_time(wait)
	add_child(timer)
	timer.start()
	rotation = dir
	position = pos

func on_timeout_complete():
	#print_debug("Acabo la espera")
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
