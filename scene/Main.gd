extends Node

var hud
var world
var player

func _ready():
	hud = $HUD
	world = $World
	ready_game()

func ready_game():
	world.generate_world_data()
	
	add_player(Vector3(0, 10, 0))
	player.update_position = player.translation
	player.has_control = false
	
	_update_hud()
	_update_chunks()

func _modify_chunk(pos, val):
	world.update_tile(pos.x, pos.z, val)

func _update_chunks():
	var p = player.get_pos()
	var despawn = Data.settings['spawn_distance']['value']
	var spawn = Data.settings['spawn_distance']['value']
	
	for dx in range(-despawn+p.x, despawn+p.x):
		for dz in range(-despawn+p.z, despawn+p.z):
			world.destroy_chunk(dx, dz)
	
	for dx in range(-spawn+p.x, spawn+p.x):
		for dz in range(-despawn+p.z, despawn+p.z):
			world.generate_chunk(dx, dz)


func _update_cursor():
	if player.cursor.get_collider() != null:
		hud.center_img.modulate = Color(1.0, 1.0, 1.0, Data.settings['hud_opacity']['value'])
	else:
		hud.center_img.modulate = Color(1.0, 1.0, 1.0, Data.settings['hud_opacity']['value']*0.5)

func _update_hud(menu=''):
	if is_instance_valid(hud.current_menu):
		hud.current_menu.queue_free()
	
	if player.has_control:
		hud.update_center_image(Vector2(48, 48), Vector2(-24, -24), Data.texture['cursor_texture'])
	else:
		if menu == "":
			hud.update_center_image(Vector2(128, 256), Vector2(-64, -128), Data.texture['menu_texture'])
			hud.current_menu = load(Data.instance['pause']).instance()
		if menu == "controls":
			hud.update_center_image(Vector2(256, 256), Vector2(-128, -128), Data.texture['menu_texture'])
			hud.current_menu = load(Data.instance['controls']).instance()
		if menu == "settings":
			hud.update_center_image(Vector2(288, 240), Vector2(-144, -120), Data.texture['menu_texture'])
			hud.current_menu = load(Data.instance['settings']).instance()
		
		hud.add_child(hud.current_menu)
	hud.center_img.modulate = Color(1.0, 1.0, 1.0, Data.settings['hud_opacity']['value'])

func add_player(pos):
	player = load(Data.instance['player']).instance()
	player.translation = pos
	player.mesh['body'] = Data.object['player']['mesh'][0]
	player.set_held(Data.object['pulsecannon']['mesh'][0])
	player.ready()
	add_child(player)
	player.connect('update_hud', self, '_update_hud')
	player.connect('update_cursor', self, '_update_cursor')
	player.connect('update_chunks', self, '_update_chunks')
	player.connect('edit_chunk', self, '_modify_chunk')
