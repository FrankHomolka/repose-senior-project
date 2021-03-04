extends Area

signal yellowCanisterPlaced
var canInteract = false
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
		$FlowerTest.visible = true
		$OmniLight.visible = false
		$MeshInstance.visible = false
		emit_signal("yellowCanisterPlaced", markerSound)

func _process(delta):
	if canInteract && Input.is_action_just_pressed("interact"):
		if !placed && visible:
			$OmniLight.visible = false
			$MeshInstance.visible = false
			$FlowerTest.visible = true
			placed = true
			emit_signal("yellowCanisterPlaced", markerSound)
			rpc("_placed_canister")

func _on_YellowMarker_body_entered(body):
	if body.name == String(get_tree().get_network_unique_id()):
		canInteract = true
		if placed:
			$Jingle.play()

func _on_YellowMarker_body_exited(body):
	if body.name == String(get_tree().get_network_unique_id()):
		canInteract = false

func _on_YellowCounter_numYellowCanistersCollected(numCanisters):
	if !placed:
		if numCanisters > 0:
			visible = true
			$FlowerTest.visible = false
		else:
			visible = false
