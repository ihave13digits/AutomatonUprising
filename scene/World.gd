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

func spawn(t, pos):
	var target = Data.object[t]
	var inst = target['instance'][0]
	var I = load(Data.instance[inst]).instance()
	I.translation = pos
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
	print(data)

func generate_chunk(X, Z):
	var chunk = Data.physics['chunk_size']
	var size = Data.physics['tile_size']
	var tile = 'tileflat'
	for x in range(chunk):
		for z in range(chunk):
			var y = data['%s-%s' % [x, z]][0] * Data.physics['max_height']
			y = clamp(y, -Data.physics['max_height'], Data.physics['max_height'])
			spawn(tile, Vector3((X*chunk)+(x*size), round(y), (Z*chunk)+(z*size)))

func get_biome(v, t):
	for b in Data.biome:
		if v > Data.biome[b]['noise'][t]:
			return b
