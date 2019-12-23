extends Navigation2D

export (int) var speed = 500
var path =[]

var player_node

var playerFound = false
var navPolyInstance
var playerFree
onready var current_navpoly_id = 1

func searchPlayer():
	var players = get_tree().get_nodes_in_group("player")
	for pl in players:
		if(!playerFound):
			player_node = pl
			playerFree = weakref(player_node)
			playerFound = true

func _ready():
	navPolyInstance = $NavigationPolygonInstance 
	searchPlayer()

func _physics_process(delta):
	if(player_node==null&&!playerFound):
		searchPlayer()
	elif(playerFree.get_ref()):
		for enemy in get_tree().get_nodes_in_group("enemy"):
			_nueva_posicion(enemy.position,player_node.position)
			var distance = speed*delta
			_seguir_ruta(distance, enemy)
			if (enemy.position.distance_to(player_node.position) <= enemy.distance):
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
	if enemigo.position.distance_to(player_node.position) >= enemigo.distance:
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
