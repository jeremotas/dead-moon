extends CharacterBody3D

func _physics_process(delta):
	velocity = Vector3(0.1, 0.0, 0.01)
	var collision = move_and_collide(velocity * delta)
	if collision:
		print("COLISIONÓ con: ", collision.get_collider())
