extends Node2D

var objectID = 'arma'
# MATRIZ ARMAS
var armas = [[0.3,0.1,2],[16,60,7],[2,5,7],[10,5,60],[2,0,2],[0,0,0]]
	# fil 0: Pistola
	# fil 1: AK
	# fil 2: Sniper
	# col 0: retardo de cada ramas
	# col 1: cantidad de balas
	# col 2: recharge gun delay
	# col 3: gun damage
	# col 4: 0=>Automatica 1=>Rafagas 2=>Semiautomatica
	# col 5: rafaga
	
var gunName = [['gun','ak','sniper'],['auto','rafagas','semiauto']]
var gunNameText = ""
var gunTypeText = ""
var bulletAmount = 0

var gunDamage = 0

#retardo: de disparar y recargar
var bullet_delay = 0
var recharge_delay = 0

var gunID = -1
var shootType = 0

var rafagAmount = 0

var taken = false
var isPlayer = false

var distance = 300

onready var ui_control = $AnimationReciver/UI
onready var ui_lab = $AnimationReciver/UI/ColorRect/Label
onready var ui_info = $AnimationReciver/UI/Info/Label

onready var gameScene = get_tree().get_root().get_node("MainScene")

onready var images = [$AnimationReciver/Sprites/Gun,$AnimationReciver/Sprites/Aka,$AnimationReciver/Sprites/Sniper]

func start(pos,num):
	position=pos
	configureGun(num)
	drop(pos)
	
# Called when the node enters the scene tree for the first time.
func configureGun(num):
	gunID = num
	bullet_delay = armas[0][gunID]
	bulletAmount = armas[1][gunID]
	recharge_delay = armas[2][gunID]
	gunDamage = armas[3][gunID]
	shootType = armas[4][gunID]
	rafagAmount = armas[5][gunID]
	gunNameText = gunName[0][gunID]
	gunTypeText = gunName[1][shootType]
	images[gunID].show()
	
func restAmmo():
	bulletAmount-=1
	
func recharge():
	bulletAmount=armas[1][gunID]
	
func drop(pos):
	taken = false
	position=pos
	$AnimationReciver/Sprites.show()
	$AnimationPlayer.play("drop")
	
func take():
	$AnimationReciver/Sprites.hide()
	ui_control.hide()
	taken = true

func _input(event):
	if (!taken&&isPlayer&&event.is_action_pressed("takeObj")&&gameScene.isPlayerNear(self,distance)):
		gameScene.player_node.get_gun(self)
# warning-ignore:unused_argument
func _process(delta):
	showUI()


func maxBalas():
	return armas[1][gunID]

func showUI():
	if(!taken&&gameScene.isPlayerNear(self,distance)):
		ui_control.show()
		ui_lab.set_text("Press E to take")
		ui_info.set_text("Info:"+gunNameText+"\n-Type:"+gunTypeText+"\n-Damage:"+str(gunDamage)+"\n-Bullet Delay:"+str(bullet_delay)+"\n-Bullet amount:"+str(bulletAmount))
	else:
		ui_control.hide()
	
func _on_arma_body_entered():
	showUI()

func _on_arma_body_exited():
	ui_control.hide()

func on_player_entered(body):
		isPlayer = true
		_on_arma_body_entered()
	
func on_player_exited(body):
		isPlayer = false
		_on_arma_body_exited()
