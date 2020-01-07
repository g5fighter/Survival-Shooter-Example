extends Node2D

# warning-ignore:unused_class_variable
var objectID = 'cargador'
var chargerID = -1

var cargador = [16,60,7]
var maxCargadores = 4

var balasTotales = 0

var distance = 300

var taken = false
var isPlayer = false

onready var gameScene = get_tree().get_root().get_node("MainScene")
onready var ui_lab = $AnimationReciver/ColorRect/Label
onready var ui_color_rect = $AnimationReciver/ColorRect
onready var images = [$AnimationReciver/Sprites/GunCharger,$AnimationReciver/Sprites/AkCharger,$AnimationReciver/Sprites/SniperCharger]

func start(pos,num):
	position=pos
	configureCharger(num)
	drop(pos)
	
# Called when the node enters the scene tree for the first time.
func configureCharger(num):
	chargerID = num
	balasTotales = cargador[chargerID]*maxCargadores
	images[chargerID].show()
func recharge(balas):
	if(balasTotales)>0:
		balasTotales-=balas
		
func take():
	$AnimationReciver/Sprites.hide()
	ui_color_rect.hide()
	taken = true
func drop(pos):
	position=pos
	$AnimationReciver/Sprites.show()
	$AnimationPlayer.play("drop")
	taken = false
	
# warning-ignore:unused_argument
func _process(delta):
	if(!taken&&isPlayer&&Input.is_action_just_pressed('takeObj')&&gameScene.isPlayerNear(self,distance)):
		gameScene.player_node.get_charger(self)
	
func showUI():
	if(!taken&&gameScene.isPlayerNear(self,distance)):
		ui_color_rect.show()
		ui_lab.set_text("Press E to take")
		
func _on_arma_body_entered():
	showUI()
	
func _on_arma_body_exited():
	ui_color_rect.hide()

func _on_body_entered(body):
	if body == gameScene.player_node:
		isPlayer = true
		_on_arma_body_entered()
func _on_body_exited(body):
	if body == gameScene.player_node:
		isPlayer = false
		_on_arma_body_exited()