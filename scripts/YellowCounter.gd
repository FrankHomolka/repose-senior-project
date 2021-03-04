extends Label

signal numYellowCanistersCollected
var yellowCanisters = 0

func _ready():
	setText(yellowCanisters)

func setText(labelText):
	text = String(labelText)

func _on_YellowCanister_yellowCanisterCollected():
	yellowCanisters += 1
	$PickupSound.play()
	emit_signal("numYellowCanistersCollected", yellowCanisters)
	setText(yellowCanisters)

func _on_YellowMarker_yellowCanisterPlaced(markerSound):
	yellowCanisters -= 1
	emit_signal("numYellowCanistersCollected", yellowCanisters)
	setText(yellowCanisters)
