extends Node3D

func _process(delta):
	var velocidad = -0.0125  # velocidad en radianes por segundo
	var eje_local = transform.basis.y.normalized()

	rotate(eje_local, velocidad * delta)
