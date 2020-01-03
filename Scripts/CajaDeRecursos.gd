extends KinematicBody2D

var timer = null
export (int) var typeOfBox = 1
var typeOfGun = 0
var estaRecogiendo = false
var isPlayer = false
var player_node
var distance = 300

onready var ui_lab = $ColorRect/Label

onready var node_parent = $"."

onready var ui_color_rect = $ColorRect

onready var colShape = $CollisionPolygon2D

onready var gameScene = get_tree().get_root().get_node("MainScene")

var playerFound = false

func searchPlayer():
	var players = get_tree().get_nodes_in_group("player")
	for pl in players:
		if(!playerFound):
			player_node = pl
			playerFound = true

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(3)
	timer.connect("timeout", self,"on_timeout_complete")
	add_child(timer)
	add_to_group("obstacles")
	gameScene.find_node("Navigation2D")._obstacle(colShape,node_parent)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_timeout_complete():
	if(typeOfBox==0):
		player_node.get_recursos()
		node_parent.queue_free()
	elif(typeOfBox==1):
		gameScene.instantiate_gun(position)
		node_parent.queue_free()
	elif(typeOfBox==2):
		gameScene.instantiate_charger(position)
		node_parent.queue_free()



func is_running():
   return timer.get_time_left() > 0

# warning-ignore:unused_argument
func _process(delta):
	if(player_node==null&&!playerFound):
		searchPlayer()
	if(isPlayer&&gameScene.isPlayerNear(self,distance)):
		if Input.is_action_pressed('takeObj'):
			estaRecogiendo = true
		else:
			estaRecogiendo = false
			timer.stop()
		if(estaRecogiendo):
			if(!is_running()):
				timer.start()
			ui_color_rect.show()
			ui_lab.set_text(str(int(timer.get_time_left())))
		else:
			ui_color_rect.hide()

func _on_CajaDeRecursos_body_entered():
	isPlayer = true


# warning-ignore:unused_argument
func _on_CajaDeRecursos_body_exited():
	isPlayer = false
	timer.stop()
