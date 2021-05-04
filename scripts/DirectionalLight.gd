extends DirectionalLight

func _ready():
	pass


func _physics_process(delta):
	set_rotation(Vector3(rotation.x + 0.0001, rotation.y, rotation.z))
	print(rotation)
