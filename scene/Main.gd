extends Node

var hud
var world
var player

func _ready():
	hud = $HUD
	world = $World
	world.generate_world_data()
	
	add_player(Vector3(0, 10, 0))
	player.update_position = player.translation
	player.has_control = false
	
	_update_hud()
	
	for x in range(-Data.settings['spawn_distance']['value'], Data.settings['spawn_distance']['value']):
		for z in range(-Data.settings['spawn_distance']['value'], Data.settings['spawn_distance']['value']):
			world.generate_chunk(x, z)

#func _process(delta):
#	var p = player.get_pos()
#	if (
#		(p.x >= 10+player.update_position.x or p.z >= 10+player.update_position.z) or
#		(p.x <= 10-player.update_position.x or p.z <= 10-player.update_position.z)
#		):
#		player.update_position = player.translation
#		update_tiles()

func update_tiles():
	var p = player.get_pos()
	var despawn = Data.settings['spawn_distance']['value']+1
	var spawn = Data.settings['spawn_distance']['value']
	
	for dx in range(-despawn, despawn):
		for dz in range(-despawn, despawn):
			world.destroy_chunk(floor((p.x)+dx), floor((p.z)+dz))
			
	for sx in range(-spawn, spawn):
		for sz in range(-spawn, spawn):
			world.generate_chunk(floor((p.x)+sx), floor((p.z)+sz))

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
	#player.mesh['body'] = Data.object['player']['mesh'][0]
	#player.set_held(Data.object['axestone']['mesh'][0])
	player.ready()
	add_child(player)
	player.connect('update_hud', self, '_update_hud')
	player.connect('update_cursor', self, '_update_cursor')
