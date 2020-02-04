extends CanvasLayer

var mob_ui = null

var mobileUInstatiate = preload("res://objetos/UI/mobile/pauseButton.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("use_touch", self,"instantiate_ui_mobile")
	Global.connect("delete_touch", self,"destroy_ui_mobile")
	if mob_ui != null:
		mob_ui.visible = Global.ui_mode
	if Global.touch_controls:
		instantiate_ui_mobile()
	
func instantiate_ui_mobile():
	var mob = mobileUInstatiate.instance()
	add_child(mob)
	mob_ui = mob
func destroy_ui_mobile():
	mob_ui.queue_free()
	mob_ui = null
