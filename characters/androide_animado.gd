extends Node3D
var sLastAnimationFinished = ""

@onready var playback:AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

func do(sAnim):
	playback.travel(sAnim)
	
func movement(vector):
	$AnimationTree.set("parameters/rundirection/blend_position", vector)

	
func what_is_doing():
	return playback.get_current_node()

func clear_last_anim_finished():
	sLastAnimationFinished = ""

func last_anim_finished():
	return sLastAnimationFinished

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	sLastAnimationFinished = anim_name


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	sLastAnimationFinished = anim_name

func get_state():
	return playback.get_current_node()
