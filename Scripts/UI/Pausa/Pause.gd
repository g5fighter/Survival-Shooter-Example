extends Control

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("pause"):
		changeEstate()

func changeEstate():
	var new_state = not get_tree().paused
	get_tree().paused = new_state
	visible = new_state
	if visible:
		$ColorRect/VBoxContainer/BackButton.grab_focus()
	
func return_to_title():
	changeEstate()
	Global.transition_scene("res://Escenas/TitleScreen.tscn")
