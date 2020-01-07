extends Sprite

onready var gameScene = get_tree().get_root().get_node("MainScene")

func _input(event):
	if gameScene.player_node.mobile_input:
		if event is InputEventScreenTouch and event.is_pressed() and event.position.x<(ProjectSettings.get("display/window/size/width")/2):
			set_global_position(event.position)
		
func get_movement():
	return $joystick_button.get_value()