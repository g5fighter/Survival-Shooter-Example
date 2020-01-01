extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var spriteArray = [$Control2/Armas/Gun,$Control2/Armas/AK,$Control2/Armas/Sniper]

# Called when the node enters the scene tree for the first time.
func inicializar_todo():
	$Control/VerticalCont/LifeBar.initialize(100) # Replace with function body.
	updateImage(-1,0)

func update_health_things(health):
	$Control/VerticalCont/LifeBar._on_Interface_health_updated(health)

func update_info_gun(balas,cargadores):
	$Control2/Balas/Label.set_text(str(balas)+"/"+str(cargadores))
func updateImage(num,index):
	$Control2/Armas/arma.set_text(str(index+1)+"/5")
	for sprt in spriteArray:
		sprt.hide()
	if(num!=-1):
		spriteArray[num].show()