extends TouchScreenButton

var radious = Vector2(275,275)
var boundary = 360

var ongoing_drag = -1
var return_accel = 20

var threshold = 10

func _ready():
	var pos_difference = (Vector2()-radious) - position
	position+= pos_difference 

func _process(delta):
	if ongoing_drag == -1:
		var pos_difference = (Vector2()-radious) - position
		position+= pos_difference * return_accel * delta

func get_button_pos():
	return position + radious
func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var event_dsi_from_center = (event.position - get_parent().global_position).length()
		
		if event_dsi_from_center <= boundary*global_scale.x or event.get_index()==ongoing_drag:
			set_global_position(event.position - radious * global_scale)
			if get_button_pos().length() > boundary:
				set_position(get_button_pos().normalized() * boundary - radious)
			ongoing_drag = event.get_index()
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1
		
func get_value():
	if get_button_pos().length() > threshold:
		return get_button_pos().normalized()
	return Vector2(0,0)
