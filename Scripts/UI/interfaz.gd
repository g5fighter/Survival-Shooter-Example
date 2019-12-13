extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func inicializar_todo():
	$Control/VerticalCont/LifeBar.initialize(100) # Replace with function body.

func update_health_things(health):
	$Control/VerticalCont/LifeBar._on_Interface_health_updated(health)

func update_info_gun(balas,cargadores):
	$Control2/NinePatchRect/Label.set_text(str(balas)+"/"+str(cargadores))