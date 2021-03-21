extends Spatial

var max_height
var world_size
var chunk_size
var tile_size

var noise_fissure = OpenSimplexNoise.new()
var noise_moisture = OpenSimplexNoise.new()
var noise_temperature = OpenSimplexNoise.new()

var data = {}

func _ready():
	max_height = Data.physics['max_height']
	world_size = Data.physics['world_size']
	chunk_size = Data.physics['chunk_size']
	tile_size = Data.physics['tile_size']
	set_noise_values(noise_fissure, Data.settings['game_seed'].hash(), 32, 4, 2.0, 0.1)
	set_noise_values(noise_moisture, Data.settings['game_seed'].hash(), 32, 4, 2.0, 0.1)
	set_noise_values(noise_temperature, Data.settings['game_seed'].hash(), 32, 4, 2.0, 0.1)

func set_noise_values(n, sd, pd, oc, la, pr):
	n.seed = sd
	n.period = pd
	n.octaves = oc
	n.lacunarity = la
	n.persistence = pr

func spawn_tile(t, pos):
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

func generate_world_data():
	for x in range(-world_size*chunk_size, world_size*chunk_size):
		for z in range(-world_size*chunk_size, world_size*chunk_size):
			var key = '%s-%s' % [x, z]
			data[key] = {}
			data[key]['tile'] = null
			data[key]['value'] = [
			floor(noise_fissure.get_noise_2d(x, z) * max_height),
			#noise_moisture.get_noise_2d(x, z),
			#noise_temperature.get_noise_2d(x, z)
			]

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
			var chance = randi() % 100
			if chance < 5:
				var objects = [
				# Materials
				'boulder','boulder','boulder',
				'stone','stone','stone','stone','stone','stone','stone','stone','stone',
				# Plants
				#'amaranth',
				'greenonion',
				#'watercress',
				'cattail',
				#'purslane',
				'bush','bush','bush',
				'treeash',
				'treeoak',
				'treepine'
				]
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

	spawn_tile(tile, Vector3(x*tile_size, Y, z*tile_size))

func update_tile(x, z, val):
	var key = '%s-%s' % [int(x/tile_size), int(z/tile_size)]
	
	for j in range(-1, 2):
		for i in range(-1, 2):
			var check = '%s-%s' % [int(x+i/tile_size), int(z+j/tile_size)]
			if abs(val+data[key]['value'][0] - data[check]['value'][0]) > 1:
				return
	data[key]['value'][0] += val
	
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
		var y = data[key]['value'][0]# * max_height
		return floor(y)
	else:
		return 0

func get_biome(v, t):
	for b in Data.biome:
		if v > Data.biome[b]['noise'][t]:
			return b
