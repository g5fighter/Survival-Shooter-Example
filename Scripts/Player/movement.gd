extends KinematicBody2D

# vida, velocidad, tipo de arma
var health = 100
var speed = 400
var typeOfGun = 0
var shootType = 0
var RafagaAmount = 0

export (NodePath) var lab
onready var ui_lab = get_node(lab)

export (NodePath) var ui_manager
onready var node_ui_manager = get_node(ui_manager)

#nodos de las diferentes armas
export (NodePath) var armaUno
# warning-ignore:unused_class_variable
onready var node_armaUno = get_node(armaUno)
export (NodePath) var armaDos
# warning-ignore:unused_class_variable
onready var node_armaDos = get_node(armaDos)
export (NodePath) var armaTres
# warning-ignore:unused_class_variable
onready var node_armaTres = get_node(armaTres)

#nodos donde se spawnean las diferentes balas
export (NodePath) var armaUnobulletspawn
# warning-ignore:unused_class_variable
onready var node_armaUnobulletspawn = get_node(armaUnobulletspawn)
export (NodePath) var armaDosbulletspawn
# warning-ignore:unused_class_variable
onready var node_armaDosbulletspawn = get_node(armaDosbulletspawn)
export (NodePath) var armaTresbulletspawn
# warning-ignore:unused_class_variable
onready var node_armaTresbulletspawn = get_node(armaTresbulletspawn)

#desviaciones de arma a la hora de apuntar
export (NodePath) var armaUnoRotDesv
# warning-ignore:unused_class_variable
onready var node_armaUnoRotDesv = get_node(armaUnoRotDesv)
export (NodePath) var armaDosRotDesv
# warning-ignore:unused_class_variable
onready var node_armaDosRotDesv = get_node(armaDosRotDesv)
export (NodePath) var armaTresRotDesv
# warning-ignore:unused_class_variable
onready var node_armaTresRotDesv = get_node(armaTresRotDesv)

onready var soundManager = $sonidos

# objeto bullet
var Bullet = preload("res://objetos/bestbullet.tscn")
var fire = preload("res://objetos/fuego.tscn")
	
onready var node_Array = [[node_armaUnobulletspawn,node_armaDosbulletspawn,node_armaTresbulletspawn],[node_armaUnoRotDesv,node_armaDosRotDesv,node_armaTresRotDesv],[node_armaUno,node_armaDos,node_armaTres]]

# vector desplacamiento
var velocity = Vector2()

# temporizadores de arma para disparar, recarga y cooldown
var timer = null
var timerChngGun = null
var timerRchrgGun = null

#retardo: de disparar y recargar
var bullet_delay = 0
var recharge_delay = 0

# bolleanos que permiten el disparo, recarga y cambio de arma, y deteccion para disparo manual
var can_shoot = true
var can_change_gun = true
var can_recharge_gun = true
var pressing_shoot = false

var inventario = [null,null,null,null,null]
var index = 0

func _ready():
	add_to_group("player")
	node_ui_manager.inicializar_todo()
	show_gun()
	update_UI_Gun(-1)
	if(inventario[index]!=null):
		bullet_delay = inventario[index].bullet_delay
		recharge_delay = inventario[index].recharge_delay
	configure_timers()
	update_UI()

func start(pos):
    position = pos

#configurar los temporizadores
func configure_timers():
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

# funciones para cuando terminan los temporizadores #
func on_timeout_complete():
	can_shoot = true

func on_guntimer_complete():
	can_change_gun = true

func on_rechargetimer_complete():
	can_recharge_gun = true

# funcion que se ejecuta en el process y comprueba un input
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
		if (inventario[index]!=null):
			if(can_shoot&&inventario[index].bulletAmount>0):
				if(shootType==0):
					shoot()
				elif(shootType==1&&!pressing_shoot):
					for x in range(0, RafagaAmount):
						shoot()
				elif(shootType==2 && !pressing_shoot):
					shoot()
			elif(inventario[index].bulletAmount==0):
				soundManager._play(2)
		pressing_shoot = true
	else:
		pressing_shoot = false
	if Input.is_action_pressed('change_gun'):
		if(can_change_gun):
			changeGun()
	if Input.is_action_pressed('recharge'):
		if (inventario[index]!=null):
			if(can_recharge_gun&&inventario[index].cargadoresAmount>0):
				rechargeGun()
	velocity = velocity.normalized() * speed

#funcion disparo
func shoot():  
	typeOfGun = inventario[index].gunID  
	inventario[index].restAmmo()
	# variable que instancia la bala
	var bullet = Bullet.instance()
	var fireSprite = fire.instance()
	
	fireSprite.start(node_Array[0][typeOfGun].global_position, rotation + node_Array[1][typeOfGun].rotation)
	bullet.start(node_Array[0][typeOfGun].global_position, rotation + node_Array[1][typeOfGun].rotation, inventario[index].gunDamage)
	
	# añadimos en el arbol de nodos la bala
	get_parent().add_child(bullet)
	get_parent().add_child(fireSprite)
	can_shoot = false
	timer.start()
	update_UI()
	soundManager._play(0)

func changeGun():
	can_change_gun = false
	timerChngGun.start()
	timer.stop()
	can_shoot = true
	index += 1
	if(index>=inventario.size()):
		index = 0
	if(inventario[index]!=null):
		config_gun()
		update_UI_Gun(typeOfGun)
	else:
		update_UI_Gun(-1)
	show_gun()
	update_UI()

	
func config_gun():
		bullet_delay = inventario[index].bullet_delay
		timer.set_wait_time(bullet_delay)
		typeOfGun=inventario[index].gunID
		shootType=inventario[index].shootType
		RafagaAmount=inventario[index].rafagAmount

func get_damage(damage):
	health -= damage
	node_ui_manager.update_health_things(health)
	
func get_recursos():
	print_debug("funciona")
	
func get_gun(node):
	if(inventario[index]==null):
		inventario[index]=node
	else:
		inventario[index].drop(position)
		inventario[index]=node
	config_gun()
	show_gun()
	node.take()
	update_UI_Gun(typeOfGun)
	update_UI()

func rechargeGun():
	can_recharge_gun = false
	recharge_delay = inventario[index].recharge_delay
	timerRchrgGun.start()
	inventario[index].recharge()
	update_UI()
	soundManager._play(1)
	
func show_gun():
	for nodeArma in  node_Array[2]:
		nodeArma.hide()
	if(inventario[index]!=null):
		node_Array[2][typeOfGun].show()

func update_UI():
	if(inventario[index]!=null):
		$UI.update_info_gun(inventario[index].bulletAmount,inventario[index].cargadoresAmount)
	else:
		$UI.update_info_gun("N","N")

func update_UI_Gun(num):
	$UI.updateImage(num,index)

# warning-ignore:unused_argument
func _physics_process(delta):
    get_input()
    velocity = move_and_slide(velocity)
    if(health<=0): queue_free()
    ui_lab.set_text("Arma Actual:"+str(typeOfGun)+" Retardo de arma:"+str(bullet_delay)+" Se puede deisparar:"+str(can_shoot))