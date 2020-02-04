extends CanvasLayer

var item = preload("res://objetos/UI/Inventario/Item.tscn")
var player = null
onready var container = $Fondo/VBoxContainer/GridContainer
# Called when the node enters the scene tree for the first time.
func start(node):
	player = node

func changeVisibility():
	var isVisible = $Fondo.visible
	$Fondo.visible = not isVisible
	if $Fondo.visible:
		update_UI()
	return $Fondo.visible

func button_back():
	$Fondo.visible = false
	Global.set_ui_mode(false)

func update_UI():
	var index = 0
	for n in container.get_children():
		n.queue_free()
	for n in player.inventario:
		if n != null:
			var Item = item.instance()
			container.add_child(Item)
			Item.start(player,n,index,self)
		index+=1
	index = 0
	for n in player.inventarioObjetos:
		if n != null:
			var Item = item.instance()
			container.add_child(Item)
			Item.start(player,n,index,self)
		index +=1
	for n in container.get_children():
		n.put_focus()
		break
