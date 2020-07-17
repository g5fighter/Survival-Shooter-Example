extends KinematicBody2D

# vida, velocidad, tipo de arma
var health = 100
var speed = 400

var typeOfWeapon = 0

var typeOfGun = 0
var shootType = 0
var RafagaAmount = 0

onready var ui_lab = get_node("UI/Control/Label")

onready var node_ui_manager = get_node("UI")

onready var animation_player = $AnimationPlayer

onready var node_Array = [$Armas/Guns/pistol,$Armas/Guns/Aka,$Armas/Guns/sniper,$Armas/Guns/escopeta]
onready var Cac_Array = [$Armas/ArmasCaCNodo/Sarten,$Armas/ArmasCaCNodo/Espada,$Armas/ArmasCaCNodo/Tridente,$Armas/ArmasCaCNodo/Palanca]

onready var soundManager = $sonidos
onready var mobileUI = null
onready var joystick = null

# objeto bullet
var Bullet = preload("res://objetos/bestbullet.tscn")
var fire = preload("res://objetos/fuego.tscn")
var mobileUInstatiate = preload("res://objetos/UI/mobile/mmobileUI.tscn")


# vector desplacamiento
var velocity = Vector2()
var direction = Vector2()
var last_rot = Vector2()

# temporizadores de arma para disparar, recarga y cooldown
var timer = null
var timerChngGun = null
var timerRchrgGun = null
var healthTimer = null
var recuperarTimer = null

#retardo: de disparar y recargar
var bullet_delay = 0.1
var recharge_delay = 0.1
var changeGun_delay = 0.1

var healthDelay = 15
var recuperarDelay = 1

# bolleanos que permiten el disparo, recarga y cambio de arma, y deteccion para disparo manual
var can_shoot = true
var can_change_gun = true
var can_recharge_gun = true

var pressing_shoot = false
############### INVENTARIO #####################
var inventario = [null,null,null,null,null]
var inventarioObjetos = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null]
var index = 0
var indexObjetos = 0

func _ready():
	Global.connect("use_touch", self,"instantiate_ui_mobile")
	Global.connect("delete_touch", self,"destroy_ui_mobile")
	add_to_group("player")
	node_ui_manager.inicializar_todo()
	show_gun()
	show_weapon()
	config_weapon()
	update_UI()
	configure_timers()
	if Global.touch_controls:
		instantiate_ui_mobile()
	node_ui_manager.mobileUI(Global.touch_controls)
	$Inventario.start(self)

func start(pos: Vector2):
	position = pos

func instantiate_ui_mobile():
	var mob = mobileUInstatiate.instance()
	$UI.add_child(mob)
	mobileUI = mob
	joystick = mobileUI.get_joystick()
	
func destroy_ui_mobile():
	mobileUI.queue_free()
	mobileUI = null
	joystick = null

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
	
	healthTimer = Timer.new()
	healthTimer.set_one_shot(true)
	healthTimer.set_wait_time(healthDelay)
	healthTimer.connect("timeout", self,"on_healthtimer_complete")
	add_child(healthTimer)
	
	recuperarTimer = Timer.new()
	recuperarTimer.set_one_shot(true)
	recuperarTimer.set_wait_time(recuperarDelay)
	recuperarTimer.connect("timeout", self,"on_recuperarTimer_complete")
	add_child(recuperarTimer)

# funciones para cuando terminan los temporizadores #
func on_timeout_complete():
	can_shoot = true

func on_guntimer_complete():
	can_change_gun = true

func on_rechargetimer_complete():
	can_recharge_gun = true
	
func on_healthtimer_complete():
	recuperarTimer.start()

func on_recuperarTimer_complete():
	health+=5
	if health>100:
		health = 100
	node_ui_manager.update_health_things(health)
	if health<100:
		recuperarTimer.start()

func _input(event):
	if event.is_action_pressed('change_gun'):
		if(can_change_gun):
			changeGun()
	if event.is_action_pressed('recharge'):
		if (inventario[index]!=null):
			generalRecharge()
	if event.is_action_pressed("inventario"):
		Global.set_ui_mode($Inventario.changeVisibility())
	if event.is_action_pressed("arma1"):
		if(can_change_gun):
			changeSpecificGun(0)
	if event.is_action_pressed("arma2"):
		if(can_change_gun):
			changeSpecificGun(1)
	if event.is_action_pressed("arma3"):
		if(can_change_gun):
			changeSpecificGun(2)
	if event.is_action_pressed("arma4"):
		if(can_change_gun):
			changeSpecificGun(3)
	if event.is_action_pressed("arma5"):
		if(can_change_gun):
			changeSpecificGun(4)

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

	if(Global.touch_controls):
		if !Global.ui_mode:
			velocity = joystick.get_movement() * speed
	else:
		velocity = velocity.normalized() * speed

	if Global.touch_controls:
		if (velocity.x!=0||velocity.y!=0)and not pressing_shoot:
			rotation = velocity.angle()
	elif Global.use_gamepad:
		direction.x = Input.get_joy_axis(0,2)
		direction.y = Input.get_joy_axis(0, 3)
		if(direction.x!=0||direction.y!=0):
			rotation = direction.angle()
	else:
		look_at(get_global_mouse_position())
	if !Global.ui_mode:
		if Input.is_action_pressed('click')&&!Global.touch_controls:
			generalShoot()
			pressing_shoot = true
		elif Input.is_action_pressed('click_mob'):
			generalShoot()
			pressing_shoot = true
		else:
			pressing_shoot = false

func search_node(node: Node):
	var tmp = 0
	for ob in inventarioObjetos:
		if ob == node:
			return tmp
		tmp+=1

func generalShoot():
	if (inventario[index]!=null):
		if(typeOfWeapon==0):
			if(Global.touch_controls):
				if(search_for_near_enemie()!=null):
					look_at(search_for_near_enemie().global_position)
					last_rot = global_rotation
			if(can_shoot&&inventario[index].bulletAmount>0):
				if(shootType==0):
					shoot()
				elif(shootType==1&&!pressing_shoot):
					for _x in range(0, RafagaAmount):
						shoot()
				elif(shootType==2 && !pressing_shoot):
					shoot()
			elif(inventario[index].bulletAmount==0):
				soundManager._play(2)
		elif(typeOfWeapon==1):
			if !animation_player.is_playing():
				if inventario[index].weaponID == 0:
					animation_player.play("ataqueSarten")
				if inventario[index].weaponID == 1:
					animation_player.play("ataqueEspada")
				if inventario[index].weaponID == 2:
					animation_player.play("ataqueTridente")
				if inventario[index].weaponID == 3:
					animation_player.play("ataquePalanca")
		
func generalRecharge():
	var cargadorNode = searchCargador()
	if(cargadorNode!=null):
		if(can_recharge_gun&&cargadorNode.balasTotales>0):
			rechargeGun(cargadorNode)
			if(cargadorNode.balasTotales<=0):
				inventarioObjetos[search_node(cargadorNode)]=null
				cargadorNode.queue_free()
		update_UI()

#funcion disparo
func shoot():  
	inventario[index].restAmmo()
	
	# variable que instancia la bala
	var bullet = Bullet.instance()
	var fireSprite = fire.instance()
	
	# starteamos los objetos
	fireSprite.start(node_Array[typeOfGun].get_bullet_spawn().global_position, node_Array[typeOfGun].get_Rot_Desv().global_rotation)
	bullet.start(node_Array[typeOfGun].get_bullet_spawn().global_position, node_Array[typeOfGun].get_Rot_Desv().global_rotation, inventario[index].gunDamage)
	
	# añadimos en el arbol de nodos la bala y fuego
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
	config_weapon()
	show_gun()
	show_weapon()
	update_UI()

func changeSpecificGun(ind: int):
	can_change_gun = false
	timerChngGun.start()
	timer.stop()
	can_shoot = true
	index = ind
	config_weapon()
	show_gun()
	show_weapon()
	update_UI()
	
func config_gun():
	typeOfWeapon = 0
	bullet_delay = inventario[index].bullet_delay
	timer.set_wait_time(bullet_delay)
	typeOfGun=inventario[index].gunID
	shootType=inventario[index].shootType
	RafagaAmount=inventario[index].rafagAmount

func config_weapon():
	if(inventario[index]!=null):
		if inventario[index].objectID == 'arma':
			config_gun()
		if inventario[index].objectID == 'armacac':
			typeOfWeapon = 1

func get_damage(damage: int):
	health -= damage
	node_ui_manager.update_health_things(health)
	if(health<=0): queue_free()
	healthTimer.start()
	recuperarTimer.stop()

func hayNullArray(array: Array):
	var hayNull = false
	for el in array:
		if el == null:
			hayNull=true
			break
	return hayNull

func change_gun(ind: int,obj: String):
	if(obj=='arma'):
		inventario[ind].drop(position)
		inventario[ind]=null
	if(obj=='cargador'):
		inventarioObjetos[ind].drop(position)
		inventarioObjetos[ind]=null

func get_weapon(node: Node):
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
	config_weapon()
	show_weapon()
	node.take()
	update_UI()

func get_gun(node: Node):
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
	config_weapon()
	show_gun()
	node.take()
	update_UI()
	
func get_charger(node: Node):
	indexObjetos = 0
	for n in inventarioObjetos:
		if n == null:
			inventarioObjetos[indexObjetos]=node
			node.take()
			update_UI()
			break
		indexObjetos+=1


func rechargeGun(node: Node):
	can_recharge_gun = false
	recharge_delay = inventario[index].recharge_delay
	timerRchrgGun.start()
	node.recharge(inventario[index].maxBalas())
	inventario[index].recharge()
	soundManager._play(1)
	
func searchCargador(type: int = typeOfGun):
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
	for nodeArma in  node_Array:
		nodeArma.hide()
	if(inventario[index]!=null&&typeOfWeapon==0):
		node_Array[typeOfGun].show()

func show_weapon():
	for nodeWeapon in Cac_Array:
		nodeWeapon.hide()
	if(inventario[index]!=null&&typeOfWeapon==1):
		Cac_Array[inventario[index].weaponID].show()

func update_UI():
	if(inventario[index]!=null):
		if(typeOfWeapon==0):
			var cargador = searchCargador()
			if(cargador!=null):
				$UI.update_info_gun(inventario[index].bulletAmount,cargador.balasTotales)
			else:
				$UI.update_info_gun(inventario[index].bulletAmount,0)
		elif(typeOfWeapon==1):
			$UI.update_info_gun("N","N")
	else:
		$UI.update_info_gun("N","N")
	update_UI_Weapon()
		
func update_UI_Weapon(num: int = typeOfGun):
	if inventario[index]==null:
		$UI.updateImage(-1,index,inventario.size(),-1)
	else:
		if typeOfWeapon == 0:
			$UI.updateImage(num,index,inventario.size(),typeOfWeapon)
		if(typeOfWeapon==1):
			$UI.updateImage(inventario[index].weaponID,index,inventario.size(),typeOfWeapon)

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

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
	ui_lab.set_text("typeOfGun:"+str(typeOfGun)+" bullet_delay:"+str(bullet_delay)+" can_shoot:"+str(can_shoot))


func _on_enemy_entered(body):
	if body.has_method("hit"):
		body.hit(inventario[index].weaponDamage)
