extends Node

var hud
var world
var player

func _ready():
	add_player(Vector3(0, 0, 0))
	hud = $HUD
	world = $World
	spawn('tileflat', Vector3(0, -10, 0))

func _process(_delta):
	if Input.is_action_just_pressed("ui_up"): hud.display_message('stacked popup test')
	if Input.is_action_just_pressed("ui_left"): hud.display_stats(player.data)
	if Input.is_action_just_pressed("ui_right"): hud.display_nutrition(player.nutrients)

func _update_hud():
	if player.has_control:
		hud.update_center_image(Vector2(48, 48), Vector2(-24, -24), Data.texture['cursor_texture'])
	else:
		hud.update_center_image(Vector2(128, 256), Vector2(-64, -128), Data.texture['menu_texture'])
	hud.center_img.modulate = Color(1.0, 1.0, 1.0, Data.settings['hud_opacity']['value'])

func add_player(pos):
	player = load(Data.instance['player']).instance()
	player.translation = pos
	#player.mesh['body'] = Data.object['player']['mesh'][0]
	player.set_held(Data.object['axestone']['mesh'][0])
	player.ready()
	add_child(player)
	player.connect('update_hud', self, '_update_hud')

func spawn(t, pos):
	var target = Data.object[t]
	var inst = target['instance'][0]
	var I = load(Data.instance[inst]).instance()
	I.translation = pos
	I.mesh['body'] = Data.object[t]['mesh'][0]
	add_child(I)
