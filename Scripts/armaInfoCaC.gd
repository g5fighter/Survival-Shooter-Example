extends Node2D

var objectID = 'armacac'
# MATRIZ ARMAS
var armas = [25,50,80,60,90]
	# fil 0: sarten
	# fil 1: espada
	# fil 2: tridente
	# fil 3: palanca
	# fil 4: extintor
	
var weaponName = ['sarten','espada','tridente','palanca','extintor']
var weaponNameText = ""

var weaponDamage = 0

var weaponID = -1

var taken = false
var isPlayer = null

var distance = 300

onready var ui_control = $AnimationReciver/UI
onready var ui_lab = $AnimationReciver/UI/ColorRect/Label
onready var ui_info = $AnimationReciver/UI/Info/Label
onready var node_sprites = $AnimationReciver/Sprites

onready var gameScene = get_tree().get_root().get_node("MainScene")

onready var images = [node_sprites.get_node("Sarten"),node_sprites.get_node("Espada"),node_sprites.get_node("Tridente"),node_sprites.get_node("Palanca"),node_sprites.get_node("Extintor")]

func start(pos:Vector2,num:int):
	position=pos
	configureweapon(num)
	drop(pos)
	
# Called when the node enters the scene tree for the first time.
func configureweapon(num:int):
	weaponID = num
	weaponDamage = armas[weaponID]
	weaponNameText = weaponName[weaponID]
	images[weaponID].show()
	
func drop(pos:Vector2):
	taken = false
	position=pos
	node_sprites.show()
	$AnimationPlayer.play("drop")
	
func take():
	node_sprites.hide()
	ui_control.hide()
	taken = true

func _input(event):
	if (!taken&&(isPlayer!=null)&&event.is_action_pressed("takeObj")&&gameScene.isPlayerNear(self,distance)):
		isPlayer.get_weapon(self)

func showUI():
	if(!taken&&gameScene.isPlayerNear(self,distance)):
		ui_control.show()
		ui_lab.set_text("Press E to take")
		ui_info.set_text("Info:"+weaponNameText+"\n-Damage:"+str(weaponDamage))
	else:
		ui_control.hide()
	

func on_player_entered(body):
	isPlayer = body
	showUI()

	
func on_player_exited(_body):
	isPlayer = null
	ui_control.hide()
