extends Control

onready var images = $ColorRect/Button/VBoxContainer/Images

var player = null
var nodoAdjunto = null
var UImanager = null
var index = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	update_UI()

func put_focus():
	$ColorRect/Button.grab_focus()

func start(nodoPadre:Node,nodo:Node,num:int,manager):
	player = nodoPadre
	nodoAdjunto = nodo
	index = num
	UImanager = manager
	update_UI()
	
func drop():
	player.change_gun(index,nodoAdjunto.objectID)
	player.show_gun()
	player.update_UI()
	player.update_UI_Gun()
	UImanager.update_UI()

func showMenu():
	var isVisible = $MiniMenu.visible
	$MiniMenu.visible = not isVisible

func update_UI():
	for N in images.get_children():
		N.hide()
	if(nodoAdjunto!=null):
		if nodoAdjunto.objectID == 'arma':
			$ColorRect/Button/VBoxContainer/CenterContainer2/Label.set_text(nodoAdjunto.gunNameText)
			if nodoAdjunto.gunID == 0:
				images.get_node("gun").show()
			elif nodoAdjunto.gunID == 1:
				images.get_node("ak").show()
			elif nodoAdjunto.gunID == 2:
				images.get_node("sniper").show()
		elif nodoAdjunto.objectID == 'cargador':
			$ColorRect/Button/VBoxContainer/CenterContainer2/Label.set_text("Charger")
			if nodoAdjunto.chargerID == 0:
				images.get_node("gunCharger").show()
			elif nodoAdjunto.chargerID == 1:
				images.get_node("akCharger").show()
			elif nodoAdjunto.chargerID == 2:
				images.get_node("sniperCharger").show()
