extends Area

signal greenCanisterCollected
var canPickup = false
var emitted = false
onready var interactText = $InteractText

func _ready():
	pass # Replace with function body.

remote func _collected():
	if !emitted:
		emit_signal("greenCanisterCollected")
		emitted = true
		queue_free()

func _process(delta):
	if canPickup && Input.is_action_just_pressed("interact"):
		rpc("_collected")
		emit_signal("greenCanisterCollected")
		emitted = true
		queue_free()

func _on_GreenCanister_body_entered(body):
	if body.name == String(get_tree().get_network_unique_id()):
		canPickup = true
		$InteractText.text = "Press 'E' to collect green canister"

func _on_GreenCanister_body_exited(body):
	if body.name == String(get_tree().get_network_unique_id()):
		canPickup = false
		$InteractText.text = ""
