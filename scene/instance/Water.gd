extends Spatial

var next = 'ebb%s' % str(randi() % 4)

func ready():
	play_next()

func play_next():
	if randi() % 100 < 25:
		next = 'ebb%s' % str(randi() % 4)
	else:
		next = 'ebb%s' % str((randi() % 2)+1)
	$AnimationPlayer.play(next)

func _on_AnimationPlayer_animation_finished(_anim_name):
	play_next()
