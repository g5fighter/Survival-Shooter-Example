extends Navigation2D

export (int) var speed = 500
var path =[]

export (NodePath) var lab
onready var ui_lab = get_node(lab)

func _physics_process(delta):
	_nueva_posicion($enemy.position,ui_lab.position)
	var distance = speed*delta
	_seguir_ruta(distance)
	if ($enemy.position.distance_to(ui_lab.position) <= $enemy.distance):
		$enemy.play_anim_golpear()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _nueva_posicion(pos_inicial,pos_final):
	path = self.get_simple_path(pos_inicial,pos_final) # Replace with function body.
	path.remove(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _seguir_ruta(distancia):
	var ultima_pos = $enemy.position
	if $enemy.position.distance_to(ui_lab.position) >= $enemy.distance:
		for i in range(path.size()):
			var distancia_al_final = ultima_pos.distance_to(path[0])
			if distancia <= distancia_al_final:
				$enemy.position = ultima_pos.linear_interpolate(path[0],distancia/distancia_al_final)
				break
			elif distancia <= 0.0:
				$enemy.position = path[0]
				break
			distancia -= distancia_al_final
			ultima_pos = path[0]
			path.remove(0)
			
func _obstacle(nodeCollShape, parentNode):
	var new_polygon = Array()
	var col_polygon = nodeCollShape.get_polygon()
	for vector in col_polygon:
		new_polygon.append(vector + parentNode.position)
	var navPolyInstance = $NavigationPolygonInstance
	navPolyInstance.get_navigation_polygon().add_outline(new_polygon)
	navPolyInstance.get_navigation_polygon().make_polygons_from_outlines()
	navPolyInstance.enabled = false
	navPolyInstance.enabled = true
