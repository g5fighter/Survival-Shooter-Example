extends Control

var scene_path_to_load

func _ready():
	$Menu/CenterRow/Buttons/NewGameButton.grab_focus()
	for button in $Menu/CenterRow/Buttons.get_children():
		button.connect("pressed", self, "_on_button_pressed", [button.scene_to_load])
		button.get_node("TouchScreenButton").connect("pressed", self, "_on_button_pressed", [button.scene_to_load])

func _on_button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$FAdeIn.show()
	$FAdeIn.fade_in()

func _on_FAdeIn_fade_finished():
	get_tree().change_scene(scene_path_to_load)
