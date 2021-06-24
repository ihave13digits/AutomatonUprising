extends Node

var env
var hud
var sun
var world
var player

var loading = false
var day = true
var time_scale = 10.5
var lighting = 1.0

func _ready():
	hud = $HUD
	world = $World
	sun = $DirectionalLight
	env = WorldEnvironment.new()
	env.set_environment(load("res://default_env.tres"))
	sun.rotation_degrees.x = 0
	$SafetyNet.translation.y = -Data.physics['max_height']
	var size = Data.physics['world_size']*Data.physics['chunk_size']*Data.physics['tile_size']*2
	$SafetyNet.scale = Vector3(size, size, size)
	ready_game()

func _physics_process(delta):
	_update_lighting(delta)
	_update_environment()
	_update_sky()
	world.update_chunks()

func ready_game():
	world.generate_world_data()
	
	add_player(Vector3(0, Data.physics['max_height'], 0))
	player.update_position = player.translation
	player.has_control = false
	
	_update_hud()
	
#	var spawn = Data.settings['spawn_distance']['value']
#	var chunk = Data.physics['chunk_size']
#	var cp = Vector2(int(player.get_pos().x/chunk), int(player.get_pos().z/chunk))
#
#	for x in range(-spawn, spawn+1):
#		for z in range(-spawn, spawn+1):
#			#world.load_queue.append(Vector2(x+(player.translation.x/Data.physics['chunk_size']), z+(player.translation.z/Data.physics['chunk_size'])))
#			world.generate_chunk(x+cp.x, z+cp.y)
	_update_spawn_distance(Data.settings['spawn_distance']['value'])
	_update_environment()

func _update_lighting(delta):
	sun.rotation_degrees.x += time_scale*delta
	env.environment.background_sky_rotation_degrees.x += time_scale*delta
	if sun.rotation_degrees.x > 360:
		sun.rotation_degrees.x -= 360
		env.environment.background_sky_rotation_degrees.x -= 360
	
	if day:
		lighting += (time_scale*delta)/180.0
	else:
		lighting -= (time_scale*delta)/180.0
	
	if lighting > 1:
		day = false
	if lighting < 0:
		day = true

func _update_sky():
	var l = float(lighting*1.5)
	var _l = lighting*lighting
	env.environment.fog_color = Color(_l*0.9, _l*0.95, _l, 0.5)
	env.environment.fog_sun_color = Color(l*0.6, l*0.3, l*0.1)
	
	env.environment.ambient_light_energy = lighting
	sun.light_energy = _l
	env.environment.background_sky.sky_curve = _l#lighting*0.08
	env.environment.background_sky.ground_curve = _l#lighting*0.08

func _update_spawn_distance(spawn_compare):
	var spawn = Data.settings['spawn_distance']['value']
	var chunk = Data.physics['chunk_size']
	var cp = Vector2(int(player.get_pos().x/chunk), int(player.get_pos().z/chunk))
	
	if spawn_compare >= Data.settings['spawn_distance']['value']:
		for x in range(-spawn_compare, spawn_compare+1):
			for z in range(-spawn_compare, spawn_compare+1):
				world.load_queue.append(Vector2(x+cp.x, z+cp.y))
	
	if spawn_compare < Data.settings['spawn_distance']['value']:
		for x in range(-spawn-1, spawn+2):
			for z in range(-spawn-1, spawn+2):
				world.destroy_chunk(x+cp.x, z+cp.y)
		
		for x in range(-spawn_compare, spawn_compare+1):
			for z in range(-spawn_compare, spawn_compare+1):
				world.load_queue.append(Vector2(x+cp.x, z+cp.y))
		player.has_control = false
	
	Data.settings['spawn_distance']['value'] = spawn_compare
	loading = true
	_update_environment()

func _update_environment():
	var p = player.get_pos()
	var W = float(world.get_water(p.x, p.z)/Data.physics['max_water'])*2.0
	var distance = Data.physics['chunk_size']*Data.settings['spawn_distance']['value']
	env.environment.fog_depth_end = distance*0.9*W
	env.environment.fog_depth_begin = distance*0.1*W
	env.environment.dof_blur_far_distance = distance*0.3
	env.environment.dof_blur_far_transition = distance*0.1

func _modify_chunk(pos, val):
	world.update_tile(pos.x, pos.z, val)

func _update_chunks():
	var spawn = Data.settings['spawn_distance']['value']
	var chunk = Data.physics['chunk_size']
	var cp = Vector2(int(player.get_pos().x/chunk), int(player.get_pos().z/chunk))
	var up = Vector2(int(player.update_position.x/chunk), int(player.update_position.z/chunk))
	var d = up-cp
	
	if d.x == -1:
		for i in range(-spawn, spawn+1):
			world.load_queue.append(Vector2(cp.x+spawn, i+cp.y))
		for i in range(-spawn, spawn+1):
			world.kill_queue.append(Vector2(up.x-spawn, i+up.y))
	if d.x == 1:
		for i in range(-spawn, spawn+1):
			world.load_queue.append(Vector2(cp.x-spawn, i+cp.y))
		for i in range(-spawn, spawn+1):
			world.kill_queue.append(Vector2(up.x+spawn, i+up.y))
	
	if d.y == -1:
		for i in range(-spawn, spawn+1):
			world.load_queue.append(Vector2(i+cp.x, cp.y+spawn))
		for i in range(-spawn, spawn+1):
			world.kill_queue.append(Vector2(i+up.x, up.y-spawn))
	if d.y == 1:
		for i in range(-spawn, spawn+1):
			world.load_queue.append(Vector2(i+cp.x, cp.y-spawn))
		for i in range(-spawn, spawn+1):
			world.kill_queue.append(Vector2(i+up.x, up.y+spawn))
	
	player.update_position.x = int(round(player.translation.x))
	player.update_position.z = int(round(player.translation.z))
	loading = true

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
	#player.set_held(Data.object['torch']['mesh'][0])
	player.ready()
	add_child(player)
	player.connect('update_hud', self, '_update_hud')
	player.connect('update_cursor', self, '_update_cursor')
	player.connect('update_chunks', self, '_update_chunks')
	player.connect('edit_chunk', self, '_modify_chunk')
