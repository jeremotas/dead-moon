extends Node3D

const MOVE_SPEED = 10
const ROTATION_SPEED = 1.0

func _process(delta):
	var move_direction = Vector3.ZERO
	var forward_direction = $Camera.get_global_transform().basis.z
	if Input.is_action_pressed("cam_left"):
		move_direction.z -= 1
	if Input.is_action_pressed("cam_right"):
		move_direction.z += 1
	if Input.is_action_pressed("cam_up"):
		move_direction = -forward_direction
	if Input.is_action_pressed("cam_down"):
		move_direction = forward_direction
		
	
	


	if move_direction != Vector3.ZERO:
		move_direction = move_direction.normalized() * MOVE_SPEED * delta
		$Camera.global_position += move_direction
	
	# Example: Camera rotation
	if Input.is_action_pressed("cam_rotate_left"):
		$Camera.rotate_y(ROTATION_SPEED * delta)
	if Input.is_action_pressed("cam_rotate_right"):
		$Camera.rotate_y(-ROTATION_SPEED * delta)
