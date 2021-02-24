extends Spatial

var counter = 0
var oldVolume = 1
var newVolume = 0
var transition = false
var transitionSpeed = 0.003
var percussionLvl = 0
var bassLvl = 0
var harmonyLvl = 0
var melodyLvl = 0
var otherLvl = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_network_master(): # added for testing on one pc
		$song1harmony1.play()
		$song1harmony2.play()
		$song1harmony1.set_volume_db(linear2db(0.0))
		$song1harmony2.set_volume_db(linear2db(0.0))
		$song1melody1.play()
		$song1melody2.play()
		$song1melody1.set_volume_db(linear2db(0.0))
		$song1melody2.set_volume_db(linear2db(0.0))
		$song1perc1.play()
		$song1perc2.play()
		$song1perc1.set_volume_db(linear2db(0.0))
		$song1perc2.set_volume_db(linear2db(0.0))
		$song1bass1.play()
		$song1bass2.play()
		$song1bass1.set_volume_db(linear2db(0.0))
		$song1bass2.set_volume_db(linear2db(0.0))
		$song1other1.play()
		$song1other2.play()
		$song1other1.set_volume_db(linear2db(0.0))
		$song1other2.set_volume_db(linear2db(0.0))

remote func _transition_music(trans):
	transition = trans

func _process(delta):
	if is_network_master(): # added for testing on one pc
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

#func _on_FlowerPurple_body_entered(body):
#	print('body name = ' + body.name)
#	print('unique id = ' + String(get_tree().get_network_unique_id()))
#	if body.name == String(get_tree().get_network_unique_id()):
#		rpc("_transition_music", true)
#		print('successful flower collision')
#		transition = true
#		$Jingle.play()

func _on_GreenMarker_greenCanisterPlaced(markerSound):
	match(markerSound):
		'Bass':
			$song1bass1.set_volume_db(linear2db(1.0))
		'Melody':
			$song1melody1.set_volume_db(linear2db(1.0))
		'Percussion':
			$song1perc1.set_volume_db(linear2db(1.0))
		'Harmony':
			$song1harmony1.set_volume_db(linear2db(1.0))
		'Other':
			$song1other1.set_volume_db(linear2db(1.0))
	print(markerSound)
