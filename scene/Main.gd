extends Node

var env
var hud
var sun
var world
var player

var day = true
var time_scale = 10.1
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
	_update_sky()
	world.update_chunks()

func ready_game():
	world.generate_world_data()
	
	add_player(Vector3(0, Data.physics['max_height'], 0))
	player.update_position = player.translation
	player.has_control = false
	
	_update_hud()
	_update_chunks()

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
	env.environment.fog_color = Color(l*0.9, l*0.95, l, 0.5)
	env.environment.fog_sun_color = Color(l*0.6, l*0.3, l*0.1)
	
	env.environment.ambient_light_energy = lighting
	sun.light_energy = lighting*lighting

func _update_environment():
	var distance = Data.physics['chunk_size']*Data.settings['spawn_distance']['value']
	env.environment.fog_depth_end = distance*0.6
	env.environment.dof_blur_far_distance = distance*0.3
	#env.environment.dof_blur_far_transition = distance*0.1

func _modify_chunk(pos, val):
	world.update_tile(pos.x, pos.z, val)

func _update_chunks():
	var p = player.get_pos()
	var up =  player.update_position
	var spawn = int(Data.settings['spawn_distance']['value'])
	
	for dx in range(-spawn+up.x, spawn+up.x+1):
		for dz in range(-spawn+up.z, spawn+up.z+1):
			var v = Vector2(dx, dz)
			world.kill_queue.append(v)
	
	for dx in range(-spawn+p.x, spawn+p.x+1):
		for dz in range(-spawn+p.z, spawn+p.z+1):
			var v = Vector2(dx, dz)
			world.load_queue.append(v)
	
	player.update_position.x = int(round(player.translation.x))
	player.update_position.z = int(round(player.translation.z))

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
	player.set_held(Data.object['torch']['mesh'][0])
	player.ready()
	add_child(player)
	player.connect('update_hud', self, '_update_hud')
	player.connect('update_cursor', self, '_update_cursor')
	player.connect('update_chunks', self, '_update_chunks')
	player.connect('edit_chunk', self, '_modify_chunk')


func _on_SkyTick_timeout():
	pass
	#_update_sky()
	#$SkyTick.start()
