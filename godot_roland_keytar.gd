extends Node3D

var altura_base = 0.0
var tiempo = 0.0

func _ready():
	altura_base = global_transform.origin.y

func _process(delta):
	tiempo += delta
	var amplitud = 0.25  # cuánta altura sube/baja
	var frecuencia = 1.8  # cuán rápido sube/baja
	var nueva_altura = altura_base + sin(tiempo * frecuencia) * amplitud

	var pos = global_transform.origin
	pos.y = nueva_altura
	global_transform.origin = pos
