extends CharacterBody3D

const SPEED_CAP_POSITIVE = 10.0
const SPEED_CAP_RESTING = 0.0
const SPEED_CAP_NEGATIVE = -10.0
const ACCELERATION = 0.2
const DECELERATION = 0.4
const JUMP_VELOCITY = 4.5
const BACKFLIP_VELOCITY_Y = 9.0
const BACKFLIP_VELOCITY_XZ = -4.0

var jumps = 2
var crouching
var was_crouching
var speed = 0.0

@onready var camera = get_parent().get_node("/root/Test/CamLook")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("game_jump") and jumps > 0:
		if crouching:
			if is_on_floor():
				velocity.y = BACKFLIP_VELOCITY_Y
				var direction = -transform.basis.z.normalized()
				velocity.x = direction.x * BACKFLIP_VELOCITY_XZ
				velocity.z = direction.z * BACKFLIP_VELOCITY_XZ
		else:
			velocity.y = JUMP_VELOCITY
		jumps -= 1
		
	if is_on_floor() and velocity.y <= 0:
		jumps = 2
	
	# Handle crouch.
	if Input.is_action_pressed("game_crouch"):
		crouching = true
	else:
		crouching = false
		
	if crouching == true:
		scale.y = 1
		if !was_crouching:
			position.y -= 1
		was_crouching = true
	else:
		scale.y = 2
		if was_crouching:
			position.y += 1
		was_crouching = false

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("game_left", "game_right", "game_up", "game_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		speed = clamp(speed + 0.1, SPEED_CAP_NEGATIVE, SPEED_CAP_POSITIVE)
	else:
		if speed > SPEED_CAP_RESTING:
			speed = max(speed - ACCELERATION, SPEED_CAP_RESTING)
		elif speed < SPEED_CAP_RESTING:
			speed = min(speed + ACCELERATION, SPEED_CAP_RESTING)
			
	if direction: 
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)

	move_and_slide()
	
	# Rotate the player based on the camera.
	if camera != null:
		rotation_degrees.y = camera.rotation_degrees.y
