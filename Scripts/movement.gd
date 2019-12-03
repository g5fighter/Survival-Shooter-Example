extends KinematicBody2D

# COSAS POR HACER
	# PONER COOLDOWN AL ARMA


# velocidad
export (int) var health = 100
export (int) var speed = 600
export (int) var typeOfGun = 0

export (NodePath) var lab
onready var ui_lab = get_node(lab)

export (NodePath) var armaUno
onready var node_armaUno = get_node(armaUno)
export (NodePath) var armaDos
onready var node_armaDos = get_node(armaDos)
export (NodePath) var armaTres
onready var node_armaTres = get_node(armaTres)

export (NodePath) var armaUnobulletspawn
onready var node_armaUnobulletspawn = get_node(armaUnobulletspawn)
export (NodePath) var armaDosbulletspawn
onready var node_armaDosbulletspawn = get_node(armaDosbulletspawn)
export (NodePath) var armaTresbulletspawn
onready var node_armaTresbulletspawn = get_node(armaTresbulletspawn)

export (NodePath) var armaUnoRotDesv
onready var node_armaUnoRotDesv = get_node(armaUnoRotDesv)
export (NodePath) var armaDosRotDesv
onready var node_armaDosRotDesv = get_node(armaDosRotDesv)
export (NodePath) var armaTresRotDesv
onready var node_armaTresRotDesv = get_node(armaTresRotDesv)

# objeto bullet
var Bullet = preload("res://objetos/bestbullet.tscn")
var fire = preload("res://objetos/fuego.tscn")
# MATRIZ ARMAS
var armas = [[2,0.1,4],[16,60,30],[16,60,30],[4,4,4],[4,4,4],[2,5,7],[10,5,40]]
	# col 0: retardo de cada ramas
	#col 1: cantidad de balas
	#col 2: cantidad de balas actuales
	#col 3: cantidad de cargadores
	#col 4: cargadores actuales
	#col 5:recharge gun delay
	#col 6: gun damage

# vector desplacamiento
var velocity = Vector2()

var timer = null
var timerChngGun = null
var timerRchrgGun = null

var bullet_delay = 2
var recharge_delay = 2

var can_shoot = true
var can_change_gun = true
var can_recharge_gun = true

func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(bullet_delay)
	timer.connect("timeout", self,"on_timeout_complete")
	add_child(timer)
	timerChngGun = Timer.new()
	timerChngGun.set_one_shot(true)
	timerChngGun.set_wait_time(0.1)
	timerChngGun.connect("timeout", self,"on_guntimer_complete")
	add_child(timerChngGun)
	timerRchrgGun = Timer.new()
	timerRchrgGun.set_one_shot(true)
	timerRchrgGun.set_wait_time(recharge_delay)
	timerRchrgGun.connect("timeout", self,"on_rechargetimer_complete")
	add_child(timerRchrgGun)
	add_to_group("player")

func on_timeout_complete():
	can_shoot = true

func on_guntimer_complete():
	can_change_gun = true

func on_rechargetimer_complete():
	can_recharge_gun = true

# funcion que se ejecyta con un input
func get_input():
	
	# mirar al raton
	look_at(get_global_mouse_position())
	velocity = Vector2()
	if Input.is_action_pressed('right'):
        velocity.x += 1
	if Input.is_action_pressed('left'):
        velocity.x -= 1
	if Input.is_action_pressed('down'):
        velocity.y += 1
	if Input.is_action_pressed('up'):
        velocity.y -= 1
	if Input.is_action_pressed('click'):
        # llamar funcion disparo
		if(can_shoot&&armas[2][typeOfGun]>0):
            shoot()
	if Input.is_action_pressed('change_gun'):
		if(can_change_gun):
			changeGun()
	if Input.is_action_pressed('recharge'):
		if(can_recharge_gun&&armas[4][typeOfGun]):
			rechargeGun()
	velocity = velocity.normalized() * speed

#funcion disparo
func shoot():    
	armas[2][typeOfGun]-=1
	# variable que instancia la bala
	var bullet = Bullet.instance()
	var fireSprite = fire.instance()
	# la bala comienza a moverse desde el punto bullet_spawn
	if(typeOfGun==0):
		fireSprite.start(node_armaUnobulletspawn.global_position, rotation + node_armaUnoRotDesv.rotation)
		bullet.start(node_armaUnobulletspawn.global_position, rotation + node_armaUnoRotDesv.rotation, armas[6][typeOfGun])
	if(typeOfGun==1):
		fireSprite.start(node_armaDosbulletspawn.global_position, rotation + node_armaDosRotDesv.rotation)
		bullet.start(node_armaDosbulletspawn.global_position, rotation + node_armaDosRotDesv.rotation, armas[6][typeOfGun])
	if(typeOfGun==2):
		fireSprite.start(node_armaTresbulletspawn.global_position, rotation + node_armaTresRotDesv.rotation)
		bullet.start(node_armaTresbulletspawn.global_position, rotation + node_armaTresRotDesv.rotation, armas[6][typeOfGun])
	# añadimos en el arbol de nodos la bala
	get_parent().add_child(bullet)
	get_parent().add_child(fireSprite)
	can_shoot = false
	timer.start()

func changeGun():
	can_change_gun = false
	timerChngGun.start()
	timer.stop()
	can_shoot = true
	typeOfGun += 1
	if(typeOfGun>2):
		typeOfGun = 0
	bullet_delay = armas[0][typeOfGun]
	timer.set_wait_time(bullet_delay)    # A for loop for column entries 
	node_armaUno.hide()
	node_armaDos.hide()
	node_armaTres.hide()
	if(typeOfGun==0):
		node_armaUno.show()
	if(typeOfGun==1):
		node_armaDos.show()
	if(typeOfGun==2):
		node_armaTres.show()


func rechargeGun():
	can_recharge_gun = false
	recharge_delay = armas[5][typeOfGun]
	timerRchrgGun.start()
	armas[2][typeOfGun] = armas[1][typeOfGun]
	armas[4][typeOfGun] -= 1

func _physics_process(delta):
    get_input()
    velocity = move_and_slide(velocity)
    if(health<=0): queue_free()
    ui_lab.set_text("Arma Actual:"+str(typeOfGun)+" Retardo de arma:"+str(bullet_delay)+" Balas restantes:"+str(armas[2][typeOfGun])+" Cargadores restantes:"+str(armas[4][typeOfGun])+" Se puede deisparar:"+str(can_shoot))