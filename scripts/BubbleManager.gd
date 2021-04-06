extends Spatial

const oxygenMax = 100
var oxygen = oxygenMax
var outside = false
var newColorValue = 0
var scaleFactor = 1.4
signal outOfOxygen

func  _ready():
	outside = false
	$SuffocateControl/SuffocateOverlay.visible = true

func _process(delta):
	if outside:
		oxygen -= 0.2
		if oxygen < 0:
			print('out of oxygen')
			_out_of_oxygen()
		else:
			print(newColorValue)
			newColorValue = (oxygen / oxygenMax);
			$SuffocateControl/SuffocateOverlay.set_modulate(Color(newColorValue, newColorValue, newColorValue, 1 - newColorValue))

func _out_of_oxygen():
	oxygen = oxygenMax
	emit_signal("outOfOxygen")

func _on_GreenMarker_greenCanisterPlaced(markerSound):
	set_scale(scale * scaleFactor)

func _on_GreenMarker_blueCanisterPlaced(markerSound):
	set_scale(scale * scaleFactor)

func _on_BubbleManager_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.name == String(get_tree().get_network_unique_id()):
		outside = false
		oxygen = oxygenMax
		$SuffocateControl/SuffocateOverlay.set_modulate(Color(255, 255, 255, 255))
		$SuffocateControl/SuffocateOverlay.visible = false

func _on_BubbleManager_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.name == String(get_tree().get_network_unique_id()):
		outside = true
		$SuffocateControl/SuffocateOverlay.visible = true
	print('exited')


