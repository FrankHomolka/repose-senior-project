extends Area

signal greenCanisterPlaced
signal blueCanisterPlaced
var numBlueCanisters = 0
var numBlueCanistersPlaced = 0
var canPlace = false
var placed = false
export var markerSound = 'test' setget marker_sound_set, marker_sound_get

func _ready():
	visible = false

func marker_sound_set(new_value):
	markerSound = new_value

func marker_sound_get():
	return markerSound

remote func _placed_canister():
	if !placed:
		placed = true
		$OmniLight.visible = false
		$MeshInstance.visible = false
		emit_signal("greenCanisterPlaced", markerSound)
		numBlueCanistersPlaced += 1
		match(markerSound):
			'Bass':
				var tree = preload('res://assets/Tree1.tscn').instance()
				add_child(tree)
			'Melody':
				var tree = preload('res://assets/Tree2.tscn').instance()
				add_child(tree)
			'Percussion':
				var tree = preload('res://assets/Tree3.tscn').instance()
				add_child(tree)
			'Harmony':
				var tree = preload('res://assets/Tree4.tscn').instance()
				add_child(tree)
			'Other':
				var tree = preload('res://assets/Tree5.tscn').instance()
				add_child(tree)

remote func _placed_blue_canister():
	print('client side blue canister placed')
	emit_signal("blueCanisterPlaced", markerSound)
	set_scale(scale * 1.2)

func _process(delta):
	if numBlueCanisters > 0 && Input.is_action_just_pressed("interact") && placed && canPlace && numBlueCanistersPlaced < 2:
		print('blue canister placed')
		emit_signal("blueCanisterPlaced", markerSound)
		set_scale(scale * 1.2)
		rpc("_placed_blue_canister")
		numBlueCanistersPlaced += 1
	if canPlace && Input.is_action_just_pressed("interact") && visible && !placed:
		$OmniLight.visible = false
		$MeshInstance.visible = false
		placed = true
		emit_signal("greenCanisterPlaced", markerSound)
		rpc("_placed_canister")
		match(markerSound):
			'Bass':
				var tree = preload('res://assets/Tree1.tscn').instance()
				add_child(tree)
			'Melody':
				var tree = preload('res://assets/Tree2.tscn').instance()
				add_child(tree)
			'Percussion':
				var tree = preload('res://assets/Tree3.tscn').instance()
				add_child(tree)
			'Harmony':
				var tree = preload('res://assets/Tree4.tscn').instance()
				add_child(tree)
			'Other':
				var tree = preload('res://assets/Tree5.tscn').instance()
				add_child(tree)
		

func _on_GreenCounter_numGreenCanistersCollected(numCanisters):
	if !placed:
		if numCanisters > 0:
			visible = true
		else:
			visible = false

func _on_GreenMarker_body_entered(body):
	if body.name == String(get_tree().get_network_unique_id()):
		canPlace = true

func _on_GreenMarker_body_exited(body):
	if body.name == String(get_tree().get_network_unique_id()):
		canPlace = false

func _on_BlueCounter_numBlueCanistersCollected(numCanisters):
	numBlueCanisters = numCanisters
	print(numBlueCanisters)
