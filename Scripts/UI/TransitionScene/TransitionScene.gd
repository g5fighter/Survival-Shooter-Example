extends Control

func _ready():
	$AnimationPlayer.play("Transicion")



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Transicion":
		Global.next_scene()
