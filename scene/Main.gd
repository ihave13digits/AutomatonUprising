extends Node

var hud
var world
var player

func _ready():
	add_player()
	hud = $HUD
	#hud.cursor.position = OS.get_real_window_size() / 2

func _process(_delta):
	if Input.is_action_just_pressed("ui_up"): hud.display_message('stacked popup test')
	if Input.is_action_just_pressed("ui_left"): hud.display_stats(player.data)
	if Input.is_action_just_pressed("ui_right"): hud.display_nutrition(player.nutrients)

func _update_hud():
	if player.has_control:
		hud.cursor.texture = load(Data.texture['cursor_texture'])
	else:
		hud.cursor.texture = load(Data.texture['menu_texture'])
	hud.cursor.position = Vector2()

func add_player():
	player = spawn('player')
	player.mesh['body'] = Data.object['player']['mesh'][0]
	#player.set_held(Data.object['axestone']['mesh'][0])
	player.ready()
	add_child(player)
	player.connect('update_hud', self, '_update_hud')

func mesh(m):
	var M = load(Data.object[m]['mesh'][0])
	return M

func spawn(i):
	var I = load(Data.instance[i])
	return I.instance()
