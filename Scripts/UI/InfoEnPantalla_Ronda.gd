extends Control

var animation_player = null

func _ready():
	hide()

func set_message(message : String):
	$Label.set_text(message)
	show()
	animation_player.play('aparecer')
	

func start(node: Node):
	animation_player = node

func _on_animation_finished(anim_name):
	if anim_name == 'aparecer':
		animation_player.play('desparecer')
	if anim_name == 'desparecer':
		hide()
