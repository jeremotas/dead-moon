extends Node3D
var sLastAnimationFinished = ""

func play_anim(sAnim):
	$AnimationPlayer.play(sAnim)

func clear_last_anim_finished():
	sLastAnimationFinished = ""

func last_anim_finished():
	return sLastAnimationFinished

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	sLastAnimationFinished = anim_name
