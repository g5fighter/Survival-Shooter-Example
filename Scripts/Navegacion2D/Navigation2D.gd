extends Navigation2D

export (int) var speed = 500
var path =[]

var navPolyInstance

onready var gameScene = get_tree().get_root().get_node("MainScene")

func _ready():
	navPolyInstance = $NavigationPolygonInstance 

func _physics_process(delta):
	if(gameScene.playerFree.get_ref()):
		for enemy in get_tree().get_nodes_in_group("follow"):
			_nueva_posicion(enemy.position,gameScene.player_node.position)
			var distance = speed*delta
			if(enemy.position.distance_to(enemy.followedNode.global_position)<50):
				_seguir_ruta(distance, enemy)
			if (enemy.position.distance_to(gameScene.player_node.position) <= enemy.distance):
				enemy.play_anim_golpear()

# Called when the node enters the scene tree for the first time.
func _nueva_posicion(pos_inicial,pos_final):
	path = self.get_simple_path(pos_inicial,pos_final) # Replace with function body.
	path.remove(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _seguir_ruta(distancia, enemigo):
	var ultima_pos = enemigo.position
	if enemigo.position.distance_to(gameScene.player_node.position) >= enemigo.distance:
# warning-ignore:unused_variable
		for i in range(path.size()):
			var distancia_al_final = ultima_pos.distance_to(path[0])
			if distancia <= distancia_al_final:
				enemigo.position = ultima_pos.linear_interpolate(path[0],distancia/distancia_al_final)
				break
			elif distancia <= 0.0:
				enemigo.position = path[0]
				break
			distancia -= distancia_al_final
			ultima_pos = path[0]
			path.remove(0)
			
func _obstacle(nodeCollShape, parentNode):
	var new_polygon = Array()
	var col_polygon = nodeCollShape.get_polygon()
	for vector in col_polygon:
		new_polygon.append(vector + parentNode.position)
	navPolyInstance = $NavigationPolygonInstance 
	navPolyInstance.get_navigation_polygon().add_outline(new_polygon)
	navPolyInstance.get_navigation_polygon().make_polygons_from_outlines()
	navPolyInstance.enabled = false
	navPolyInstance.enabled = true
	update()

