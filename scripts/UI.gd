extends Control

var showingSettings = false

func _ready():
	$QuitButton.visible = false
	$Settings.visible = false
	$MusicVolume.visible = false
	$MusicVolumeSlider.visible = false
	$SoundVolume.visible = false
	$SoundVolumeSlider.visible = false

func _process(delta):
	if Input.is_action_just_pressed('quit'):
		showingSettings = !showingSettings
		$QuitButton.visible = showingSettings
		$Settings.visible = showingSettings
		$MusicVolume.visible = showingSettings
		$MusicVolumeSlider.visible = showingSettings
		$SoundVolume.visible = showingSettings
		$SoundVolumeSlider.visible = showingSettings

func _on_MusicVolumeSlider_value_changed(value):
	Globals.musicVolume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	print(value)

func _on_SoundVolumeSlider_value_changed(value):
	Globals.soundVolume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), value)
	print(value)

func _on_QuitButton_pressed():
	get_tree().quit()
