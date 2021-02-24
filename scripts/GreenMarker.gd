extends Area

signal greenCanisterPlaced
var canPlace = false
var placed = false
export var markerSound = 'test' setget marker_sound_set, marker_sound_get

func _ready():
	visible = false
	#pass

func marker_sound_set(new_value):
	markerSound = new_value
#	match(new_value):
#		'$TestSound':
#			markerSound = $TestSound
#		'$TestSound2':
#			markerSound = $TestSound2

func marker_sound_get():
	return markerSound

remote func _placed_canister():
	if !placed:
		placed = true
		$FlowerTest.visible = true
		$OmniLight.visible = false
		$MeshInstance.visible = false
		emit_signal("greenCanisterPlaced", markerSound)

func _on_GreenCounter_numGreenCanistersCollected(numCanisters):
	if !placed:
		if numCanisters > 0:
			visible = true
			$FlowerTest.visible = false
		else:
			visible = false

func _process(delta):
	if canPlace && Input.is_action_just_pressed("interact") && visible:
		$OmniLight.visible = false
		$MeshInstance.visible = false
		$FlowerTest.visible = true
		placed = true
		emit_signal("greenCanisterPlaced", markerSound)
		rpc("_placed_canister")

func _on_GreenMarker_body_entered(body):
	if body.name == String(get_tree().get_network_unique_id()):
		canPlace = true

func _on_GreenMarker_body_exited(body):
	if body.name == String(get_tree().get_network_unique_id()):
		canPlace = false
