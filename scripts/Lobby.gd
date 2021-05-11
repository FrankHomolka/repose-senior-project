extends Node2D

var serverIp = "47.7.49.50"#"47.7.49.50"
signal playerHosted
signal playerJoined

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")

func _on_ButtonHost_pressed():
	var net = NetworkedMultiplayerENet.new();
	if(net.create_server(6969, 2) == ERR_ALREADY_IN_USE):
		print('already hosted')
		return
	get_tree().set_network_peer(net)
	emit_signal("playerHosted")

func _on_ButtonJoin_pressed():
	var net = NetworkedMultiplayerENet.new()
	# change ip for multiple computers
	var temp = net.create_client(serverIp, 6969)
	if(temp != 0):
		return
	# local - 192.168.1.5  
	# internet - 47.7.49.50
	get_tree().set_network_peer(net)
	emit_signal("playerJoined")

func _player_connected(id):
	print('player connected')
	Globals.player2id = id
	var game = preload("res://assets/MainLevel.tscn").instance() 
	add_child(game)
	get_parent().get_node("LobbyInterface").queue_free()
	hide()

func _on_IpInput_text_changed(new_text):
	serverIp = new_text

func _on_ButtonSinglePlayer_pressed():
	var net = NetworkedMultiplayerENet.new();
	if(net.create_server(6969, 2) == ERR_ALREADY_IN_USE):
		print('already hosted')
		return
	get_tree().set_network_peer(net)
	emit_signal("playerHosted")
	Globals.player2id = -1
	var game = preload("res://assets/MainLevel.tscn").instance() 
	add_child(game)
	get_parent().get_node("LobbyInterface").queue_free()
