extends CharacterBody3D

const MAX_SPEED = 4.0
const MIN_SPEED = 2.0
const ACCELERATION  = 2.0
const JUMP_VELOCITY = 4.5
const ROTATION_ACCELERATION = 0.2
const MAX_ROTATION_SPEED = 4.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rotate_camera = 0.0
var speed = 0.0
var attacking = false
var can_move = true
var can_idle = true
var live = 1
var dead = false

@onready var camera = $SpringArm3D/Camera3D
var tween: Tween

func _ready():
	tween = create_tween()
	

func _process(delta):
	pass
		
func camera_backwards():
	if $Personaje.what_is_doing() != 'death2':
		tween = create_tween()
		tween.tween_property($SpringArm3D, "spring_length",$SpringArm3D.spring_length * 2 , 3.0)

func get_sticks():
	var left_stick = Vector2(
		-Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
		-Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	)
	var right_stick = Vector2(
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	)
	if left_stick.length() < 0.2:
		left_stick = Vector2.ZERO
	if right_stick.length() < 0.2:
		right_stick = Vector2.ZERO	
	return {"left": left_stick, "right": right_stick}

func _physics_process(delta):
	if dead:
		return 
	if $Personaje.last_anim_finished() == 'attack':
		attacking = false
		can_move = true
		$Personaje.clear_last_anim_finished()
		live = live - 1
	
	if $Personaje.last_anim_finished() == 'death2':
		dead = true
		can_move = false
		$Personaje.clear_last_anim_finished()
		return
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		can_move = true
	elif $Personaje.get_state() == 'idle1':
		can_move = true
		velocity.y = 0.0
			
	if Input.is_action_just_pressed("jump") and is_on_floor() and not attacking:
		velocity.y = JUMP_VELOCITY
		can_move = false
		
	var move_direction = Vector3.ZERO
	var oSticks = get_sticks()
	if can_move:	
		var forward_direction = camera.get_global_transform().basis.z
		var lateral_direction = camera.get_global_transform().basis.x
		
		var input_vector = Vector2.ZERO
		
		#input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		#input_vector.y = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
		#input_vector = input_vector.normalized()
		move_direction.x = oSticks.left.x
		move_direction.z = oSticks.left.y
		# if Input.is_action_pressed("strafe_left"):
		#	move_direction -= lateral_direction
		#if Input.is_action_pressed("strafe_right"):
		#	move_direction += lateral_direction
		#if Input.is_action_pressed("forward"):
		#	move_direction = -forward_direction
		#if Input.is_action_pressed("backward"):
		#	move_direction = forward_direction
			
			
		if Input.is_action_just_pressed("attack") and not attacking:
			$Personaje.do("attack")
			attacking = true
			can_move = false
			
			
		if move_direction == Vector3.ZERO:
			speed = 0.0
		else:
			speed = clamp(speed + ACCELERATION * delta, MIN_SPEED, MAX_SPEED)
	
	var direction = move_direction
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, delta * 8)
		velocity.z = move_toward(velocity.z, 0, delta * 8)
	
	if Input.is_action_pressed("turn_left"):
		rotate_camera += ROTATION_ACCELERATION
	if Input.is_action_pressed("turn_right"):
		rotate_camera -= ROTATION_ACCELERATION
	if not Input.is_action_pressed("turn_left") and not Input.is_action_pressed("turn_right"):
		rotate_camera = 0
	rotate_camera = clamp(rotate_camera, -MAX_ROTATION_SPEED, MAX_ROTATION_SPEED)

	if rotate_camera != 0:
		rotate_y( rotate_camera * delta)
	if live == 0 and not dead:
		camera_backwards()
		$Personaje.do("death2")
		
	elif attacking:
		pass
	elif abs(velocity.y) > 0.5:
		$Personaje.do("fall_idle")
	elif velocity.length() > 0.2 and is_on_floor():
		$Personaje.do("rundirection")
		$Personaje.movement(oSticks.left)
	elif is_on_floor() and velocity.length() < 0.1 and not attacking:
		$Personaje.do("idle1")
	
	move_and_slide()
