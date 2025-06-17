extends CharacterBody3D
var life = 1
var dead = false
var can_move = true
var player = null
var looking = true

const SPEED = 3.0

@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D

func _ready():
	player = get_node(player_path)

func _process(delta):
	if dead:
		return
	if $AndroideAnimado.last_anim_finished() == 'death':
		dead = true
		can_move = false
		$AndroideAnimado.clear_last_anim_finished()
		return
	

func hit():
	life = life - 1
	if life == 0:
		dead = true
		$AndroideAnimado.do("death")

func _physics_process(delta):
	velocity = Vector3.ZERO
	if life > 0:
		#print("looking", looking)
		if looking: 
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
	print("Enter", body)
	if "win" in body:
		looking = false


func _on_area_3d_body_exited(body: Node3D) -> void:
	print("Exit", body)
	if "win" in body:
		looking = true
