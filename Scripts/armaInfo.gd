extends Node2D

# MATRIZ ARMAS
var armas = [[0.3,0.1,3],[16,60,7],[4,4,4],[2,5,7],[10,5,60],[2,0,2],[0,0,0]]
	# fil 0: Pistola
	# fil 1: AK
	# fil 2: Sniper
	# col 0: retardo de cada ramas
	# col 1: cantidad de balas
	# col 2: cantidad de cargadores
	# col 3: recharge gun delay
	# col 4: gun damage
	# col 5: 0=>Automatica 1=>Semiautomatico 2=>Manual
	# col 6: rafaga
var bulletAmount = 0
var cargadoresAmount = 0

var gunDamage = 0

#retardo: de disparar y recargar
var bullet_delay = 0
var recharge_delay = 0

var gunID = -1
var shootType = 0

var rafagAmount = 0

var taken = false
var isPlayer = false

var playerFound = false

var  player_node = null

var distance = 300

onready var ui_color_rect = $AnimationReciver/ColorRect
onready var ui_lab = $AnimationReciver/ColorRect/Label

onready var images = [$AnimationReciver/Sprites/Gun,$AnimationReciver/Sprites/Aka,$AnimationReciver/Sprites/Sniper]

func start(pos,num):
	position=pos
	configureGun(num)
	drop(pos)
	
func searchPlayer():
	var players = get_tree().get_nodes_in_group("player")
	for pl in players:
		if(!playerFound):
			player_node = pl
			playerFound = true
# Called when the node enters the scene tree for the first time.
func configureGun(num):
	gunID = num
	bullet_delay = armas[0][gunID]
	bulletAmount = armas[1][gunID]
	cargadoresAmount = armas[2][gunID]
	recharge_delay = armas[3][gunID]
	gunDamage = armas[4][gunID]
	shootType = armas[5][gunID]
	rafagAmount = armas[6][gunID]
	images[gunID].show()
	
func restAmmo():
	bulletAmount-=1
	
func recharge():
	bulletAmount=armas[1][gunID]
	cargadoresAmount-=1
	
func drop(pos):
	position=pos
	$AnimationReciver/Sprites.show()
	$AnimationPlayer.play("drop")
	taken = false
	
func take():
	$AnimationReciver/Sprites.hide()
	ui_color_rect.hide()
	taken = true

# warning-ignore:unused_argument
func _process(delta):
	if(player_node==null&&!playerFound):
		searchPlayer()
	if(!taken&&isPlayer&&Input.is_action_just_pressed('takeObj')&&isPlayerNear()):
		player_node.get_gun(self)
	showUI()

func _on_arma_body_entered():
	isPlayer = true
	showUI()

func isPlayerNear():
	if position.distance_to(player_node.global_position)<distance:
		return true
	else:
		return false

func showUI():
	if(!taken&&isPlayerNear()):
		ui_color_rect.show()
		ui_lab.set_text("Press E to take")

func _on_arma_body_exited():
	isPlayer = false
	ui_color_rect.hide()