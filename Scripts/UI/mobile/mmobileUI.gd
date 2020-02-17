extends CanvasLayer

func _ready():
	Global.connect("ui_mode_changed",self,"changeVisiblity",[!Global.ui_mode])

func changeVisiblity(visibility):
	$Control.visible = visibility

func get_joystick():
	return $Control/joystick
