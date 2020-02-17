extends KinematicBody2D

var timer = null
export (int) var typeOfBox = 1
var typeOfWeapon = 0
var typeOfGun = 0
var estaRecogiendo = false
var isPlayer = null
var distance = 300

onready var ui_lab = $ColorRect/Label

onready var ui_color_rect = $ColorRect

onready var colShape = $CollisionPolygon2D

onready var gameScene = get_tree().get_root().get_node("MainScene")


func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(3)
	timer.connect("timeout", self,"on_timeout_complete")
	add_child(timer)
	add_to_group("obstacles")


func make_obstacle():
	gameScene.find_node("Navigation2D")._obstacle(colShape,self)

func on_timeout_complete():
	if(typeOfBox==0):
		gameScene.instantiate_weapon(position)
		queue_free()
	elif(typeOfBox==1):
		gameScene.instantiate_gun(position)
		queue_free()
	elif(typeOfBox==2):
		gameScene.instantiate_charger(position)
		queue_free()

func is_running():
   return timer.get_time_left() > 0

func _process(_delta):
	if((isPlayer!=null)&&gameScene.isPlayerNear(self,distance)):
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
	
func on_player_entered(body):
		isPlayer = body
	
func on_player_exited(_body):
		isPlayer = null
		timer.stop()
