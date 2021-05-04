extends Spatial

onready var bubbleGrowingSound = $BubbleGrowingSound

const oxygenMax = 100
const oxygenLossSpeed = 0.15
var oxygen = oxygenMax
var outside = false
var newColorValue = 0
signal outOfOxygen

var scaleFactor = 2
var scaling = false
var previousScale = scale
var newScale = 1
var scaleSpeed = 0.01

var scalelvl = 1
const scale1 = Vector3(1, 1, 1)
const scale2 = Vector3(7, 7, 7)
const scale3 = Vector3(14, 14, 14)
const scale4 = Vector3(20, 20, 20)
const scale5 = Vector3(35, 35, 35)

func  _ready():
	outside = false
	$SuffocateOverlay.visible = true

func _process(delta):
	if scaling:
		if(previousScale < newScale - Vector3(0.1, 0.1, 0.1)):
#			print(previousScale)
#			print(newScale)
			previousScale = lerp(previousScale, newScale, scaleSpeed)
			set_scale(previousScale)
		else:
			bubbleGrowingSound.stop()
			scaling = false
			previousScale = scale
	
	if outside:
		oxygen -= oxygenLossSpeed
		if oxygen < 0:
#			print('out of oxygen')
			_out_of_oxygen()
		else:
#			print(newColorValue)
			newColorValue = (oxygen / oxygenMax);
			$SuffocateOverlay.set_modulate(Color(newColorValue, newColorValue, newColorValue, 1.4 - newColorValue))

func _out_of_oxygen():
	oxygen = oxygenMax
	emit_signal("outOfOxygen")

func _on_GreenMarker_greenCanisterPlaced(markerSound):
	if !bubbleGrowingSound.playing:
		bubbleGrowingSound.play()
	scaling = true
	scalelvl += 1
	match scalelvl:
		1:
			newScale = scale1
		2:
			newScale = scale2
		3:
			newScale = scale3
		4:
			newScale = scale4
		5:
			newScale = scale5

func _on_BubbleManager_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.name == String(get_tree().get_network_unique_id()):
		outside = false
		oxygen = oxygenMax
		$SuffocateOverlay.set_modulate(Color(255, 255, 255, 255))
		$SuffocateOverlay.visible = false

func _on_BubbleManager_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.name == String(get_tree().get_network_unique_id()):
		outside = true
		$SuffocateOverlay.visible = true
#	print('exited')


