extends Spatial

var max_height
var max_water
var max_heat
var world_size
var chunk_size
var tile_size

var noise_height = OpenSimplexNoise.new()
var noise_water = OpenSimplexNoise.new()
var noise_heat = OpenSimplexNoise.new()

var data = {}

func _ready():
	max_height = Data.physics['max_height']
	max_water = Data.physics['max_water']
	max_heat = Data.physics['max_heat']
	world_size = Data.physics['world_size']
	chunk_size = Data.physics['chunk_size']
	tile_size = Data.physics['tile_size']
	set_noise_values(noise_height, Data.settings['game_seed'].hash(), Data.physics['height_scale'], 4, 2.0, 0.1)
	set_noise_values(noise_water, Data.settings['game_seed'].hash(), Data.physics['water_scale'], 4, 5.0, 0.2)
	set_noise_values(noise_heat, Data.settings['game_seed'].hash(), Data.physics['heat_scale'], 4, 2.0, 0.1)

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
			data[key] = {}
			data[key]['tile'] = null
			data[key]['debris'] = null
			data[key]['object'] = null
			data[key]['liquid'] = null
			data[key]['height'] = floor(noise_height.get_noise_2d(x, z) * max_height)
			data[key]['water'] = abs(floor(noise_water.get_noise_2d(x, z) * max_water))
			data[key]['heat'] = abs(floor(noise_heat.get_noise_2d(x, z) * max_heat))

# Spawning

func spawn_tile(t, pos, mtrl='soil0'):
	var key = '%s-%s' % [int(pos.x/tile_size), int(pos.z/tile_size)]
	if data.has(key):
		if data[key]['tile']:
			if is_instance_valid(data[key]['tile']):
				return

		var inst = Data.object[t]['instance'][0]
		var I = load(Data.instance[inst]).instance()
		I.translation = pos
		I.mesh['body'] = Data.object[t]['mesh'][0]
		I.id = t
		I.active = true
		I.set_material(mtrl)
		add_child(I)
		data[key]['tile'] = I

func spawn_water(x, z):
	var key = '%s-%s' % [x, z]
	if data.has(key):
		if data[key]['liquid']:
			if is_instance_valid(data[key]['liquid']):
				return
	
	var Y = Data.physics['sea_level']
	if get_water(x, z) < 2:
		return
	if get_height(x, z) > Y+1:
		for i in range(4):
			if get_distant_neighbors(x, z)[i] > Y:
				return
	
	var inst = Data.object['water']['instance'][0]
	var I = load(Data.instance[inst]).instance()
	I.translation = Vector3(x, Y, z)
	add_child(I)
	data[key]['liquid'] = I

func spawn_debris(x, z):
	var key = '%s-%s' % [x, z]
	if data.has(key):
		if data[key]['debris']:
			if is_instance_valid(data[key]['debris']):
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
			data[key]['debris'] = I

func spawn_object(t, pos, rot):
	var key = '%s-%s' % [int(pos.x/tile_size), int(pos.z/tile_size)]
	if data.has(key):
		if data[key]['object']:
			if is_instance_valid(data[key]['object']):
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
		data[key]['object'] = I

# Chunks

func destroy_chunk(x, z):
	var despawn = int(Data.physics['chunk_size']/2)
	
	for dx in range(-despawn+x, despawn+x):
		for dz in range(-despawn+z, despawn+z):
			destroy_tile(dx, dz)
			destroy_water(dx, dz)
			destroy_object(dx, dz)
			destroy_debris(dx, dz)

func generate_chunk(x, z):
	var spawn = int(Data.physics['chunk_size']/2)
	
	for sx in range(-spawn+x, spawn+x):
		for sz in range(-spawn+z, spawn+z):
			generate_tile(sx, sz)
			
			# Just for fun
			var Y = get_height(sx, sz)
			var chance = randi() % 1000
			var water = "w%s" % str(get_water(sx, sz))
			var heat = "h%s" % str(get_heat(sx, sz))
			
			if chance < Data.biome[water][heat]['density']:
				var objects = Data.biome[water][heat]['spawn']
				var object = randi() % objects.size()
				spawn_object(objects[object], Vector3(sx, Y, sz), Vector3(0, randi()%360, 0))
			spawn_water(sx, sz)
			spawn_debris(sx, sz)
			# End of fun stuff

# Terrain

func destroy_object(x, z):
	var key = '%s-%s' % [x, z]
	if data.has(key):
		if is_instance_valid(data[key]['object']):
			data[key]['object'].queue_free()
			data[key]['object'] = null

func destroy_debris(x, z):
	var key = '%s-%s' % [x, z]
	if data.has(key):
		if is_instance_valid(data[key]['debris']):
			data[key]['debris'].queue_free()
			data[key]['debris'] = null

func destroy_water(x, z):
	var key = '%s-%s' % [x, z]
	if data.has(key):
		if is_instance_valid(data[key]['water']):
			data[key]['water'].queue_free()
			data[key]['water'] = null

func destroy_tile(x, z):
	var key = '%s-%s' % [x, z]
	if data.has(key):
		if is_instance_valid(data[key]['tile']):
			data[key]['tile'].queue_free()
			data[key]['tile'] = null

func generate_tile(x, z):
	var W = get_water(x, z)
	var Y = get_height(x, z)
	var nbrs = get_neighbors(x, z)
	var found = false
	
	var value = 0
	
	if nbrs[0] == 1:
		value += 8
		found = true
	if nbrs[1] == 1:
		value += 4
		found = true
	if nbrs[2] == 1:
		value += 2
		found = true
	if nbrs[3] == 1:
		value += 1
		found = true
	
	if !found:
		if nbrs[0] == -1: value += 8
		if nbrs[1] == -1: value += 4
		if nbrs[2] == -1: value += 2
		if nbrs[3] == -1: value += 1
		
		value = 15 - value
		Y -= 1
	
	var tile = 'tile%s' % value
	var mtrl = 'soil%s' % int((abs(Y) + (abs(W)*3)) / 4)
	if Y < Data.physics['bedrock_level']:
		mtrl = 'stone'

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
			destroy_tile(x+i, z+j)
	
	for j in range(-1, 2):
		for i in range(-1, 2):
			generate_tile(x+i, z+j)

# Neighbor Cells

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

func get_heat(x, z):
	var key = '%s-%s' % [x, z]
	if key in data:
		var y = data[key]['heat']
		return floor(y)
	else:
		return 0
