extends Node


func _ready():
	pass


func _on_Lobby_playerHosted():
	$Background.hide()
	$"Bottom Align".hide()
	$"Left Align".hide()
	$"Top Align".hide()
	$"Center Align/hosted".show()


func _on_Lobby_playerJoined():
	$Background.hide()
	$"Bottom Align".hide()
	$"Left Align".hide()
	$"Top Align".hide()
	$"Center Align/joined".show()


func _on_ButtonSinglePlayer_pressed():
	pass # Replace with function body.
