extends Node

onready var light = $DirectionalLight
onready var environment = $WorldEnvironment

func _ready():
	pass

func _process(delta):
	pass
	#light.set_rotation(Vector3(light.rotation.x + 0.001, light.rotation.y, light.rotation.z))
	#environment.set_sun_latitude(environment.get_sun_latitude() + 1)
