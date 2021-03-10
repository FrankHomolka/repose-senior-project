extends Spatial

var counter = 0
var oldVolume = 1
var newVolume = 0
var transition = false
var transitionSpeed = 0.003

var bassLvl = 0
var guitarLvl = 0
var pianoLvl = 0
var slideLvl = 0
var violinLvl = 0

onready var bass1 = $bass1
onready var bass2 = $bass2
onready var bass3 = $bass3
onready var guitar1 = $guitar1
onready var guitar2 = $guitar2
onready var guitar3 = $guitar3
onready var piano1 = $piano1
onready var piano2 = $piano2
onready var piano3 = $piano3
onready var slide1 = $slide1
onready var slide2 = $slide2
onready var slide3 = $slide3
onready var violin1 = $violin1
onready var violin2 = $violin2
onready var violin3 = $violin3

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_network_master(): # added for testing on one pc
		bass1.play()
		bass2.play()
		bass3.play()
		bass1.set_volume_db(linear2db(0.0))
		bass2.set_volume_db(linear2db(0.0))
		bass3.set_volume_db(linear2db(0.0))
		guitar1.play()
		guitar2.play()
		guitar3.play()
		guitar1.set_volume_db(linear2db(0.0))
		guitar2.set_volume_db(linear2db(0.0))
		guitar3.set_volume_db(linear2db(0.0))
		piano1.play()
		piano2.play()
		piano3.play()
		piano1.set_volume_db(linear2db(0.0))
		piano2.set_volume_db(linear2db(0.0))
		piano3.set_volume_db(linear2db(0.0))
		slide1.play()
		slide2.play()
		slide3.play()
		slide1.set_volume_db(linear2db(0.0))
		slide2.set_volume_db(linear2db(0.0))
		slide3.set_volume_db(linear2db(0.0))
		violin1.play()
		violin2.play()
		violin3.play()
		violin1.set_volume_db(linear2db(0.0))
		violin2.set_volume_db(linear2db(0.0))
		violin3.set_volume_db(linear2db(0.0))

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
			bassLvl += 1
			bass1.set_volume_db(linear2db(1.0))
		'Melody':
			violinLvl += 1
			violin1.set_volume_db(linear2db(1.0))
		'Percussion':
			guitarLvl += 1
			guitar1.set_volume_db(linear2db(1.0))
		'Harmony':
			pianoLvl += 1
			piano1.set_volume_db(linear2db(1.0))
		'Other':
			slideLvl += 1
			slide1.set_volume_db(linear2db(1.0))
	print(markerSound)


func _on_GreenMarker_blueCanisterPlaced(markerSound):
	match(markerSound):
		'Bass':
			if bassLvl == 1:
				bass1.set_volume_db(linear2db(0.0))
				bass2.set_volume_db(linear2db(1.0))
			elif bassLvl == 2:
				bass2.set_volume_db(linear2db(0.0))
				bass3.set_volume_db(linear2db(1.0))
			bassLvl += 1
		'Melody':
			if violinLvl == 1:
				violin1.set_volume_db(linear2db(0.0))
				violin2.set_volume_db(linear2db(1.0))
			elif violinLvl == 2:
				violin2.set_volume_db(linear2db(0.0))
				violin3.set_volume_db(linear2db(1.0))
			violinLvl += 1
		'Percussion':
			if guitarLvl == 1:
				guitar1.set_volume_db(linear2db(0.0))
				guitar2.set_volume_db(linear2db(1.0))
			elif guitarLvl == 2:
				guitar2.set_volume_db(linear2db(0.0))
				guitar3.set_volume_db(linear2db(1.0))
			guitarLvl += 1
		'Harmony':
			if pianoLvl == 1:
				piano1.set_volume_db(linear2db(0.0))
				piano2.set_volume_db(linear2db(1.0))
			elif pianoLvl == 2:
				piano2.set_volume_db(linear2db(0.0))
				piano3.set_volume_db(linear2db(1.0))
			pianoLvl += 1
		'Other':
			if slideLvl == 1:
				slide1.set_volume_db(linear2db(0.0))
				slide2.set_volume_db(linear2db(1.0))
			elif slideLvl == 2:
				slide2.set_volume_db(linear2db(0.0))
				slide3.set_volume_db(linear2db(1.0))
			slideLvl += 1
	print(markerSound)
