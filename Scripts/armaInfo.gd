extends Node2D

# MATRIZ ARMAS
var armas = [[2,0.1,4],[16,60,30],[4,4,4],[2,5,7],[10,5,40]]
	# col 0: retardo de cada ramas
	# col 1: cantidad de balas
	# col 2: cantidad de cargadores
	# col 3: recharge gun delay
	# col 4: gun damage
var bulletAmount = 0
var cargadoresAmount = 0

var gunDamage = 0

#retardo: de disparar y recargar
var bullet_delay = 0
var recharge_delay = 0

var gunID = -1

var taken = false
var isPlayer = false

var playerFound = false

var  player_node = null

onready var ui_color_rect = $ColorRect
onready var ui_lab = $ColorRect/Label

onready var images = [$Sprites/Gun,$Sprites/Aka,$Sprites/Sniper]

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
	images[gunID].show()
	
func restAmmo():
	bulletAmount-=1
	
func recharge():
	bulletAmount=armas[1][gunID]
	cargadoresAmount-=1
	
func drop(pos):
	position=pos
	$Sprites.show()
	taken = false
	
func take():
	$Sprites.hide()
	ui_color_rect.hide()
	taken = true

# warning-ignore:unused_argument
func _process(delta):
	if(player_node==null&&!playerFound):
		searchPlayer()
	if(!taken):
		if(isPlayer):
			if Input.is_action_pressed('click'):
				player_node.get_gun(self)

func _on_arma_body_entered():
	isPlayer = true
	if(!taken):
		ui_color_rect.show()
		ui_lab.set_text("Click to take")


func _on_arma_body_exited():
	isPlayer = false
	ui_color_rect.hide()