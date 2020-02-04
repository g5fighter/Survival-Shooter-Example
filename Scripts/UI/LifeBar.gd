extends HBoxContainer

var maximum = 100
var current_health = 0
# Called when the node enters the scene tree for the first time.
func initialize(max_value):
	maximum = max_value
	$TextureProgress.max_value = maximum
	
func _on_Interface_health_updated(new_health):
	update_count_text(new_health)
	current_health = new_health
	$TextureProgress.value = current_health
	
func update_count_text(value):
	$TextureProgress/Label.text = str(round(value))
