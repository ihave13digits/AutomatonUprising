extends Node

var hud
var world
var player

func _ready():
	add_player(Vector3(0, 10, 0))
	player.has_control = false
	hud = $HUD
	world = $World
	
	world.generate_world_data()
	for x in range(-Data.physics['world_size'], Data.physics['world_size']):
		for z in range(-Data.physics['world_size'], Data.physics['world_size']):
			world.generate_chunk(x, z)
#	world.generate_tile(0, 0)

func _update_cursor():
	if player.cursor.get_collider() != null:
		hud.center_img.modulate = Color(1.0, 1.0, 1.0, Data.settings['hud_opacity']['value'])
	else:
		hud.center_img.modulate = Color(1.0, 1.0, 1.0, Data.settings['hud_opacity']['value']*0.5)

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
	#player.set_held(Data.object['axestone']['mesh'][0])
	player.ready()
	add_child(player)
	player.connect('update_hud', self, '_update_hud')
	player.connect('update_cursor', self, '_update_cursor')
