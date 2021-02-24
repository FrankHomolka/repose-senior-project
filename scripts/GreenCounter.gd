extends Label

signal numGreenCanistersCollected
var greenCanisters = 0

func _ready():
	setText(greenCanisters)

func _on_GreenCanister_collected():
	greenCanisters += 1
	emit_signal("numGreenCanistersCollected", greenCanisters)
	setText(greenCanisters)

func _on_GreenMarker_greenCanisterPlaced(markerSound):
	greenCanisters -= 1
	emit_signal("numGreenCanistersCollected", greenCanisters)
	setText(greenCanisters)

func setText(labelText):
	text = String(labelText)
