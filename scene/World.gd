extends Spatial

var noise_fissure = OpenSimplexNoise.new()
var noise_moisture = OpenSimplexNoise.new()
var noise_temperature = OpenSimplexNoise.new()

func _ready():
	set_noise_values(noise_fissure, Data.settings['game_seed'].hash(), 32, 4, 2.0, 0.1)
	set_noise_values(noise_moisture, Data.settings['game_seed'].hash(), 32, 4, 2.0, 0.1)
	set_noise_values(noise_temperature, Data.settings['game_seed'].hash(), 32, 4, 2.0, 0.1)
	
	generate_chunk(0, 0)

func set_noise_values(n, sd, pd, oc, la, pr):
	n.seed = sd
	n.period = pd
	n.octaves = oc
	n.lacunarity = la
	n.persistence = pr

func generate_chunk(x, z):
	var fissure = noise_fissure.get_noise_2d(x, z)
	var moisture = noise_moisture.get_noise_2d(x, z)
	var temperature = noise_temperature.get_noise_2d(x, z)
	
	print(get_biome(fissure, 'fissure'))
	print(get_biome(moisture, 'moisture'))
	print(get_biome(temperature, 'temperature'))

func get_biome(v, t):
	for b in Data.biome:
		if v > Data.biome[b]['noise'][t]:
			return b
