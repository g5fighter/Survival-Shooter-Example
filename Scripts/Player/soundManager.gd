extends Node2D

# Called when the node enters the scene tree for the first time.
func _play(sound):
	if (sound == 0):
		$sonidoDisparo.play()
	elif (sound == 1):
		$sonidoRecarga.play()
	elif (sound == 2):
		$sonidoSinBalas.play()

