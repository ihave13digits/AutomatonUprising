extends CanvasLayer

var center_img
var size
var message_count

func _ready():
	center_img = $Center/Img
	center_img.modulate = Color(1.0, 1.0, 1.0, Data.settings['hud_opacity']['value'])
	size = Data.settings['message_font']['value']
	message_count = 0

func update_center_image(sz, ps, tx):
	center_img.rect_size = sz
	center_img.rect_position = ps
	center_img.texture = load(tx)

func popup(pos, dir, txt, aln, dur, stack):
	var text = load(Data.instance['text']).instance()
	add_child(text)
	text.rect_position = pos
	text.direction = dir
	text.prepare_text(txt, aln, size)
	text.duration(dur, stack)
	if stack:
		message_count += 1

func popups(pos, dir, data, aln, dur, stack):
	var count = 0
	for d in data:
		var txt = '%s: %s' % [d, data[d]]
		popup(Vector2(0, count*size)+pos, dir, txt, aln, dur, stack)
		count += 1

func display_message(txt):
	popup(Vector2(0, message_count*size), Vector2(0, -size), txt, 'center', 1.5, true)

func display_stats(data):
	popups(Vector2(0, 0), Vector2(-128, 0), data, 'left', 3.0, false)

func display_nutrition(data):
	popups(Vector2(0, 0), Vector2(128, 0), data, 'right', 3.0, false)
