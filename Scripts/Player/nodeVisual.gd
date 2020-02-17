extends Position2D

export (NodePath) var path_bulletspawn
onready var bulletspawn = get_node(path_bulletspawn)

export (NodePath) var path_RotDesv
onready var RotDesv = get_node(path_RotDesv)

func get_bullet_spawn():
	return bulletspawn
	
func get_Rot_Desv():
	return RotDesv
