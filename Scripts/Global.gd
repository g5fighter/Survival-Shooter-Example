extends Node

var touch_controls = false
var use_gamepad = false

var ui_mode = false

signal use_touch
signal delete_touch
signal ui_mode_changed

var nextScene

func _ready():
	add_to_group("persistent_conf")
	if OS.get_name() == "Android":
		touch_controls = true

func _input(event):
	if (event.is_action_pressed('dir_right')||event.is_action_pressed('dir_left')||event.is_action_pressed('dir_down')||event.is_action_pressed('dir_up'))and not use_gamepad:
		use_gamepad = true

func next_scene(scene:String = nextScene):
	get_tree().change_scene(scene)
	
func transition_scene(scene:String):
	nextScene = scene
	get_tree().change_scene("res://Escenas/TransitionScene.tscn")
	
func close_game():
	get_tree().quit()

func set_touch_controls(cond: bool):
	touch_controls = cond
	if cond:
		useTouch()
	else:
		deleteTouch()

func useTouch():
	emit_signal("use_touch")

func deleteTouch():
	emit_signal("delete_touch")
	
func set_ui_mode(cond: bool):
	ui_mode = cond
	emit_signal("ui_mode_changed")


func get_state():
	var save_dict = {
		"master_volume" : AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")),
		"fx_volume" : AudioServer.get_bus_volume_db(AudioServer.get_bus_index("FX")),
		"music_volume" : AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")),
		"touch_controls" : touch_controls,
		"fullscreen": OS.window_fullscreen
	}
	return save_dict

func load_state(data):
	for attribute in data:
		if attribute == 'master_volume':
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),data[attribute])
		elif attribute == 'fx_volume':
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("FX"),data[attribute])
		elif attribute == 'music_volume':
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),data[attribute])
		elif attribute == 'fullscreen':
			OS.window_fullscreen = data[attribute]
		else:
			set(attribute, data[attribute])
