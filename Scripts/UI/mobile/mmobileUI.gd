extends CanvasLayer

func changeVisiblity(visibility):
	$Control.visible = visibility

func get_joystick():
	return $Control/joystick
