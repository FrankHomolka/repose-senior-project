extends Spatial

onready var bubbleGrowingSound = $BubbleGrowingSound

const oxygenMax = 100
const oxygenLossSpeed = 0.12
var oxygen = oxygenMax
var outside = false
var newColorValue = 0
signal outOfOxygen

var scaleFactor = 2
var scaling = false
onready var previousScale = $BubbleMesh.scale
var newScale = 1
var scaleSpeed = 0.01

var scalelvl = 1
const scale1 = Vector3(1, 1, 1) * 20
const scale2 = Vector3(7, 7, 7) * 20
const scale3 = Vector3(14, 14, 14) * 20
const scale4 = Vector3(20, 20, 20) * 20
const scale5 = Vector3(35, 35, 35) * 20

func  _ready():
	outside = false
	$SuffocateOverlay.visible = true

func _process(delta):
	if scaling:
		if(previousScale < newScale * 0.99):
			previousScale = lerp(previousScale, newScale, scaleSpeed)
			$BubbleMesh.set_scale(previousScale)
		else:
			bubbleGrowingSound.stop()
			scaling = false
			previousScale = $BubbleMesh.scale
	
	if outside:
		oxygen -= oxygenLossSpeed
		if oxygen < 0:
			_out_of_oxygen()
		else:
			newColorValue = (oxygen / oxygenMax);
			if newColorValue < 0.5:
				newColorValue -= 0.02
			print(newColorValue)
			$SuffocateOverlay.set_modulate(Color(newColorValue, newColorValue, newColorValue, 1 - newColorValue))

func _out_of_oxygen():
	oxygen = oxygenMax
	$SuffocateText.show()
	emit_signal("outOfOxygen")
	yield(get_tree().create_timer(4.0), "timeout")
	$SuffocateText.hide()

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
	$BubbleShape.scale = newScale

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
