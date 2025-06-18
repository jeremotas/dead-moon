extends CharacterBody3D
var life = 1
var dead = false
var can_move = true
var player = null
var looking = true
var attacking = false
var attack = false
var can_attack = true
var attack_cooldown_timer = null
@export var BulletScene: PackedScene = load("res://scenes/bullet_androide.tscn")

const SPEED = 2.0

@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D

func _ready():
	player = get_node(player_path)
	
	# Crear el Timer y configurarlo
	attack_cooldown_timer = Timer.new()
	attack_cooldown_timer.wait_time = 3.0
	attack_cooldown_timer.one_shot = true
	attack_cooldown_timer.autostart = false
	add_child(attack_cooldown_timer)

	# Conectar la señal timeout
	attack_cooldown_timer.connect("timeout", Callable(self, "_on_attack_cooldown_timeout"))

func _process(delta):
	if dead:
		return
	if $AndroideAnimado.last_anim_finished() == 'death':
		dead = true
		can_move = false
		$AndroideAnimado.clear_last_anim_finished()
		return
		
	if $AndroideAnimado.last_anim_finished() == 'attack2':
		dead = false
		can_move = true
		attack = false
		$AndroideAnimado.clear_last_anim_finished()
	elif $AndroideAnimado.what_is_doing() != 'attack2':    
		attack = false
	
	if (not attack and not attacking):
		var distance = distance_to_player()
		
		if distance <= 7.0:
			shoot()

func distance_to_player():
	if player:
		return global_position.distance_to(player.global_position)
	return INF  # Devolver infinito si no hay jugador


func shoot():
	if not attacking and not attack:
		attacking = true     
		attack = true
		$AndroideAnimado.do("attack2")
		attack_cooldown_timer.start()
		
		await get_tree().create_timer(0.3).timeout

		if not BulletScene:
			print("BulletScene no asignada")
			return
		if $AndroideAnimado.what_is_doing() == 'attack2':
			var bullet = BulletScene.instantiate()

			# Obtener dirección de disparo (-Z del personaje)
			
			
			bullet.global_position = $Marker3D.global_position
			bullet.transform.basis = $Marker3D.global_transform.basis
			bullet.direction_value = -1.0
			#var direction = global_transform.basis.z.normalized()
			#bullet.direction = direction
			
			#var transform = Transform3D().looking_at($Aim3D.global_position + direction, Vector3.UP)
			get_parent().add_child(bullet)
	

func hit():
	life = life - 1
	if life == 0:
		dead = true
		$AndroideAnimado.do("death")

func _physics_process(delta):
	velocity = Vector3.ZERO
	if life > 0:
		#print(attacking, attack)
		if attacking and attack:
			$AndroideAnimado.do("attack2")
		elif looking or (not attack and attacking):
			$AndroideAnimado.do("idle2")
		else:
			nav_agent.set_target_position(player.global_position)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			if velocity.length() > 0: 
				$AndroideAnimado.do("walk")
				look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
			
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if "win" in body:
		looking = false


func _on_area_3d_body_exited(body: Node3D) -> void:
	if "win" in body:
		looking = true

func _on_attack_cooldown_timeout():
	attacking = false
