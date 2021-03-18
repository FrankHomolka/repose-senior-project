extends Area

signal greenCanisterPlaced
signal blueCanisterPlaced
var numBlueCanisters = 0
var numBlueCanistersPlaced = 0
var canPlace = false
var placedGreenCanister = false
var scaleFactor = 1.5
export var markerSound = 'test' setget marker_sound_set, marker_sound_get
onready var interactText = $InteractText

func _ready():
	visible = false

func marker_sound_set(new_value):
	markerSound = new_value

func marker_sound_get():
	return markerSound

func _process(delta):
	if canPlace && Input.is_action_just_pressed("interact"):
		if placedGreenCanister:
			if numBlueCanisters > 0 && numBlueCanistersPlaced < 2:
				_placed_blue_canister()
				rpc("_remote_placed_blue_canister")
		elif visible:
			_placed_green_canister()
			rpc("_remote_placed_green_canister")

func _set_interact_text():
	if canPlace:
		if numBlueCanistersPlaced < 2:
			if placedGreenCanister and numBlueCanisters > 0:
				$InteractText.text = "Press 'E' to grow"
			elif visible && !placedGreenCanister:
				$InteractText.text = "Press 'E' to plant"
			else:
				$InteractText.text = ""
		else:
			$InteractText.text = ""

func _placed_green_canister():
	if !placedGreenCanister:
		placedGreenCanister = true
		$OmniLight.visible = false
		$MeshInstance.visible = false
		emit_signal("greenCanisterPlaced", markerSound)
		_set_interact_text()
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

remote func _remote_placed_green_canister():
	_placed_green_canister()

func _placed_blue_canister():
	numBlueCanistersPlaced += 1
	emit_signal("blueCanisterPlaced", markerSound)
	set_scale(scale * scaleFactor)
	_set_interact_text()

remote func _remote_placed_blue_canister():
	_placed_blue_canister()

func _on_GreenCounter_numGreenCanistersCollected(numCanisters):
	if !placedGreenCanister:
		if numCanisters > 0:
			visible = true
		else:
			visible = false

func _on_GreenMarker_body_entered(body):
	if body.name == String(get_tree().get_network_unique_id()):
		canPlace = true
		_set_interact_text()

func _on_GreenMarker_body_exited(body):
	if body.name == String(get_tree().get_network_unique_id()):
		canPlace = false
		$InteractText.text = ""

func _on_BlueCounter_numBlueCanistersCollected(numCanisters):
	numBlueCanisters = numCanisters
	print(numBlueCanisters)
