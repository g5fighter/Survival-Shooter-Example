extends Control

var time_start = 0
var time_now = 0 

func _ready():
	time_start = OS.get_unix_time()

func start():
	visible = true
	Stats.add_stats()
	Settings.save_game('game')
	time_now = OS.get_unix_time()
	var elapsed = time_now - time_start
	var minutes = elapsed / 60
	var seconds = elapsed % 60
	var str_elapsed = "%02d:%02d" % [minutes, seconds]
	$ColorRect/VBoxContainer/Label.set_text("Kills: "+str(Stats.actual_kills)+"\n"+"Time played: " +str_elapsed+"\n"+'Rounds: '+str(Stats.actual_Rounds))
	Stats.reset_actual_stats()

func return_to_title():
	Global.transition_scene("res://Escenas/TitleScreen.tscn")

func restart_level():
	Global.transition_scene("res://Escenas/main.tscn")
