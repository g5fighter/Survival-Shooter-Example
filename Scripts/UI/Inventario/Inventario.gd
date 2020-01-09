extends CanvasLayer

var item = preload("res://objetos/UI/Inventario/Item.tscn")
var player = null
# Called when the node enters the scene tree for the first time.
func start(node):
	player = node

func changeVisibility():
	var isVisible = $Fondo.visible
	$Fondo.visible = not isVisible
	if $Fondo.visible:
		update_UI()

func update_UI():
	var index = 0
	for n in $Fondo/GridContainer.get_children():
		n.queue_free()
	for n in player.inventario:
		if n != null:
			var Item = item.instance()
			$Fondo/GridContainer.add_child(Item)
			Item.start(player,n,index,self)
		index+=1
	index = 0
	for n in player.inventarioObjetos:
		if n != null:
			var Item = item.instance()
			$Fondo/GridContainer.add_child(Item)
			Item.start(player,n,index,self)
		index +=1
