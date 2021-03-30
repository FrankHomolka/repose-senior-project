extends Node2D

var serverIp = "192.168.1.5"

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")

func _on_ButtonHost_pressed():
	var net = NetworkedMultiplayerENet.new();
	net.create_server(6969, 2)
	get_tree().set_network_peer(net)

func _on_ButtonJoin_pressed():
	var net = NetworkedMultiplayerENet.new()
	# change ip for multiple computers
	net.create_client(serverIp, 6969)
	# local - 192.168.1.5  
	# internet - 47.7.49.50
	get_tree().set_network_peer(net)

func _player_connected(id):
	print('player connected')
	Globals.player2id = id
	var game = preload("res://assets/MainLevel.tscn").instance() #
	get_tree().get_root().add_child(game)
	hide()


func _on_IpInput_text_changed(new_text):
	serverIp = new_text
