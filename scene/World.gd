extends Spatial

var noise_fissure = OpenSimplexNoise.new()
var noise_moisture = OpenSimplexNoise.new()
var noise_temperature = OpenSimplexNoise.new()

func _ready():
	set_noise_values(noise_fissure, Data.settings['game_seed'].hash(), 32, 4, 2.0, 0.1)
	set_noise_values(noise_moisture, Data.settings['game_seed'].hash(), 32, 4, 2.0, 0.1)
	set_noise_values(noise_temperature, Data.settings['game_seed'].hash(), 32, 4, 2.0, 0.1)
	
	for x in range(2):
		for y in range(2):
			for z in range(2):
				generate_chunk(x*2, y*2, z*2)

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

func generate_chunk(x, y, z):
	var fissure = noise_fissure.get_noise_2d(x, z)
	var moisture = noise_moisture.get_noise_2d(x, z)
	var temperature = noise_temperature.get_noise_2d(x, z)
	
	print(get_biome(fissure, 'fissure'))
	print(get_biome(moisture, 'moisture'))
	print(get_biome(temperature, 'temperature'))
	
	var tile = 'tileflat'
	spawn(tile, Vector3(x, y, z))

func get_biome(v, t):
	for b in Data.biome:
		if v > Data.biome[b]['noise'][t]:
			return b
