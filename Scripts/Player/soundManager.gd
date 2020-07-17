extends Node2D

func _play(sound:int):
	if (sound == 0):
		$sonidoDisparo.play()
	elif (sound == 1):
		$sonidoRecarga.play()
	elif (sound == 2):
		$sonidoSinBalas.play()
