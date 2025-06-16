extends Node3D

func _process(delta):
	var velocidad = 1.0  # velocidad en radianes por segundo
	rotate_y(velocidad * delta)
