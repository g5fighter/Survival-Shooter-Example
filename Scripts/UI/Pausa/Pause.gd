extends Control

func _input(event):
	if Input.is_action_pressed("pause"):
		changeEstate()

func changeEstate():
	var new_state = not get_tree().paused
	get_tree().paused = new_state
	visible = new_state