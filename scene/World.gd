extends Spatial

var max_height
var world_size
var chunk_size
var tile_size

var noise_fissure = OpenSimplexNoise.new()
var noise_moisture = OpenSimplexNoise.new()
var noise_temperature = OpenSimplexNoise.new()

var data = {}

var mask = {
		'-1 -1 -1 0 0 0 0 0' : {'tile' : 'tilecave', 'rot' : 90},
		'0 -1 -1 -1 0 0 0 0' : {'tile' : 'tileside', 'rot' : 90},
		'0 0 -1 -1 -1 0 0 0' : {'tile' : 'tilecave', 'rot' : 180},
		'0 0 0 -1 -1 -1 0 0' : {'tile' : 'tileside', 'rot' : 180},
		'0 0 0 0 -1 -1 -1 0' : {'tile' : 'tilecave', 'rot' : 270},
		'0 0 0 0 0 -1 -1 -1' : {'tile' : 'tileside', 'rot' : 270},
		'-1 0 0 0 0 0 -1 -1' : {'tile' : 'tilecave', 'rot' : 0},
		'-1 -1 0 0 0 0 0 -1' : {'tile' : 'tileside', 'rot' : 0},
		'1 1 1 0 0 0 0 0' : {'tile' : 'tilevex', 'rot' : 270},
		'0 1 1 1 0 0 0 0' : {'tile' : 'tileside', 'rot' : 270},
		'0 0 1 1 1 0 0 0' : {'tile' : 'tilevex', 'rot' : 0},
		'0 0 0 1 1 1 0 0' : {'tile' : 'tileside', 'rot' : 0},
		'0 0 0 0 1 1 1 0' : {'tile' : 'tilevex', 'rot' : 90},
		'0 0 0 0 0 1 1 1' : {'tile' : 'tileside', 'rot' : 90},
		'1 0 0 0 0 0 1 1' : {'tile' : 'tilevex', 'rot' : 180},
		'1 1 0 0 0 0 0 1' : {'tile' : 'tileside', 'rot' : 180},
	}

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

func spawn(t, pos, rot):
	var target = Data.object[t]
	var inst = target['instance'][0]
	var I = load(Data.instance[inst]).instance()
	I.translation = pos
	I.rotation_degrees = rot
	I.mesh['body'] = Data.object[t]['mesh'][0]
	add_child(I)

func generate_world_data():
	for x in range(world_size*chunk_size):
		for z in range(world_size*chunk_size):
			data['%s-%s' % [x, z]] = [
			noise_fissure.get_noise_2d(x, z),
			noise_moisture.get_noise_2d(x, z),
			noise_temperature.get_noise_2d(x, z)
			]

func generate_chunk(X, Z):
	for x in range(int(X*chunk_size), int((X*chunk_size)+chunk_size)):
		for z in range(int(Z*chunk_size), int((Z*chunk_size)+chunk_size)):
			generate_tile(x, z)

func generate_tile(x, z):
	var Y = get_height(x, z)
	var tile = "tileflat"
	var rot = Vector3(0, 0, 0)

	var n = get_height(x, z-1)
	var s = get_height(x, z+1)
	var e = get_height(x-1, z)
	var w = get_height(x+1, z)
	var ne = get_height(x-1, z-1)
	var nw = get_height(x+1, z-1)
	var se = get_height(x-1, z+1)
	var sw = get_height(x+1, z+1)

	if !n: n = 0
	else: n -= Y
	if !s: s = 0
	else: s -= Y
	if !e: e = 0
	else: e -= Y
	if !w: w = 0
	else: w -= Y
	if !ne: ne = 0
	else: ne -= Y
	if !nw: nw = 0
	else: nw -= Y
	if !se: se = 0
	else: se -= Y
	if !sw: sw = 0
	else: sw -= Y

	var nbrs = '%s %s %s %s %s %s %s %s' % [w, nw, n, ne, e, se, s, sw]
	
	for b in mask:
		match nbrs:
			b :
				tile = mask[b]['tile']
				rot.y = mask[b]['rot']

	spawn(tile, Vector3(x*tile_size, Y, z*tile_size), rot)

func get_height(x, z):
	if '%s-%s' % [x, z] in data:
		var y = data['%s-%s' % [x, z]][0] * max_height
		return round(y)

func get_biome(v, t):
	for b in Data.biome:
		if v > Data.biome[b]['noise'][t]:
			return b
