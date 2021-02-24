extends Label

signal numBlueCanistersCollected
var blueCanisters = 0

func _ready():
	setText(blueCanisters)

func setText(labelText):
	text = String(labelText)

func _on_BlueCanister_blueCanisterCollected():
	blueCanisters += 1
	emit_signal("numBlueCanistersCollected", blueCanisters)
	setText(blueCanisters)

func _on_GreenMarker_blueCanisterPlaced(markerSound):
	print('blue minus 1')
	blueCanisters -= 1
	emit_signal("numBlueCanistersCollected", blueCanisters)
	setText(blueCanisters)
