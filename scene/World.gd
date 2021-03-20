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

func spawn(t, pos, rot=Vector3(0,0,0)):
	var key = '%s-%s' % [int(pos.x/tile_size), int(pos.z/tile_size)]
	if data[key]['tile']:
		if is_instance_valid(data[key]['tile']):
			return
	
	var target = Data.object[t]
	var inst = target['instance'][0]
	var I = load(Data.instance[inst]).instance()
	I.translation = pos
	I.rotation_degrees = rot
	I.mesh['body'] = Data.object[t]['mesh'][0]
	I.id = t
	I.active = true
	add_child(I)
	data[key]['tile'] = I

func generate_world_data():
	for x in range(-world_size*chunk_size, world_size*chunk_size):
		for z in range(-world_size*chunk_size, world_size*chunk_size):
			data['%s-%s' % [x, z]] = {}
			data['%s-%s' % [x, z]]['tile'] = null
			data['%s-%s' % [x, z]]['value'] = [
			noise_fissure.get_noise_2d(x, z),
			noise_moisture.get_noise_2d(x, z),
			noise_temperature.get_noise_2d(x, z)
			]

func destroy_tile(x, z):
	if is_instance_valid(data['%s-%s' % [x, z]]['tile']):
		data['%s-%s' % [x, z]]['tile'].queue_free()

func generate_tile(x, z):
	var Y = get_height(x, z)
	var nbrs = get_neighbors(x, z)
	var found = false
	
	var value = 0
	
	if nbrs[0] > 0:
		value += 8
		found = true
	if nbrs[1] > 0:
		value += 4
		found = true
	if nbrs[2] > 0:
		value += 2
		found = true
	if nbrs[3] > 0:
		value += 1
		found = true
	
	if !found:
		if nbrs[0] < 0: value += 8
		if nbrs[1] < 0: value += 4
		if nbrs[2] < 0: value += 2
		if nbrs[3] < 0: value += 1
		
		value = 15 - value
		Y -= 1
	
	var tile = 'tile%s' % value

	spawn(tile, Vector3(x*tile_size, Y, z*tile_size))

func get_neighbors(x, z):
	var Y = get_height(x, z)
	return [
		get_height(x,z)-Y,
		get_height(x+1,z)-Y,
		get_height(x+1,z+1)-Y,
		get_height(x,z+1)-Y
		]

func get_height(x, z):
	if '%s-%s' % [x, z] in data:
		var y = data['%s-%s' % [x, z]]['value'][0] * max_height
		return floor(y)
	else:
		return 0

func get_biome(v, t):
	for b in Data.biome:
		if v > Data.biome[b]['noise'][t]:
			return b
