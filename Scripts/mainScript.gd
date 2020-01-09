extends Node2D
# objetos que pueden ser instanciados
var Player = preload("res://objetos/player.tscn")
var Enemy = preload("res://objetos/enemy.tscn")
var followedObject = preload("res://objetos/nodeToBeFollowed.tscn")
var Arma = preload("res://objetos/Arma.tscn")
var Cargador = preload("res://objetos/Cargador.tscn")
#temporizadores
var timer = null
var roundTimer = null
#delays
var enemyDelay = 10
var roundDelay = 20

export (bool) var spawnEnemy = true
var rng = RandomNumberGenerator.new()

var spawnedEnemies = 0
var enemiesPerRound = 10
var rondaActual = 1

var player_node

var playerFound = false
var playerFree

func _ready():
	_instantiate_player() 
	configure_timers()
	searchPlayer()
	
func randomSpawn(tipo):
	var pos
	if (tipo == 0):
		var spawnsPlayerNodes = get_tree().get_nodes_in_group("playerSpawn")
		rng.randomize()
		var my_random_number = rng.randi_range(0, spawnsPlayerNodes.size()-1)
		pos = spawnsPlayerNodes[my_random_number].global_position
	elif(tipo == 1):
		var spawnsEnemyNodes = get_tree().get_nodes_in_group("enemySpawn")
		rng.randomize()
		var my_random_number = rng.randi_range(0, spawnsEnemyNodes.size()-1)
		pos = spawnsEnemyNodes[my_random_number].global_position
	return pos
	
func instantiate_gun(pos):
	rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randi_range(0, 2)
	var arma = Arma.instance()
	self.add_child(arma)
	arma.start(pos,my_random_number)

func instantiate_charger(pos):
	rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randi_range(0, 2)
	var cargador = Cargador.instance()
	self.add_child(cargador)
	cargador.start(pos,my_random_number)

func configure_timers():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(enemyDelay)
	timer.connect("timeout", self,"on_timeout_complete")
	add_child(timer)
	roundTimer = Timer.new()
	roundTimer.set_one_shot(true)
	roundTimer.set_wait_time(roundDelay)
	roundTimer.connect("timeout", self,"on_timeout_complete")
	add_child(roundTimer)
	
func on_timeout_complete():
	spawnEnemy = true

func _instantiate_player():
	var player = Player.instance()
	self.add_child(player)
	player.start(randomSpawn(0))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _instantiate_enemies():
	var objectFollowed = followedObject.instance()
	var enemy = Enemy.instance()
	$Navigation2D.add_child(objectFollowed)
	self.add_child(enemy)
	var spawn = randomSpawn(1)
	objectFollowed.start(spawn, enemy, enemy.distance)
	enemy.start(spawn, objectFollowed)
	spawnEnemy = false
#
# warning-ignore:unused_argument
func searchPlayer():
	var players = get_tree().get_nodes_in_group("player")
	for pl in players:
		if(!playerFound):
			player_node = pl
			playerFree = weakref(player_node)
			playerFound = true
func _process(delta):
	if(player_node==null&&!playerFound):
		searchPlayer()
	if(spawnEnemy):
		timer.start()
		_instantiate_enemies()
	if(spawnedEnemies==enemiesPerRound):
		rondaActual+=1
		spawnEnemy = false
		enemiesPerRound+=enemiesPerRound/2
		enemiesPerRound = round(enemiesPerRound)
		spawnedEnemies = 0
		enemyDelay = enemyDelay*0.95
		roundTimer.start()

func restart_level():
	$CanvasLayer/Pause.changeEstate()
	get_tree().reload_current_scene()
	
func close_game():
	get_tree().quit()

func isPlayerNear(n,dist):
	var resultado = false
	if playerFound==true&&playerFree.get_ref():
		if n.global_position.distance_to(player_node.global_position)<dist:
			resultado = true
		else:
			resultado = false
	return resultado