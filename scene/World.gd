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
	
	if n and s and e and w:

		if n < Y and s >= Y and e >= Y and w >= Y:
			tile = 'tileside'; rot.y = 90
		elif n >= Y and s < Y and e >= Y and w >= Y:
			tile = 'tileside'; rot.y = 270
		elif n >= Y and s >= Y and e < Y and w >= Y:
			tile = 'tileside'; rot.y = 180
		elif n >= Y and s >= Y and e >= Y and w < Y:
			tile = 'tileside'; rot.y = 0

		elif n < Y and s >= Y and e < Y and w >= Y:
			tile = 'tilecave'; rot.y = 180
		elif n < Y and s >= Y and e >= Y and w < Y:
			tile = 'tilecave'; rot.y = 90
		elif n >= Y and s < Y and e < Y and w >= Y:
			tile = 'tilecave'; rot.y = 270
		elif n >= Y and s < Y and e >= Y and w < Y:
			tile = 'tilecave'; rot.y = 0

		elif n <= Y and s > Y and e <= Y and w > Y:
			tile = 'tilevex'; rot.y = 180
		elif n <= Y and s > Y and e > Y and w <= Y:
			tile = 'tilevex'; rot.y = 90
		elif n > Y and s <= Y and e <= Y and w > Y:
			tile = 'tilevex'; rot.y = 270
		elif n > Y and s <= Y and e > Y and w <= Y:
			tile = 'tilevex'; rot.y = 0


#		elif n > Y and s == Y and e > Y and w == Y:
#			tile = 'tileflat'; rot.y = 0
#		elif n > Y and s == Y and e == Y and w > Y:
#			tile = 'tileflat'; rot.y = 0
#		elif n == Y and s > Y and e > Y and w == Y:
#			tile = 'tileflat'; rot.y = 0
#		elif n == Y and s > Y and e == Y and w > Y:
#			tile = 'tileflat'; rot.y = 0
		
#		elif n < Y and s == Y and e < Y and w == Y:
#			tile = 'tilecave'; rot.y = 180
#		elif n < Y and s == Y and e == Y and w < Y:
#			tile = 'tilecave'; rot.y = 90
#		elif n == Y and s < Y and e < Y and w == Y:
#			tile = 'tilecave'; rot.y = 270
#		elif n == Y and s < Y and e == Y and w < Y:
#			tile = 'tilecave'; rot.y = 0
		
#		elif n < Y and s == Y and e < Y and w == Y:
#			tile = 'tilevex'; rot.y = 180
#		elif n == Y and s > Y and e == Y and w < Y:
#			tile = 'tilevex'; rot.y = 90
#		elif n > Y and s == Y and e == Y and w > Y:
#			tile = 'tilevex'; rot.y = 270
#		elif n == Y and s < Y and e > Y and w == Y:
#			tile = 'tilevex'; rot.y = 0

	else:
		tile = 'tileflat'; rot.y = 0
	spawn(tile, Vector3(x*tile_size, Y, z*tile_size), rot)

func get_height(x, z):
	if '%s-%s' % [x, z] in data:
		var y = data['%s-%s' % [x, z]][0] * max_height
		return round(y)

func get_biome(v, t):
	for b in Data.biome:
		if v > Data.biome[b]['noise'][t]:
			return b
