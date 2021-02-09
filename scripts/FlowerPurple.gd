extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var counter = 0
var oldVolume = 1
var newVolume = 0
var transition = false
var transitionSpeed = 0.1#0.003

# Called when the node enters the scene tree for the first time.
func _ready():
	$song1harmony1.play()
	$song1harmony2.play()
	$song1harmony2.set_volume_db(linear2db(0.0))
	$song1melody1.play()
	$song1melody2.play()
	$song1melody2.set_volume_db(linear2db(0.0))
	$song1perc1.play()
	$song1perc2.play()
	$song1perc2.set_volume_db(linear2db(0.0))
	$song1bass1.play()
	$song1bass2.play()
	$song1bass2.set_volume_db(linear2db(0.0))
	$song1other1.play()
	$song1other2.play()
	$song1other2.set_volume_db(linear2db(0.0))

remote func _transition_music(trans):
	transition = trans

func _process(delta):
	if transition and oldVolume > 0 and newVolume < 1:
		$song1perc1.set_volume_db(linear2db(oldVolume))
		$song1perc2.set_volume_db(linear2db(newVolume))
		$song1harmony1.set_volume_db(linear2db(oldVolume))
		$song1harmony2.set_volume_db(linear2db(newVolume))
		$song1melody1.set_volume_db(linear2db(oldVolume))
		$song1melody2.set_volume_db(linear2db(newVolume))
		$song1bass1.set_volume_db(linear2db(oldVolume))
		$song1bass2.set_volume_db(linear2db(newVolume))
		$song1other1.set_volume_db(linear2db(oldVolume))
		$song1other2.set_volume_db(linear2db(newVolume))
		oldVolume -= transitionSpeed
		newVolume += transitionSpeed

func _on_FlowerPurple_body_entered(body):
	print('body name = ' + body.name)
	print('unique id = ' + String(get_tree().get_network_unique_id()))
	if body.name == String(get_tree().get_network_unique_id()):
		rpc("_transition_music", true)
		print('successful flower collision')
		transition = true
		$Jingle.play()
