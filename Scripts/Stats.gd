extends Node

var actual_kills = 0
var actual_timePlayed = 0
var actual_Rounds = 0

var kills = 0
var timePlayed = 0
var maxRounds = 0
var timesPlayed = 0
var timer = null

var lastTime = 0

var time_start = 0
var time_now = 0

func reset_actual_stats():
	actual_kills = 0
	actual_timePlayed = 0
	actual_Rounds = 0

func _ready():
	add_to_group("persistent_game")
	timer = Timer.new()
	timer.set_one_shot(true)
	add_child(timer)

func add_stats():
	add_kill(actual_kills)
	max_round(actual_Rounds)
	add_timesPlayed(1)

func add_kill(kill: int):
	kills+=kill

func max_round(actual_round: int):
	if actual_round>maxRounds:
		maxRounds=actual_round

func add_timesPlayed(times: int):
	timesPlayed+=times

func get_state():
	time_now = OS.get_unix_time()
	var elapsed = time_now - time_start
	timePlayed+=elapsed-lastTime
	lastTime=time_now
	var save_dict = {
		"kills" : kills,
		"timePlayed" : timePlayed,
		"maxRounds" : maxRounds,
		"timesPlayed": timesPlayed
	}
	return save_dict

func load_state(data):
	for attribute in data:
		set(attribute, data[attribute])
