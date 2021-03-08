extends Node2D

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")

func _on_ButtonHost_pressed():
	var net = NetworkedMultiplayerENet.new();
	net.create_server(7777, 2)
	get_tree().set_network_peer(net)
	var upnp = UPNP.new()
	upnp.discover(2000, 2, "InternetGatewayDevice")
	upnp.add_port_mapping(7777)

func _on_ButtonJoin_pressed():
	var net = NetworkedMultiplayerENet.new()
	# change ip for multiple computers
	net.create_client("192.168.1.5", 7777) #192.168.1.5
	get_tree().set_network_peer(net)

func _player_connected(id):
	print('player connected')
	Globals.player2id = id
	var game = preload("res://assets/MainLevel.tscn").instance() #
	get_tree().get_root().add_child(game)
	hide()
