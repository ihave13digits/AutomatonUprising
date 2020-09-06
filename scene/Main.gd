extends Node

var hud
var world
var player

func _ready():
	add_player()
	hud = $HUD
	world = $World

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

func add_player():
	player = spawn('player')
	player.mesh['body'] = Data.object['player']['mesh'][0]
	#player.set_held(Data.object['axestone']['mesh'][0])
	player.ready()
	add_child(player)
	player.connect('update_hud', self, '_update_hud')

func mesh(m, pos=null):
	var M = load(Data.object[m]['mesh'][0])
	if !pos:
		return M
	else:
		var mdt = MeshDataTool.new()
		mdt.create_from_surface(M, 0)
		for v in range(mdt.get_vertex_count()):
			var vrt = mdt.get_vertex(v)
			vrt.set_vertex_uv(pos)
		mdt.commit_to_surface(M)
		return M

func spawn(i):
	var I = load(Data.instance[i])
	return I.instance()
