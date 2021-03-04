extends Area

signal yellowCanisterCollected
var canPickup = false
var emitted = false

func _ready():
	pass # Replace with function body.

remote func _collected():
	if !emitted:
		emit_signal("yellowCanisterCollected")
		emitted = true
		queue_free()

func _process(delta):
	if canPickup && Input.is_action_just_pressed("interact"):
		rpc("_collected")
		emit_signal("yellowCanisterCollected")
		emitted = true
		queue_free()

func _on_YellowCanister_body_entered(body):
	if body.name == String(get_tree().get_network_unique_id()):
		canPickup = true

func _on_YellowCanister_body_exited(body):
	if body.name == String(get_tree().get_network_unique_id()):
		canPickup = false
