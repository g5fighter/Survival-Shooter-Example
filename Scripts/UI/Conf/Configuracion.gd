extends Control

func _ready():
	hide()
	if Global.touch_controls:
		$ColorRect/VBoxContainer/fullScreenToggle.hide()
	$ColorRect/VBoxContainer/fullScreenToggle.pressed = OS.window_fullscreen
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
	Settings.save_game('conf')
	$ColorRect/PopupPanel.popup()

func toggle_fullscreen(cond:bool):
	OS.window_fullscreen = cond
	
func show_stats():
	var elapsed = int(Stats.timePlayed)
	var hours = elapsed/3600
	var minutes = elapsed / 60 - hours*60
	var seconds = elapsed % 60
	var str_elapsed = "%02d:%02d:%02d" % [hours, minutes, seconds]
	$StatsPanel/VBoxContainer/Label2.set_text("Total kills: "+str(Stats.kills)+"\n"+"Max rounds played: "+str(Stats.maxRounds)+"\n"+"Times played: "+str(Stats.timesPlayed)+"\n"+"Time played: "+str_elapsed)
	$StatsPanel.show()

func hide_stats():
	$StatsPanel.hide()
