extends Spatial

var counter = 0
var oldVolume = 1
var newVolume = 0
var transition = false
var transitionSpeed = 0.003
var audioMode = 'local'

var bassLvl = 0
var guitarLvl = 0
var pianoLvl = 0
var slideLvl = 0
var violinLvl = 0
var volumeLevel = 5
var maxVolume = 20

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

onready var wind = $wind

# Called when the node enters the scene tree for the first time.
func _ready():
	$UnlockText.visible = false
	$UnlockNote.visible = false
	if audioMode == 'local': 
		if is_network_master():
			wind.play()
	else:
		wind.play()
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
	if audioMode == 'local': 
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
	else:
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

func _on_GreenMarker_greenCanisterPlaced(markerSound):
	match(markerSound):
		'Bass':
			bassLvl += 1
			bass1.set_volume_db(linear2db(volumeLevel))
		'Melody':
			violinLvl += 1
			violin1.set_volume_db(linear2db(volumeLevel))
		'Percussion':
			guitarLvl += 1
			guitar1.set_volume_db(linear2db(volumeLevel))
		'Harmony':
			pianoLvl += 1
			piano1.set_volume_db(linear2db(volumeLevel))
		'Other':
			slideLvl += 1
			slide1.set_volume_db(linear2db(volumeLevel))
	$UnlockNote.visible = true
	$UnlockText.visible = true
	$UnlockText.text = markerSound + ' unlocked'
	yield(get_tree().create_timer(7.0), "timeout")
	$UnlockText.visible = false
	$UnlockNote.visible = false
	print(markerSound)


func _on_GreenMarker_blueCanisterPlaced(markerSound):
	match(markerSound):
		'Bass':
			if bassLvl == 1:
				bass1.set_volume_db(linear2db(0.0))
				bass2.set_volume_db(linear2db(volumeLevel))
			elif bassLvl == 2:
				bass2.set_volume_db(linear2db(0.0))
				bass3.set_volume_db(linear2db(volumeLevel))
			bassLvl += 1
		'Melody':
			if violinLvl == 1:
				violin1.set_volume_db(linear2db(0.0))
				violin2.set_volume_db(linear2db(volumeLevel))
			elif violinLvl == 2:
				violin2.set_volume_db(linear2db(0.0))
				violin3.set_volume_db(linear2db(volumeLevel))
			violinLvl += 1
		'Percussion':
			if guitarLvl == 1:
				guitar1.set_volume_db(linear2db(0.0))
				guitar2.set_volume_db(linear2db(volumeLevel))
			elif guitarLvl == 2:
				guitar2.set_volume_db(linear2db(0.0))
				guitar3.set_volume_db(linear2db(volumeLevel))
			guitarLvl += 1
		'Harmony':
			if pianoLvl == 1:
				piano1.set_volume_db(linear2db(0.0))
				piano2.set_volume_db(linear2db(volumeLevel))
			elif pianoLvl == 2:
				piano2.set_volume_db(linear2db(0.0))
				piano3.set_volume_db(linear2db(volumeLevel))
			pianoLvl += 1
		'Other':
			if slideLvl == 1:
				slide1.set_volume_db(linear2db(0.0))
				slide2.set_volume_db(linear2db(volumeLevel))
			elif slideLvl == 2:
				slide2.set_volume_db(linear2db(0.0))
				slide3.set_volume_db(linear2db(volumeLevel))
			slideLvl += 1
	print(markerSound)


#func _on_MusicVolumeSlider_value_changed(value):
#	var tempVol = (value / 100) * maxVolume
#	tempVol += 1.1
#	volumeLevel = tempVol
#	#print('tempVol ' + String(tempVol))
#	#print('db ' + String(bass1.volume_db))
#	if bass1.volume_db > 0:
#		bass1.set_volume_db(linear2db(tempVol))
#	if bass2.volume_db > 0:
#		bass2.set_volume_db(linear2db(tempVol))
#	if bass3.volume_db > 0:
#		bass3.set_volume_db(linear2db(tempVol))
#	if guitar1.volume_db > 0:
#		guitar1.set_volume_db(linear2db(tempVol))
#	if guitar2.volume_db > 0:
#		guitar2.set_volume_db(linear2db(tempVol))
#	if guitar3.volume_db > 0:
#		guitar3.set_volume_db(linear2db(tempVol))
#	if piano1.volume_db > 0:
#		piano1.set_volume_db(linear2db(tempVol))
#	if piano2.volume_db > 0:
#		piano2.set_volume_db(linear2db(tempVol))
#	if piano3.volume_db > 0:
#		piano3.set_volume_db(linear2db(tempVol))
#	if slide1.volume_db > 0:
#		slide1.set_volume_db(linear2db(tempVol))
#	if slide2.volume_db > 0:
#		slide2.set_volume_db(linear2db(tempVol))
#	if slide3.volume_db > 0:
#		slide3.set_volume_db(linear2db(tempVol))
#	if violin1.volume_db > 0:
#		violin1.set_volume_db(linear2db(tempVol))
#	if violin2.volume_db > 0:
#		violin2.set_volume_db(linear2db(tempVol))
#	if violin3.volume_db > 0:
#		violin3.set_volume_db(linear2db(tempVol))
