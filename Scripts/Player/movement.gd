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

########desviaciones de arma a la hora de apuntar
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
onready var mobileUI = null
onready var joystick = null

# objeto bullet
var Bullet = preload("res://objetos/bestbullet.tscn")
var fire = preload("res://objetos/fuego.tscn")
var mobileUInstatiate = preload("res://objetos/UI/mobile/mmobileUI.tscn")
	
onready var node_Array = [[node_armaUnobulletspawn,node_armaDosbulletspawn,node_armaTresbulletspawn],[node_armaUnoRotDesv,node_armaDosRotDesv,node_armaTresRotDesv],[node_armaUno,node_armaDos,node_armaTres]]

# vector desplacamiento
var velocity = Vector2()
var direction = Vector2()

# temporizadores de arma para disparar, recarga y cooldown
var timer = null
var timerChngGun = null
var timerRchrgGun = null

#retardo: de disparar y recargar
var bullet_delay = 0.1
var recharge_delay = 0.1
var changeGun_delay = 0.1

# bolleanos que permiten el disparo, recarga y cambio de arma, y deteccion para disparo manual
var can_shoot = true
var can_change_gun = true
var can_recharge_gun = true

var pressing_shoot = false
var mobile_input = false

var use_joystick = false
############### INVENTARIO #####################
var inventario = [null,null,null,null,null]
var inventarioObjetos = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null]
var index = 0
var indexObjetos = 0

func _ready():
	add_to_group("player")
	node_ui_manager.inicializar_todo()
	show_gun()
	update_UI_Gun(-1)
	if(inventario[index]!=null):
		config_gun()
	update_UI()
	configure_timers()
	if OS.get_name() == "Android":
		var mob = mobileUInstatiate.instance()
		$UI.add_child(mob)
		mobileUI = mob
		joystick = mobileUI.get_node("joystick")
		mobile_input = true
	if(mobile_input):
		mobileUI.show()
		node_ui_manager.mobileUI()
	$Inventario.start(self)

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
	timerChngGun.set_wait_time(changeGun_delay)
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

func _input(event):
	if (Input.is_action_pressed('dir_right')||Input.is_action_pressed('dir_left')||Input.is_action_pressed('dir_down')||Input.is_action_pressed('dir_up'))and not use_joystick:
		use_joystick = true
	if event.is_action_pressed('change_gun'):
		if(can_change_gun):
			changeGun()
	if event.is_action_pressed('recharge'):
		if (inventario[index]!=null):
			generalRechare()
	if event.is_action_pressed("inventario"):
		$Inventario.changeVisibility()
		can_shoot = not $Inventario/PanelContainer.visible

# funcion que se ejecuta en el process y comprueba un input
func get_input():
	velocity = Vector2()
	direction = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		 velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	if Input.is_action_pressed('run'):
		speed = 600
	else:
		speed = 400

	if(mobile_input):
		velocity = joystick.get_movement() * speed
	else:
		velocity = velocity.normalized() * speed

	if mobile_input:
		if (velocity.x!=0||velocity.y!=0)and not pressing_shoot:
			rotation = velocity.angle()
	elif use_joystick:
		direction.x = Input.get_joy_axis(0,2)
		direction.y = Input.get_joy_axis(0, 3)
		if(direction.x!=0||direction.y!=0):
			rotation = direction.angle()
	else:
		look_at(get_global_mouse_position())
	if Input.is_action_pressed('click'):
		generalShoot()
		pressing_shoot = true
	else:
		pressing_shoot = false

func search_node(node):
	var tmp = 0
	for ob in inventarioObjetos:
		if ob == node:
			return tmp
		tmp+=1

func generalShoot():
	if (inventario[index]!=null):
		if(mobile_input):
			if(search_for_near_enemie()!=null):
				look_at(search_for_near_enemie().global_position)
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
			
func generalRechare():
	var cargadorNode = searchCargador(typeOfGun)
	if(cargadorNode!=null):
		if(can_recharge_gun&&cargadorNode.balasTotales>0):
			rechargeGun(cargadorNode)
		elif(cargadorNode.balasTotales<=0):
			inventarioObjetos[search_node(cargadorNode)]=null
			cargadorNode.call_deferred("queue_free")
			

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
		update_UI_Gun()
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

func hayNullArray(array):
	var hayNull = false
	for el in array:
		if el == null:
			hayNull=true
			break
	return hayNull

func change_gun(ind,type):
	if(type=='arma'):
		inventario[ind].drop(position)
		inventario[ind]=null
	if(type=='cargador'):
		inventarioObjetos[ind].drop(position)
		inventarioObjetos[ind]=null

func get_gun(node):
	if(hayNullArray(inventario)==true):
		var temp = 0
		for arm in inventario:
			if(arm==null):
				inventario[temp]=node
				break
			temp+=1
	elif(hayNullArray(inventario)==false):
		inventario[index].drop(position)
		inventario[index]=node
	if(inventario[index]!=null):
		config_gun()
		show_gun()
	node.take()
	update_UI_Gun()
	update_UI()
	
func get_charger(node):
	indexObjetos = 0
	for n in inventarioObjetos:
		if n == null:
			inventarioObjetos[indexObjetos]=node
			node.take()
			update_UI()
			break
		indexObjetos+=1


func rechargeGun(node):
	can_recharge_gun = false
	recharge_delay = inventario[index].recharge_delay
	timerRchrgGun.start()
	node.recharge(inventario[index].maxBalas())
	inventario[index].recharge()
	update_UI()
	soundManager._play(1)
	
func searchCargador(type):
	var searchedNode = null
	var arrayinv = []
	arrayinv = inventarioObjetos.duplicate()
	arrayinv.invert()
	for i in arrayinv:
		if i!=null:
			if (i.objectID=='cargador'&&i.chargerID==type):
				searchedNode = i
				break
	return searchedNode
	
func show_gun():
	for nodeArma in  node_Array[2]:
		nodeArma.hide()
	if(inventario[index]!=null):
		node_Array[2][typeOfGun].show()

func update_UI():
	if(inventario[index]!=null):
		var cargador = searchCargador(typeOfGun)
		if(cargador!=null):
			$UI.update_info_gun(inventario[index].bulletAmount,cargador.balasTotales)
		else:
			$UI.update_info_gun(inventario[index].bulletAmount,0)
	else:
		$UI.update_info_gun("N","N")

func update_UI_Gun(num = typeOfGun):
	$UI.updateImage(num,index,inventario.size())

func search_for_near_enemie():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var distance
	var my_enemie
	var ind = 0
	for en in enemies:
		if ind == 0:
			distance = global_position.distance_to(en.global_position)
		if global_position.distance_to(en.global_position)<=distance:
			my_enemie = en
		ind+=1
	return my_enemie


# warning-ignore:unused_argument
func _physics_process(delta):
    get_input()
    velocity = move_and_slide(velocity)
    if(health<=0): call_deferred("queue_free")
    ui_lab.set_text("typeOfGun:"+str(typeOfGun)+" bullet_delay:"+str(bullet_delay)+" can_shoot:"+str(can_shoot)+" click:"+str(Input.is_action_pressed('click'))+" pressin shoot"+str(pressing_shoot))