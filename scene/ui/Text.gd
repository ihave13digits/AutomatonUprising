extends Label

var direction
var stack

func duration(t:float, b):
	$Timer.wait_time = t
	$Timer.start()
	stack = b

func prepare_text(txt, aln, size):
	text = str(txt)
	align_text(aln)
	var name
	var font
	
	match size:
		8:
			name = ""; font = load("")
	
	name = "%s%s" % [name, Data.settings['font_name']]
	add_font_override(name, font)

func align_text(aln):
	match aln:
		'center':
			align = Label.ALIGN_CENTER; grow_horizontal = Control.GROW_DIRECTION_BOTH;
		'fill':
			align = Label.ALIGN_FILL; grow_horizontal = Control.GROW_DIRECTION_BOTH;
		'left':
			align = Label.ALIGN_LEFT; grow_horizontal = Control.GROW_DIRECTION_BEGIN;
		'right':
			align = Label.ALIGN_RIGHT; grow_horizontal = Control.GROW_DIRECTION_END;

func _on_Anim_animation_finished(_anim_name):
	queue_free()

func _on_Timer_timeout():
	$Anim.play("fade")
	var tween = find_node('Tween')
	tween.interpolate_property(self, 'rect_position', rect_position, rect_position+direction, 1.0, Tween.TRANS_LINEAR); tween.start()
	if stack and get_parent().has_method('display_message'):
		get_parent().message_count -= 1
