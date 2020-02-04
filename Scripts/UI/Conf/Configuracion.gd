extends Control

func _ready():
	$ColorRect/VBoxContainer/touchScreenButtonsCheck.pressed = Global.touch_controls
	$ColorRect/VBoxContainer/gamepadControlCheck.pressed = Global.use_gamepad
	for sl in get_tree().get_nodes_in_group("slider"):
		sl.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(sl.busType))
		sl.connect("value_changed",self,"change_sound",[sl.busType])


func change_sound(db,bus):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus),db)

func _on_touchScreenButtonsCheck_toggled(button_pressed):
	Global.set_touch_controls(button_pressed)
	
func _on_gamepadControlCheck_toggled(button_pressed):
	Global.use_gamepad = button_pressed

func go_back():
	hide()

func show_conf():
	show()

func save_settings():
	Settings.save_game()
