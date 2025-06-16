extends Node3D

func _process(_delta):
	if Input.is_action_pressed("restart"):
		print("Reinicio")
		get_tree().reload_current_scene()
