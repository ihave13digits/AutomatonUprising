extends Spatial

var max_height
var max_water
var max_heat
var world_size
var chonk_size
var chunk_size
var tile_size

var noise_bump
var noise_height
var noise_water
var noise_heat

var kill_queue = []
var load_queue = []

var load_distance = []
var main_distance = Vector2()

var tile_kill_queue = []
var tile_load_queue = []

var data = {}
var objs = {}

func _ready():
	noise_bump = load(Data.noise['bump'])
	noise_height = load(Data.noise['height'])
	noise_water = load(Data.noise['water'])
	noise_heat = load(Data.noise['heat'])
	
	max_height = Data.physics['max_height']
	max_water = Data.physics['max_water']
	max_heat = Data.physics['max_heat']
	world_size = Data.physics['world_size']
	chonk_size = Data.physics['chonk_size']
	chunk_size = Data.physics['chunk_size']
	tile_size = Data.physics['tile_size']

	set_noise_values(
		noise_bump,
		Data.settings['game_seed']['value'].hash(),
		Data.physics['bump_scale'],
		Data.physics['bump_rough'],
		Data.physics['bump_gap'],
		Data.physics['bump_fade'])
	set_noise_values(
		noise_height,
		Data.settings['game_seed']['value'].hash(),
		Data.physics['height_scale'],
		Data.physics['height_rough'],
		Data.physics['height_gap'],
		Data.physics['height_fade'])
	set_noise_values(
		noise_heat,
		Data.settings['game_seed']['value'].hash(),
		Data.physics['heat_scale'],
		Data.physics['heat_rough'],
		Data.physics['heat_gap'],
		Data.physics['heat_fade'])
	set_noise_values(
		noise_water,
		Data.settings['game_seed']['value'].hash(),
		Data.physics['water_scale'],
		Data.physics['water_rough'],
		Data.physics['water_gap'],
		Data.physics['water_fade'])

func set_noise_values(n, sd, pd, oc, la, pr):
	n.seed = sd
	n.period = pd
	n.octaves = oc
	n.lacunarity = la
	n.persistence = pr

func generate_world_data():
	for x in range(-world_size*chunk_size, world_size*chunk_size):
		for z in range(-world_size*chunk_size, world_size*chunk_size):
			var key = '%s-%s' % [x, z]
			objs[key] = {}
			data[key] = {}
			
			objs[key]['tile'] = null
			objs[key]['debris'] = null
			objs[key]['object'] = null
			objs[key]['liquid'] = null
			
			var _h = floor((noise_height.get_noise_2d(x, z) * max_height)+(noise_bump.get_noise_2d(x, z) * max_height)/2)
			
			data[key]['height'] = _h
			data[key]['water'] = abs(floor(noise_water.get_noise_2d(x, z) * max_water))
			data[key]['heat'] = abs(floor(noise_heat.get_noise_2d(x, z) * max_heat))

# File I/O

func save_data(d, X, Z):
	var ox = X*chonk_size
	var oz = Z*chonk_size
	var f = File.new()
	f.open(d, File.WRITE)
	for x in range(chonk_size):
		for z in range(chonk_size):
			var key = "%s-%s" % [x+ox, z+oz]
			f.store_line(to_json(data[key]))
	f.close()

func load_data(d):
	var f = File.new()
	if f.file_exists(data):
		f.open(d, File.READ)
		for x in range():
			for z in range():
				var key = "%s-%s" % [x, z]
				data[key] = str(f.get_line())
		f.close()

# Chunks

func update_queue():
	if tile_kill_queue.size() > 0:
		destroy_cell(tile_kill_queue[0].x, tile_kill_queue[0].y)
		tile_kill_queue.pop_front()
		#return
	
	if tile_load_queue.size() > 0:
		generate_cell(tile_load_queue[0].x, tile_load_queue[0].y)
		tile_load_queue.pop_front()

func update_chunks():
	if kill_queue.size() > 0:
		destroy_chunk(kill_queue[0].x*Data.physics['chunk_size'], kill_queue[0].y*Data.physics['chunk_size'])
		kill_queue.pop_front()
		return
	
	if load_queue.size() > 0:
#		if load_distance.size():
#			var dx = abs(main_distance.x-load_distance[0].x)
#			var dz = abs(main_distance.y-load_distance[0].y)
#			if dx <= spawn && dz <= spawn:
		generate_chunk(load_queue[0].x*Data.physics['chunk_size'], load_queue[0].y*Data.physics['chunk_size'])
		load_queue.pop_front()

	if tile_kill_queue.size() == 0 && tile_load_queue.size() == 0:
		if get_parent().loading:
			get_parent().hud.display_message("Chunks Loaded")
			get_parent().player.has_control = true
		get_parent().loading = false
	update_queue()

func destroy_cell(x, z):
	destroy(Vector2(x, z), 'tile')
	destroy(Vector2(x, z), 'liquid')
	#destroy(Vector2(x, z), 'debris')
	destroy(Vector2(x, z), 'object')

func generate_cell(x, z):
	var key = '%s-%s' % [int(x/tile_size), int(z/tile_size)]
	if objs.has(key):
		if objs[key]['tile']:
			if is_instance_valid(objs[key]['tile']):
				return
	generate_tile(x, z)
	spawn_liquid(x, z)
	#spawn_debris(x, z)
	
	var chance = randi() % 100
	var water = "w%s" % str(get_water(x, z))
	var heat = "h%s" % str(get_heat(x, z))

	if chance < Data.biome[water][heat]['density']:
		var objects = Data.biome[water][heat]['spawn']
		var object = randi() % objects.size()
		var Y = get_height(x, z)
		spawn_object(objects[object], Vector3(x, Y, z), Vector3(0, randi()%360, 0))

func destroy_chunk(x, z):
	var despawn = int(Data.physics['chunk_size']/2)
	for dx in range(-despawn+x, despawn+x+1):
		for dz in range(-despawn+z, despawn+z+1):
			tile_kill_queue.push_back(Vector2(dx, dz))

func generate_chunk(x, z):
	var spawn = int(Data.physics['chunk_size']/2)
	var key = '%s-%s' % [int(x/tile_size), int(z/tile_size)]
	if objs.has(key):
		if objs[key]['tile']:
			if is_instance_valid(objs[key]['tile']):
				return
	for sx in range(-spawn+x, spawn+x+1):
		for sz in range(-spawn+z, spawn+z+1):
			tile_load_queue.push_front(Vector2(sx, sz))

func _destroy_chunk(x, z):
	var despawn = int(Data.physics['chunk_size']/2)
	for dx in range(-despawn+x, despawn+x+1):
		for dz in range(-despawn+z, despawn+z+1):
			destroy(Vector2(dx, dz), 'tile')
			destroy(Vector2(dx, dz), 'liquid')
			destroy(Vector2(dx, dz), 'debris')
			destroy(Vector2(dx, dz), 'object')

func _generate_chunk(x, z):
	var spawn = int(Data.physics['chunk_size']/2)
	var key = '%s-%s' % [int(x/tile_size), int(z/tile_size)]
	if objs.has(key):
		if objs[key]['tile']:
			if is_instance_valid(objs[key]['tile']):
				return
	for sx in range(-spawn+x, spawn+x+1):
		for sz in range(-spawn+z, spawn+z+1):
			generate_tile(sx, sz)
			spawn_liquid(sx, sz)
			spawn_debris(sx, sz)
			
			var chance = randi() % 100
			var water = "w%s" % str(get_water(sx, sz))
			var heat = "h%s" % str(get_heat(sx, sz))

			if chance < Data.biome[water][heat]['density']:
				var objects = Data.biome[water][heat]['spawn']
				var object = randi() % objects.size()
				var Y = get_height(sx, sz)
				spawn_object(objects[object], Vector3(sx, Y, sz), Vector3(0, randi()%360, 0))

func destroy_far_chunk(x, z):
	var despawn = int(Data.physics['chunk_size']/2)
	for dx in range(-despawn+x, despawn+x+1):
		for dz in range(-despawn+z, despawn+z+1):
			destroy(Vector2(dx, dz), 'tile')

func generate_far_chunk(x, z):
	var spawn = int(Data.physics['chunk_size']/2)
	for sx in range(-spawn+x, spawn+x+1):
		for sz in range(-spawn+z, spawn+z+1):
			generate_tile(sx, sz)

# Spawning

func spawn_tile(t, pos, mtrl='sand0'):
	var key = '%s-%s' % [int(pos.x/tile_size), int(pos.z/tile_size)]
	if objs[key]['tile']:
		if is_instance_valid(objs[key]['tile']):
			return

	var inst = Data.object[t]['instance'][0]
	var I = load(Data.instance[inst]).instance()
	I.translation = pos
	I.mesh['body'] = Data.object[t]['mesh'][0]
	I.id = t
	I.active = true
	I.set_material(mtrl)
	add_child(I)
	objs[key]['tile'] = I

func spawn_liquid(x, z):
	var key = '%s-%s' % [x, z]
	if objs[key]['liquid']:
		if is_instance_valid(objs[key]['liquid']):
			return
	if get_water(x, z) < 3:
		return
	var Y = Data.physics['sea_level']
	if get_height(x, z) > Y+1:
		var check = get_distant_neighbors(x, z)
		for i in range(4):
			if check[i] > Y:
				return
	
	var inst = Data.object['water']['instance'][0]
	var I = load(Data.instance[inst]).instance()
	I.translation = Vector3(x, Y, z)
	add_child(I)
	objs[key]['liquid'] = I

func spawn_debris(x, z):
	var key = '%s-%s' % [x, z]
	if objs[key]['debris']:
		if is_instance_valid(objs[key]['debris']):
			return
	
	var water = "w%s" % str(get_water(x, z))
	var heat = "h%s" % str(get_heat(x, z))
	if Data.biome[water][heat]['debris'] != '':
		var d = Data.biome[water][heat]['debris']
		var inst = Data.object[d]['instance'][0]
		var I = load(Data.instance[inst]).instance()
		var Y = get_height(x, z)
		
		I.translation = Vector3(x, Y, z)
		I.data['density'] = Data.object[d]['plant']['density']
		I.mesh['body'] = Data.object[d]['mesh'][randi() % Data.object[d]['mesh'].size()]
		I.id = d
		add_child(I)
		objs[key]['liquid'] = I

func spawn_object(t, pos, rot):
	var key = '%s-%s' % [int(pos.x/tile_size), int(pos.z/tile_size)]
	if objs[key]['object']:
		if is_instance_valid(objs[key]['object']):
			return
	
	var inst = Data.object[t]['instance'][0]
	var I = load(Data.instance[inst]).instance()
	var s = ((randi() % 50) + 50) * 0.01
	
	I.translation = pos
	I.rotation_degrees = rot
	I.mesh['body'] = Data.object[t]['mesh'][randi() % Data.object[t]['mesh'].size()]
	I.scale = Vector3(s, s, s)
	I.id = t
	add_child(I)
	objs[key]['object'] = I

# Terrain

func destroy(P, T):
	var key = '%s-%s' % [P.x, P.y]
	if objs.has(key):
		if is_instance_valid(objs[key][T]):
			objs[key][T].queue_free()
			objs[key][T] = null

func generate_tile(x, z, update = false):
	var H = get_heat(x, z)
	var W = get_water(x, z)
	var value = get_cell_value(x, z, update)
	var tile = 'tile%s' % value[0]
	var Y = get_height(x, z) - value[1]
	var soil_type = 'soil'
	if Data.biome["w%s" % W]["h%s" % H]['soil'] != '':
		soil_type = Data.biome["w%s" % W]["h%s" % H]['soil']
	var mtrl = '%s%s' % [soil_type, int((abs(Y) + (abs(W)*3)) / 4)]
	spawn_tile(tile, Vector3(x*tile_size, Y, z*tile_size), mtrl)

func update_tile(x, z, val):
	var key = '%s-%s' % [int(x/tile_size), int(z/tile_size)]
	
	for j in range(-1, 2):
		for i in range(-1, 2):
			var check = '%s-%s' % [int(x+i/tile_size), int(z+j/tile_size)]
			if data.has(check):
				if abs(val+data[key]['height'] - data[check]['height']) > 1:
					return
	data[key]['height'] += val
	
	for j in range(-1, 2):
		for i in range(-1, 2):
			destroy(Vector2(x+i, z+j), 'tile')
	
	for j in range(-1, 2):
		for i in range(-1, 2):
			generate_tile(x+i, z+j, true)

# Neighbor Cells

func get_cell_value(x, z, update = false):
	var key = '%s-%s' % [int(x/tile_size), int(z/tile_size)]
	if objs.has(key):
		if objs[key].has('value'):
			if !update:
				return objs[key]['value']
	var Y = get_height(x, z)
	
	var a = (get_height(x,z)-Y)*8
	var b = (get_height(x+1,z)-Y)*4
	var c = (get_height(x+1,z+1)-Y)*2
	var d = (get_height(x,z+1)-Y)*1
	
	a = clamp(a, -8, 8)
	b = clamp(b, -4, 4)
	c = clamp(c, -2, 2)
	d = clamp(d, -1, 1)
	
	var sum = a+b+c+d
	var rtrn = [15-abs(sum), 1]
	if sum > 0:
		rtrn = [abs(sum), 0]
	if objs.has(key):
		objs[key]['value'] = rtrn
	return rtrn

func get_neighbors(x, z):
	var Y = get_height(x, z)
	return [
		get_height(x,z)-Y,
		get_height(x+1,z)-Y,
		get_height(x+1,z+1)-Y,
		get_height(x,z+1)-Y
		]

func get_distant_neighbors(x, z):
	var Y = get_height(x, z)
	return [
		get_height(x-1,z)-Y, get_height(x+1,z)-Y, get_height(x,z-1)-Y, get_height(x,z+1)-Y,
		get_height(x-2,z-2)-Y, get_height(x+2,z-2)-Y, get_height(x-2,z+2)-Y, get_height(x+2,z+2)-Y,
		get_height(x-2,z)-Y, get_height(x+2,z)-Y, get_height(x,z-2)-Y, get_height(x,z+2)-Y
		]

# Noise

func get_height(x, z):
	var key = '%s-%s' % [x, z]
	if key in data:
		var y = data[key]['height']
		return floor(y)
	else:
		return 0

func get_water(x, z):
	var key = '%s-%s' % [x, z]
	if key in data:
		var y = data[key]['water']
		return floor(y)
	else:
		return 0

func get_humidity(x, z):
	return noise_water.get_noise_2d(x, z)

func get_heat(x, z):
	var key = '%s-%s' % [x, z]
	if key in data:
		var y = data[key]['heat']
		return floor(y)
	else:
		return 0
