
extends Node

const SAVE_PATH = "user://game.data"
const SETTINGS_PATH = "user://conf.data"

func _ready():
	load_game(SETTINGS_PATH)
	load_game(SAVE_PATH)



func save_game(type: String):
	# Open the existing save file or create a new one in write mode
	var save_file = File.new()
	if type == 'conf':
		save_file.open(SETTINGS_PATH, File.WRITE)
	if type == 'game':
		save_file.open(SAVE_PATH, File.WRITE)



	# All the nodes to save are in a group called "persistent" (set in the editor, in the node tab of the inspector)
	var save_dict = {}
	var nodes_to_save
	if type == 'conf':
		nodes_to_save = get_tree().get_nodes_in_group("persistent_conf")
	if type == 'game':
		nodes_to_save = get_tree().get_nodes_in_group("persistent_game")
	
	
	for node in nodes_to_save:
	
		save_dict[node.get_path()] = node.get_state()
	
	# {}.to_json() converts the entire dictionary to a JSON string. We store it in the save_file
	save_file.store_line(to_json(save_dict))
	# The change is automatically saved, so we close the file
	save_file.close()


func load_game(path):
	# When we load a file, we must check that it exists before we try to open it or it'll crash the game
	var save_file = File.new()
	if not save_file.file_exists(path):
		print("The save file does not exist.")
		return
	save_file.open(path, File.READ)

	# parse file data - convert the JSON back to a dictionary
	var data = {}
	data = parse_json(save_file.get_as_text())

	# The dict keys on the first level are paths to the nodes
	for node_path in data.keys():
		# We get the node's path from the for loop, so we can use it to retrieve
		# Both the node to load (e.g. Player, Player2) and the node's data with data[node_path]
		var node_data = data[node_path]
		# We find the right node to load node_data into and call its load method
		get_node(node_path).load_state(node_data)
