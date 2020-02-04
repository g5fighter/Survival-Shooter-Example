extends Control

var scene_path_to_load

func _ready():
	$Menu/CenterRow/Buttons/NewGameButton.grab_focus()
	for button in $Menu/CenterRow/Buttons.get_children():
		if button is TitleScreenButton:
			button.connect("pressed", self, "_on_button_pressed", [button.scene_to_load])

func _on_button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	Global.transition_scene(scene_path_to_load)
