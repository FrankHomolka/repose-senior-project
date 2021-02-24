extends Area

signal greenCanisterPlaced
signal blueCanisterPlaced
var numBlueCanisters = 0
var canPlace = false
var placed = false
export var markerSound = 'test' setget marker_sound_set, marker_sound_get

func _ready():
	visible = false
	#pass

func marker_sound_set(new_value):
	markerSound = new_value

func marker_sound_get():
	return markerSound

remote func _placed_canister():
	if !placed:
		placed = true
		$FlowerTest.visible = true
		$OmniLight.visible = false
		$MeshInstance.visible = false
		emit_signal("greenCanisterPlaced", markerSound)

remote func _placed_blue_canister():
	print('client side blue canister placed')
	emit_signal("blueCanisterPlaced", markerSound)
	set_scale(scale * 2)

func _process(delta):
	if numBlueCanisters > 0 && Input.is_action_just_pressed("interact") && placed && canPlace:
		print('blue canister placed')
		emit_signal("blueCanisterPlaced", markerSound)
		set_scale(scale * 2)
		rpc("_placed_blue_canister")
	if canPlace && Input.is_action_just_pressed("interact") && visible && !placed:
		$OmniLight.visible = false
		$MeshInstance.visible = false
		$FlowerTest.visible = true
		placed = true
		emit_signal("greenCanisterPlaced", markerSound)
		rpc("_placed_canister")

func _on_GreenCounter_numGreenCanistersCollected(numCanisters):
	if !placed:
		if numCanisters > 0:
			visible = true
			$FlowerTest.visible = false
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
