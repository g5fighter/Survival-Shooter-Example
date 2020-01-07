extends KinematicBody2D
var timer = null
export (float) var wait = 0.1

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
	call_deferred("queue_free")