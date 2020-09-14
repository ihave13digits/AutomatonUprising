extends Node

var hud
var world
var player

func _ready():
	hud = $HUD
	world = $World
	world.generate_world_data()
	
	add_player(Vector3(0, 10, 0))
	player.has_control = false
	
	_update_hud()
	
	for x in range(-Data.settings['spawn_distance']['value'], Data.settings['spawn_distance']['value']):
		for z in range(-Data.settings['spawn_distance']['value'], Data.settings['spawn_distance']['value']):
			world.generate_chunk(x, z)

func update_tiles():
	var despawn = Data.settings['spawn_distance']['value']+1
	var spawn = Data.settings['spawn_distance']['value']
	
	for x in range(-despawn, despawn):
		for z in range(-despawn, despawn):
			world.kill_tile(floor(player.translation.x+x), floor(player.translation.z+z))
			
	for x in range(-spawn, spawn):
		for z in range(-spawn, spawn):
			world.generate_tile(floor(player.translation.x+x), floor(player.translation.z+z))

func _update_cursor():
	if player.cursor.get_collider() != null:
		hud.center_img.modulate = Color(1.0, 1.0, 1.0, Data.settings['hud_opacity']['value'])
	else:
		hud.center_img.modulate = Color(1.0, 1.0, 1.0, Data.settings['hud_opacity']['value']*0.5)

func _update_hud():
	if is_instance_valid(hud.current_menu):
		hud.current_menu.queue_free()
	
	if player.has_control:
		hud.update_center_image(Vector2(48, 48), Vector2(-24, -24), Data.texture['cursor_texture'])
	else:
		#hud.update_center_image(Vector2(256, 256), Vector2(-128, -128), Data.texture['menu_texture'])
		hud.current_menu = load(Data.instance['pause']).instance()
		hud.add_child(hud.current_menu)
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
