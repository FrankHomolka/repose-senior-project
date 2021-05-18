extends Area

signal greenCanisterPlaced
signal blueCanisterPlaced
var numBlueCanisters = 0
var numBlueCanistersPlaced = 0
var canPlace = false
var placedGreenCanister = false
var scaleFactor = 3.5
var scaling = false
var previousScale = Vector3(0, 0, 0)
var newScale = 1
var scaleSpeed = 0.01
export var markerSound = 'test' setget marker_sound_set, marker_sound_get
onready var interactText = $InteractText
onready var waterPlantSound = $WaterPlantSound

func _ready():
	visible = false

func marker_sound_set(new_value):
	markerSound = new_value

func marker_sound_get():
	return markerSound

func _process(delta):
	if scaling:
		if(previousScale < newScale - Vector3(0.1, 0.1, 0.1)):
			#print(previousScale)
			#print(newScale)
			previousScale = lerp(previousScale, newScale, scaleSpeed)
			set_scale(previousScale)
		else:
			scaling = false
			previousScale = scale
	
	if canPlace && Input.is_action_just_pressed("interact"):
		if placedGreenCanister:
			if numBlueCanisters > 0 && numBlueCanistersPlaced < 2:
				waterPlantSound.play()
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
		scaling = true
		scale = previousScale
		newScale = Vector3(1,1,1)
		placedGreenCanister = true
		$OmniLight.visible = false
		$MeshInstance.visible = false
		$TreeGrow.play()
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
				var tree = preload('res://assets/Tree6.tscn').instance()
				add_child(tree)
			'Other':
				var tree = preload('res://assets/Tree7.tscn').instance()
				add_child(tree)

remote func _remote_placed_green_canister():
	_placed_green_canister()

func _placed_blue_canister():
	$TreeGrow.play()
	numBlueCanistersPlaced += 1
	emit_signal("blueCanisterPlaced", markerSound)
	scaling = true
	newScale = scale * scaleFactor
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
	#print(numBlueCanisters)

