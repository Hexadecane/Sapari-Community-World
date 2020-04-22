extends KinematicBody

var gravity = -9.8
var velocity = Vector3()
var character
onready var camera = $Camera

const SPEED = 3
const ACCELERATION = 10
const DECELERATION = 15


# Called when the node enters the scene tree for the first time.
func _ready():
	character = $PlayerMeshInstance


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var dir = Vector3()
	
	var is_moving = false
	
	var camtransform = camera.get_camera_transform()
	
	if (Input.is_action_pressed("move_forward")):
		dir -= camtransform[2]
		is_moving = true
	if (Input.is_action_pressed("move_backward")):
		dir += camtransform[2]
		is_moving = true
	if (Input.is_action_pressed("move_left")):
		dir -= camtransform[0]
		is_moving = true
	if (Input.is_action_pressed("move_right")):
		dir += camtransform[0]
		is_moving = true
	
	if (Input.is_action_just_pressed("ui_page_up") and camera.distance > 2):
		camera.set_distance(camera.distance - 1)
	elif (Input.is_action_just_pressed("ui_page_down") and camera.distance < 7):
		camera.set_distance(camera.distance + 1)
	
	dir.y = 0
	dir = dir.normalized()
	
	#velocity.y += delta * gravity
	
	var hv = velocity
	hv.y = 0
	
	var new_pos = dir * SPEED
	var accel = DECELERATION
	
	if (dir.dot(hv) > 0):
		accel = ACCELERATION
	
	hv = hv.linear_interpolate(new_pos, accel * delta)
	
	velocity.x = hv.x
	velocity.z = hv.z
	
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	
	if is_moving:
		var angle = atan2(hv.x, hv.z)
		var char_rot = character.get_rotation()
		
		char_rot.y = angle
		character.set_rotation(char_rot)

