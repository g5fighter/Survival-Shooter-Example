extends CanvasLayer

onready var spriteArray = [$Control2/Armas/Gun,$Control2/Armas/AK,$Control2/Armas/Sniper,$Control2/Armas/Escopeta]
onready var spriteArrayCac = [$Control2/Armas/Cac/Sarten,$Control2/Armas/Cac/Espada,$Control2/Armas/Cac/Tridente,$Control2/Armas/Cac/Palanca,$Control2/Armas/Cac/Extintor]

func _ready():
	Global.connect("use_touch", self,"ui_mobile_use")
	Global.connect("delete_touch", self,"ui_mobile_not_use")

func inicializar_todo():
	$Control/VerticalCont/LifeBar.initialize(100) 
	updateImage(-1,0,5,-1)

func update_health_things(health: int):
	$Control/VerticalCont/LifeBar._on_Interface_health_updated(health)

func update_info_gun(balas,cargadores):
	$Control2/Balas/Label.set_text(str(balas)+"/"+str(cargadores))

func updateImage(num:int,index:int,inventSize:int, typeOfWeapon: int):
	$Control2/Armas/arma.set_text(str(index+1)+"/"+str(inventSize))
	for sprt in spriteArray:
		sprt.hide()
	for sprt in spriteArrayCac:
		sprt.hide()
	if typeOfWeapon!=-1:
		if typeOfWeapon ==0:
			if(num!=-1):
				spriteArray[num].show()
		if typeOfWeapon ==1:
			if(num!=-1):
				spriteArrayCac[num].show()

func mobileUI(condition:bool):
	if condition:
		ui_mobile_use()
	else:
		ui_mobile_not_use()

func ui_mobile_use():
	$Control2.rect_position.y = 160
func ui_mobile_not_use():
	$Control2.rect_position.y = 680
