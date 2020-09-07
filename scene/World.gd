extends Spatial

var noise_fissure = OpenSimplexNoise.new()
var noise_moisture = OpenSimplexNoise.new()
var noise_temperature = OpenSimplexNoise.new()

var data = {}

func _ready():
	set_noise_values(noise_fissure, Data.settings['game_seed'].hash(), 32, 4, 2.0, 0.1)
	set_noise_values(noise_moisture, Data.settings['game_seed'].hash(), 32, 4, 2.0, 0.1)
	set_noise_values(noise_temperature, Data.settings['game_seed'].hash(), 32, 4, 2.0, 0.1)
	generate_world_data()
	generate_chunk(0, 0)

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
	for x in range(Data.physics['world_size']*Data.physics['chunk_size']):
		for z in range(Data.physics['world_size']*Data.physics['chunk_size']):
			data['%s-%s' % [x, z]] = [
			noise_fissure.get_noise_2d(x, z),
			noise_moisture.get_noise_2d(x, z),
			noise_temperature.get_noise_2d(x, z)
			]

func generate_chunk(X, Z):
	var chunk = Data.physics['chunk_size']
	var size = Data.physics['tile_size']
	
	for x in range(chunk):
		for z in range(chunk):
			var Y = get_height(x, z)
			var offset = Vector2(X*chunk, Z*chunk)
			var tile
			var rot = Vector3()
			
			var n = get_height(x+offset.x, z-1+offset.y)
			var s = get_height(x+offset.x, z+1+offset.y)
			var e = get_height(x-1+offset.x, z+offset.y)
			var w = get_height(x+1+offset.x, z+offset.y)
			var ne = get_height(x-1+offset.x, z-1+offset.y)
			var nw = get_height(x+1+offset.x, z-1+offset.y)
			var se = get_height(x-1+offset.x, z+1+offset.y)
			var sw = get_height(x+1+offset.x, z+1+offset.y)
			
			if n and n > Y:
				tile = 'tilesidecave'; rot.y = 0
			elif s and s > Y:
				tile = 'tilesidevex'; rot.y = 180
			elif e and e > Y:
				tile = 'tilesidecave'; rot.y = 90
			elif w and w > Y:
				tile = 'tilesidevex'; rot.y = 270
			
			elif ne and ne > Y:
				tile = 'tilecave'; rot.y = 0
			elif nw and nw > Y:
				tile = 'tilevex'; rot.y = 180
			elif se and se > Y:
				tile = 'tilecave'; rot.y = 90
			elif sw and sw > Y:
				tile = 'tilevex'; rot.y = 270
			
			else:
				tile = 'tileflat'; rot.y = 0
			
			spawn(tile, Vector3((X*chunk)+(x*size), Y, (Z*chunk)+(z*size)), rot)

func get_height(x, z):
	if '%s-%s' % [x, z] in data:
		var y = data['%s-%s' % [x, z]][0] * Data.physics['max_height']
		y = clamp(y, -Data.physics['max_height'], Data.physics['max_height'])
		return round(y)

func get_biome(v, t):
	for b in Data.biome:
		if v > Data.biome[b]['noise'][t]:
			return b
