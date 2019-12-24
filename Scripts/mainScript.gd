extends Node2D
var Player = preload("res://objetos/player.tscn")
var Enemy = preload("res://objetos/enemy.tscn")
var followedObject = preload("res://objetos/nodeToBeFollowed.tscn")
var timer = null
var enemyDelay = 3
var spawnEnemy = true
var rng = RandomNumberGenerator.new()
var numberOfSpawnedEnem = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_instantiate_player() # Replace with function body.
	configure_timers()
	
func randomSpawn(tipo):
	var pos
	if (tipo == 0):
		var spawnsPlayerNodes = get_tree().get_nodes_in_group("playerSpawn")
		rng.randomize()
		var my_random_number = int(round(rng.randf_range(0, spawnsPlayerNodes.size()-1)))
		pos = spawnsPlayerNodes[my_random_number].global_position
	elif(tipo == 1):
		var spawnsEnemyNodes = get_tree().get_nodes_in_group("enemySpawn")
		rng.randomize()
		var my_random_number = int(round(rng.randf_range(0, spawnsEnemyNodes.size()-1)))
		pos = spawnsEnemyNodes[my_random_number].global_position
	return pos

func configure_timers():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(enemyDelay)
	timer.connect("timeout", self,"on_timeout_complete")
	add_child(timer)
	
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
func _process(delta):
	if(spawnEnemy):
		timer.start()
		_instantiate_enemies()
