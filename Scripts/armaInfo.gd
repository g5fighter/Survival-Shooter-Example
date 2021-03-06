extends Node2D

var objectID = 'arma'
# MATRIZ ARMAS
var armas = [[0.3,0.1,2,4],[16,60,7,6],[2,5,7,15],[10,5,60,100],[2,0,2,2],[0,0,0,0]]
	# fil 0: Pistola
	# fil 1: AK
	# fil 2: Sniper
	# col 0: retardo de cada ramas
	# col 1: cantidad de balas
	# col 2: recharge gun delay
	# col 3: gun damage
	# col 4: 0=>Automatica 1=>Rafagas 2=>Semiautomatica
	# col 5: rafaga
	
var gunName = [['gun','ak','sniper','escopeta'],['auto','rafagas','semiauto']]
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
var isPlayer = null

var distance = 300

onready var ui_control = $AnimationReciver/UI
onready var ui_lab = $AnimationReciver/UI/ColorRect/Label
onready var ui_info = $AnimationReciver/UI/Info/Label

onready var gameScene = get_tree().get_root().get_node("MainScene")

onready var images = [$AnimationReciver/Sprites/Gun,$AnimationReciver/Sprites/Aka,$AnimationReciver/Sprites/Sniper,$AnimationReciver/Sprites/Escopeta]

func start(pos: Vector2,num: int):
	position=pos
	configureGun(num)
	drop(pos)
	
# Called when the node enters the scene tree for the first time.
func configureGun(num: int):
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
	
func drop(pos: Vector2):
	taken = false
	position=pos
	$AnimationReciver/Sprites.show()
	$AnimationPlayer.play("drop")
	
func take():
	$AnimationReciver/Sprites.hide()
	ui_control.hide()
	taken = true

func _input(event):
	if (!taken&&(isPlayer!=null)&&event.is_action_pressed("takeObj")&&gameScene.isPlayerNear(self,distance)):
		isPlayer.get_gun(self)

func maxBalas():
	return armas[1][gunID]

func showUI():
	if(!taken&&gameScene.isPlayerNear(self,distance)):
		ui_control.show()
		ui_lab.set_text("Press E to take")
		ui_info.set_text("Info:"+gunNameText+"\n-Type:"+gunTypeText+"\n-Damage:"+str(gunDamage)+"\n-Bullet Delay:"+str(bullet_delay)+"\n-Bullet amount:"+str(bulletAmount))
	else:
		ui_control.hide()
	
func on_player_entered(body):
	isPlayer = body
	showUI()
	
func on_player_exited(_body):
	isPlayer = null
	ui_control.hide()
