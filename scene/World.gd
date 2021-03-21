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
	set_noise_values(noise_height, Data.settings['game_seed'].hash(), 32, 4, 2.0, 0.1)
	set_noise_values(noise_water, Data.settings['game_seed'].hash(), 64, 4, 5.0, 0.2)
	set_noise_values(noise_heat, Data.settings['game_seed'].hash(), 2048, 4, 2.0, 0.1)

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
			data[key]['height'] = floor(noise_height.get_noise_2d(x, z) * max_height)
			data[key]['water'] = abs(floor(noise_water.get_noise_2d(x, z) * max_water))
			data[key]['heat'] = abs(floor(noise_heat.get_noise_2d(x, z) * max_heat))

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

func spawn_object(t, pos, rot):
	var key = '%s-%s' % [int(pos.x/tile_size), int(pos.z/tile_size)]
	if data.has(key):
		var inst = Data.object[t]['instance'][0]
		var I = load(Data.instance[inst]).instance()
		
		I.translation = pos
		I.rotation_degrees = rot
		I.mesh['body'] = Data.object[t]['mesh'][0]
		I.id = t
		add_child(I)
		#data[key]['tile'] = I

func destroy_chunk(x, z):
	var despawn = Data.physics['chunk_size']
	
	for dx in range(-despawn+x, despawn+x):
		for dz in range(-despawn+z, despawn+z):
			destroy_tile(dx, z+dz)

func generate_chunk(x, z):
	var spawn = Data.physics['chunk_size']
	
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
				spawn_object(objects[object], Vector3(sx, Y, sz), Vector3(0, 0, 0))
			# End of fun stuff

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

func get_neighbors(x, z):
	var Y = get_height(x, z)
	return [
		get_height(x,z)-Y,
		get_height(x+1,z)-Y,
		get_height(x+1,z+1)-Y,
		get_height(x,z+1)-Y
		]

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
