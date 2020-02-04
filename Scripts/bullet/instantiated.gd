extends KinematicBody2D

func start(pos, dir):
	rotation = dir
	position = pos

func on_timeout_complete():
	queue_free()
