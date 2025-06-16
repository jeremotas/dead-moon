extends Node3D

@export var speed = 40.0
var direction = Vector3.ZERO

func _process(delta):
	position += transform.basis  * Vector3(0.0, 0.0, speed) * delta

	# Opcional: destruir después de cierto tiempo
	if global_position.length() > 100:
		queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("HIT", body)
	if "hit" in body:
		body.hit()
	queue_free()
	
