extends Area

signal yellowCanisterPlaced
var canInteract = false
var placed = false
export var markerSound = 'test' setget marker_sound_set, marker_sound_get
onready var interactText = $InteractText
var numYellowCanisters = 0

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
		$InteractText.text = ""
		$MeshInstance.visible = false
		emit_signal("yellowCanisterPlaced", markerSound)

func _process(delta):
	if canInteract && Input.is_action_just_pressed("interact"):
		if !placed && visible:
			$InteractText.text = ""
			$OmniLight.visible = false
			$MeshInstance.visible = false
			$FlowerTest.visible = true
			placed = true
			emit_signal("yellowCanisterPlaced", markerSound)
			rpc("_placed_canister")

func _on_YellowMarker_body_entered(body):
	if body.name == String(get_tree().get_network_unique_id()) and numYellowCanisters > 0:
		canInteract = true
		if placed:
			match(markerSound):
				'A':
					$A.play()
				'A-':
					$"A-".play()
				'B':
					$B.play()
				'B-':
					$"B-".play()
				'D':
					$D.play()
				'D-':
					$"D-".play()
				'E':
					$E.play()
				'E-':
					$"E-".play()
				'G':
					$G.play()
				'G-':
					$"G-".play()
		else:
			$InteractText.text = "Press 'E' to grow a flower"

func _on_YellowMarker_body_exited(body):
	if body.name == String(get_tree().get_network_unique_id()):
		canInteract = false
		$InteractText.text = ""

func _on_YellowCounter_numYellowCanistersCollected(numCanisters):
	if !placed:
		numYellowCanisters += 1
		if numCanisters > 0:
			visible = true
			$FlowerTest.visible = false
		else:
			visible = false
