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
	'tilecave' : [-1,-1,-1, 0, 0, 0, 0, 0 ],
	'tileflat' : [ 0, 0, 0, 0, 0, 0, 0, 0 ],
	'tileside' : [ 0, 0, 0, 1, 1, 1, 0, 0 ],
	'tilevert' : [-1,-1,-1, 0, 1, 1, 1, 0 ],
	'tilevex' : [ 0, 0, 0, 0, 1, 1, 1, 0 ]
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
	if '%s-%s' % [int(pos.x/tile_size), int(pos.z/tile_size)] in data:
		var target = Data.object[t]
		var inst = target['instance'][0]
		var I = load(Data.instance[inst]).instance()
		I.translation = pos
		I.rotation_degrees = rot
		I.mesh['body'] = Data.object[t]['mesh'][0]
		I.id = t
		add_child(I)
		data['%s-%s' % [int(pos.x/tile_size), int(pos.z/tile_size)]]['tile'] = I

func generate_world_data():
	for x in range(-world_size*chunk_size, world_size*chunk_size):
		for z in range(-world_size*chunk_size, world_size*chunk_size):
			data['%s-%s' % [x, z]] = {}
			data['%s-%s' % [x, z]]['value'] = [
			noise_fissure.get_noise_2d(x, z),
			noise_moisture.get_noise_2d(x, z),
			noise_temperature.get_noise_2d(x, z)
			]

func generate_chunk(X, Z):
	for x in range(int(X*chunk_size), int((X*chunk_size)+chunk_size)):
		for z in range(int(Z*chunk_size), int((Z*chunk_size)+chunk_size)):
			generate_tile(x, z)

func kill_tile(x, z):
	if '%s-%s' % [x/tile_size, z/tile_size] in data and 'tile' in data['%s-%s' % [x/tile_size, z/tile_size]]:
		if is_instance_valid(data['%s-%s' % [x/tile_size, z/tile_size]]['tile']):
			data['%s-%s' % [x/tile_size, z/tile_size]]['tile'].queue_free()

func generate_tile(x, z):
	var oriented = false
	var Y = get_height(x, z)
	var nbrs = get_neighbors(x, z)
	var tile = "tileflat"
	var rot = Vector3(0, 0, 0)

	for i in range(4):
		var to_check = rotate_mask(mask['tileside'], i)
		if (
			(to_check[0]==nbrs[0] && to_check[1]<=nbrs[1] && to_check[2]<=nbrs[2] && to_check[3]<=nbrs[3] &&
			to_check[4]==nbrs[4] && to_check[5]==nbrs[5] && to_check[6]>=nbrs[6] && to_check[7]==nbrs[7])
		):
			tile = 'tileside'; rot.y = (i * 90); oriented = true
	if !oriented:
		for i in range(4):
			var to_check = rotate_mask(mask['tilecave'], i)
			if (
				(to_check[0]>=nbrs[0] && to_check[1]==nbrs[1] && to_check[2]==nbrs[2] && to_check[3]<=nbrs[3] &&
				to_check[4]==nbrs[4] && to_check[5]==nbrs[5] && to_check[6]>=nbrs[6] && to_check[7]>=nbrs[7])
			):
				tile = 'tilecave'; rot.y = (i * 90); oriented = true
	if !oriented:
		for i in range(4):
			var to_check = rotate_mask(mask['tilevex'], i)
			if (
				(to_check[0]==nbrs[0] && to_check[1]==nbrs[1] && to_check[2]<=nbrs[2] && to_check[3]<=nbrs[3] &&
				to_check[4]<=nbrs[4] && to_check[5]==nbrs[5] && to_check[6]>=nbrs[6] && to_check[7]==nbrs[7])
			):
				tile = 'tilevex'; rot.y = (i * 90); oriented = true
	if !oriented:
		for i in range(4):
			var to_check = rotate_mask(mask['tilevert'], i)
			if (
				(to_check[0]<=nbrs[0] && to_check[1]==nbrs[1] && to_check[2]>=nbrs[2] && to_check[3]>=nbrs[3] &&
				to_check[4]>=nbrs[4] && to_check[5]==nbrs[5] && to_check[6]<=nbrs[6] && to_check[7]<=nbrs[7])
			):
				tile = 'tilevert'; rot.y = (i * 90); oriented = true

	spawn(tile, Vector3(x*tile_size, Y, z*tile_size), rot)

func rotate_mask(nbrs, rot):
	var new_nbrs = nbrs.duplicate()
	
	for _i in range(rot*2):
		new_nbrs.append(new_nbrs[0])
		new_nbrs.remove(0)
	#return '%s %s %s %s %s %s %s %s' % new_nbrs
	return new_nbrs

func get_neighbors(x, z):
	var Y = get_height(x, z)
	return [
	get_height(x+1, z) - Y,
	get_height(x+1, z+1) - Y,
	get_height(x, z+1) - Y,
	get_height(x-1, z+1) - Y,
	get_height(x-1, z) - Y,
	get_height(x-1, z-1) - Y,
	get_height(x, z-1) - Y,
	get_height(x+1, z-1) - Y,
	]
	#return [w,sw,s,se,e,ne,n,nw]

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
