extends Node2D

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")

func _on_ButtonHost_pressed():
	var net = NetworkedMultiplayerENet.new();
	net.create_server(6969, 2)
	get_tree().set_network_peer(net)

func _on_ButtonJoin_pressed():
	var net = NetworkedMultiplayerENet.new()
	# change ip for multiple computers
	net.create_client("192.168.1.5", 6969)
	get_tree().set_network_peer(net)

func _player_connected(id):
	Globals.player2id = id
	var game = preload("res://Level.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()
