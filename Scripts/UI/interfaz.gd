extends CanvasLayer

onready var spriteArray = [$Control2/Armas/Gun,$Control2/Armas/AK,$Control2/Armas/Sniper]

func _ready():
# warning-ignore:return_value_discarded
	Global.connect("use_touch", self,"ui_mobile_use")
# warning-ignore:return_value_discarded
	Global.connect("delete_touch", self,"ui_mobile_not_use")
# Called when the node enters the scene tree for the first time.
func inicializar_todo():
	$Control/VerticalCont/LifeBar.initialize(100) # Replace with function body.
	updateImage(-1,0,5)

func update_health_things(health):
	$Control/VerticalCont/LifeBar._on_Interface_health_updated(health)

func update_info_gun(balas,cargadores):
	$Control2/Balas/Label.set_text(str(balas)+"/"+str(cargadores))

func updateImage(num,index,inventSize):
	$Control2/Armas/arma.set_text(str(index+1)+"/"+str(inventSize))
	for sprt in spriteArray:
		sprt.hide()
	if(num!=-1):
		spriteArray[num].show()


func mobileUI(condition):
	if condition:
		ui_mobile_use()
	else:
		ui_mobile_not_use()

func ui_mobile_use():
	$Control2.rect_position.y = 160
func ui_mobile_not_use():
	$Control2.rect_position.y = 680
