extends KinematicBody

var mouse_sensitivity = 0.03
var h_acceleration = 6
var air_acceleration = 1
var normal_acceleration = 6
var gravity = 20
var jump = 10
var full_contact = false

var speed = 10

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()
var input_dir = Vector3()

var stunned = false

onready var head = $Head
onready var ground_check = $GroundCheck

func _ready():
	Input.set_mouse_mode((Input.MOUSE_MODE_CAPTURED))

remote func _set_position(pos):
	global_transform.origin = pos

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

#puppet func stun():
#	stunned = true
#	print('stunned ' + String(get_tree().get_network_unique_id()))
#
#master func exploded(by_who):
#	if stunned:
#		return
#
#	rpc("stun")
#
#	stun()

func _physics_process(delta):
	direction = Vector3()
	
	full_contact = ground_check.is_colliding();
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acceleration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_acceleration = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()
		h_acceleration = normal_acceleration
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
		#rpc("exploded", get_tree().get_network_unique_id())
		#print(get_tree().get_network_unique_id())
		gravity_vec = Vector3.UP * jump
	
	input_dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction += input_dir.z * transform.basis.z
	direction += input_dir.x * transform.basis.x
	
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	if direction != Vector3():
		if is_network_master():
			move_and_slide(movement, Vector3.UP)
		rpc_unreliable("_set_position", global_transform.origin)
