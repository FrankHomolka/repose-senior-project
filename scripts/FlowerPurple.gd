extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var counter = 0
var oldVolume = 1
var newVolume = 0
var transition = false

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
		oldVolume -= 0.001
		newVolume += 0.001


func _on_FlowerPurple_body_entered(body):
	if body.name == "Player":
		print('flowr')
		transition = true
		$Jingle.play()
