extends Control

var player = null
var nodoAdjunto = null
var UImanager = null
var index = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	update_UI()

func start(nodoPadre,nodo,num,manager):
	player = nodoPadre
	nodoAdjunto = nodo
	index = num
	UImanager = manager
	update_UI()
	
func drop():
	player.change_gun(index,nodoAdjunto.objectID)
	player.show_gun()
	player.update_UI()
	player.update_UI_Gun(-1)
	UImanager.update_UI()

func showMenu():
	var isVisible = $MiniMenu.visible
	$MiniMenu.visible = not isVisible

func update_UI():
	for N in $Images.get_children():
		N.hide()
	if(nodoAdjunto!=null):
		if nodoAdjunto.objectID == 'arma':
			if nodoAdjunto.gunID == 0:
				$Images/gun.show()
			elif nodoAdjunto.gunID == 1:
				$Images/ak.show()
			elif nodoAdjunto.gunID == 2:
				$Images/sniper.show()
		elif nodoAdjunto.objectID == 'cargador':
			if nodoAdjunto.chargerID == 0:
				$Images/gunCharger.show()
			elif nodoAdjunto.chargerID == 1:
				$Images/akCharger.show()
			elif nodoAdjunto.chargerID == 2:
				$Images/sniperCharger.show()