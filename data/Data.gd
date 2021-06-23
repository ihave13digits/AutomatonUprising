extends Node

var time = {}
var biome = {}
var object = {}
var recipe = {}
var physics = {}
var texture = {}
var material = {}
var controls = {}
var instance = {}
var settings = {}
var allowance = {}

func _ready():
	store_vanilla()
	load_game_data("user://vanilla.json")

func load_game_data(mod_dir):
	var data = {}
	var file = File.new()
	
	if !file.file_exists(mod_dir):
		return

	file.open(mod_dir, File.READ)
	data['time'] = parse_json(file.get_line())
	data['biome'] = parse_json(file.get_line())
	data['object'] = parse_json(file.get_line())
	data['recipe'] = parse_json(file.get_line())
	data['physics'] = parse_json(file.get_line())
	data['texture'] = parse_json(file.get_line())
	data['material'] = parse_json(file.get_line())
	data['controls'] = parse_json(file.get_line())
	data['instance'] = parse_json(file.get_line())
	data['settings'] = parse_json(file.get_line())
	data['allowance'] = parse_json(file.get_line())
	file.close()
	
	if data.size() != get_vanilla().size():
		print("Game modded")
	
	load_mod(time, data['time'])
	load_mod(biome, data['biome'])
	load_mod(object, data['object'])
	load_mod(recipe, data['recipe'])
	load_mod(physics, data['physics'])
	load_mod(texture, data['texture'])
	load_mod(material, data['material'])
	load_mod(controls, data['controls'])
	load_mod(instance, data['instance'])
	load_mod(settings, data['settings'])
	load_mod(allowance, data['allowance'])

func load_mod(target, mod=null):
	if !mod:
		return
	else:
		for m in mod:
			target[m] = mod[m]

func store_vanilla():
	var f = File.new()
	f.open("user://vanilla.json", File.WRITE)
	f.store_line(to_json(get_vanilla()['time']))
	f.store_line(to_json(get_vanilla()['biome']))
	f.store_line(to_json(get_vanilla()['object']))
	f.store_line(to_json(get_vanilla()['recipe']))
	f.store_line(to_json(get_vanilla()['physics']))
	f.store_line(to_json(get_vanilla()['texture']))
	f.store_line(to_json(get_vanilla()['material']))
	f.store_line(to_json(get_vanilla()['controls']))
	f.store_line(to_json(get_vanilla()['instance']))
	f.store_line(to_json(get_vanilla()['settings']))
	f.store_line(to_json(get_vanilla()['allowance']))
	f.close()

func get_vanilla():
	var vanilla = {



		"time" : {
			'year' : 2934,
			'month' : 4,
			'day' : 24,
			'hour' : 5,
			'minute' : 0,
			'second' : 0
			},



		"biome" : {
			'w0' : {
				'h0' : {
					'name' : 'Snowcap',
					'density' : 10,
					'debris' : '',
					'soil' : 'stone',
					'spawn' : ['boulder', 'stone'],
					},
				'h1' : {
					'name' : 'Mountain',
					'density' : 15,
					'debris' : '',
					'soil' : 'stone',
					'spawn' : ['boulder', 'stone'],
					},
				'h2' : {
					'name' : 'Cliff',
					'density' : 5,
					'debris' : '',
					'soil' : 'stone',
					'spawn' : ['boulder', 'stone'],
					}},
			'w1' : {
				'h0' : {
					'name' : 'Highlands',
					'density' : 5,
					'debris' : 'grass',
					'soil' : 'soil',
					'spawn' : ['stone', 'bush'],
					},
				'h1' : {
					'name' : 'Hills',
					'density' : 5,
					'debris' : 'grass',
					'soil' : 'soil',
					'spawn' : ['stone', 'bush'],
					},
				'h2' : {
					'name' : 'Dunes',
					'density' : 5,
					'debris' : '',
					'soil' : 'sand',
					'spawn' : ['aloe', 'cactus', 'bush'],
					}},
			'w2' : {
				'h0' : {
					'name' : 'Alpines',
					'density' : 75,
					'debris' : 'pinestraw',
					'soil' : 'foliage',
					'spawn' : ['treepine', 'pinecone'],
					},
				'h1' : {
					'name' : 'Forest',
					'density' : 25,
					'debris' : 'leaves',
					'soil' : 'foliage',
					'spawn' : ['treeash', 'treeaspen', 'treeoak', 'stump'],
					},
				'h2': {
					'name' : 'Jungle',
					'density' : 50,
					'debris' : 'leaves',
					'soil' : 'foliage',
					'spawn' : ['treeash', 'treeoak', 'bush', 'stump'],
					}},
			'w3' : {
				'h0' : {
					'name' : 'Taiga',
					'density' : 25,
					'debris' : 'grass',
					'soil' : 'soil',
					'spawn' : ['stone'],
					},
				'h1' : {
					'name' : 'Meadow',
					'density' : 100,
					'debris' : 'grass',
					'soil' : 'soil',
					'spawn' : ['greenonion', 'grass', 'rye', 'sunflower', 'daisy'],
					},
				'h2' : {
					'name' : 'Grasslands',
					'density' : 100,
					'debris' : 'grass',
					'soil' : 'soil',
					'spawn' : ['greenonion', 'grass', 'rye', 'wheat', 'sunflower', 'daisy'],
					}},
			'w4' : {
				'h0' : {
					'name' : 'Bog',
					'density' : 25,
					'debris' : 'grass',
					'soil' : 'foliage',
					'spawn' : ['cattail', 'grass', 'stump'],
					},
				'h1' : {
					'name' : 'Marsh',
					'density' : 50,
					'debris' : 'grass',
					'soil' : 'foliage',
					'spawn' : ['cattail', 'grass', 'rye'],
					},
				'h2' : {
					'name' : 'Swamp',
					'density' : 50,
					'debris' : 'grass',
					'soil' : 'foliage',
					'spawn' : ['cattail', 'clover', 'grass', 'rye', 'stump'],
					}},
			'w5' : {
				'h0' : {
					'name' : 'Tundra',
					'density' : 5,
					'debris' : 'grass',
					'soil' : 'soil',
					'spawn' : ['stone'],
					},
				'h1' : {
					'name' : 'Lowlands',
					'density' : 25,
					'debris' : 'grass',
					'soil' : 'soil',
					'spawn' : ['stone', 'grass'],
					},
				'h2' : {
					'name' : 'Desert',
					'density' : 5,
					'debris' : '',
					'soil' : 'sand',
					'spawn' : ['aloe', 'cactus'],
					}},
			'w6' : {
				'h0' : {
					'name' : 'Shore',
					'density' : 5,
					'debris' : '',
					'soil' : 'sand',
					'spawn' : ['stone'],
					},
				'h1' : {
					'name' : 'Coast',
					'density' : 10,
					'debris' : '',
					'soil' : 'sand',
					'spawn' : ['stone'],
					},
				'h2' : {
					'name' : 'Beach',
					'density' : 25,
					'debris' : '',
					'soil' : 'sand',
					'spawn' : ['stone'],
					}},
			'w7' : {
				'h0' : {
					'name' : 'Glacial Ocean',
					'density' : 0,
					'debris' : '',
					'soil' : 'sand',
					'spawn' : ['stone'],
					},
				'h1' : {
					'name' : 'Ocean',
					'density' : 10,
					'debris' : '',
					'soil' : 'sand',
					'spawn' : ['stone'],
					},
				'h2' : {
					'name' : 'Tropical Ocean',
					'density' : 25,
					'debris' : '',
					'soil' : 'sand',
					'spawn' : ['stone'],
					}}
			},



		"object" : {
			'dronecarrier' : {
				'instance' : ['drone'],
				'mesh' : [],
				'data' : {}
			},
			'dronefighter' : {
				'instance' : ['drone'],
				'mesh' : [],
				'data' : {}
			},
			'dronescout' : {
				'instance' : ['drone'],
				'mesh' : [],
				'data' : {}
			},
			'player' : {
				'instance' : ['player'],
				'mesh' : [''],
				'data' : {}
			},

#			'' : {
#				'instance' : 'food',
#				'mesh' : [],
#				'nutrients' : {
#					'weight' : 0.0,
#					'calorie' : 0.0,
#					'sat_fat' : 0.0,
#					'pol_fat' : 0.0,
#					'mon_fat' : 0.0,
#					'cholesterol' : 0.0,
#					'sodium' : 0.0,
#					'fiber' : 0.0,
#					'sugar' : 0.0,
#					'protein' : 0.0,
#					'calcium' : 0.0,
#					'potassium' : 0.0,
#					'iron' : 0.0,
#					'vitamin_a' : 0.0,
#					'vitamin_c' : 0.0
#				}
#			},
			'aloe' : {
				'instance' : ['plant'],
				'mesh' : ["res://mesh/plant/aloe.obj"],
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'amaranth' : {
				'instance' : ['food', 'plant'],
				'mesh' : ["res://mesh/plant/amaranth.obj"],
				'food' : {
					'weight' : 10000.0,
					'calorie' : 37.0,
					'sat_fat' : 200.0,
					'pol_fat' : 300.0,
					'mon_fat' : 100.0,
					'cholesterol' : 0.0,
					'sodium' : 2.0,
					'fiber' : 900.0,
					'sugar' : 0.0,
					'protein' : 1400.0,
					'calcium' : 15.0,
					'potassium' : 37.0,
					'iron' : 1.0,
					'vitamin_a' : 0.0,
					'vitamin_c' : 1.0
				},
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'apple' : {
				'instance' : ['food'],
				'mesh' : ["res://mesh/food/apple.obj"],
				'food' : {
					'weight' : 200000.0,
					'calorie' : 93.0,
					'sat_fat' : 100.0,
					'pol_fat' : 100.0,
					'mon_fat' : 100.0,
					'cholesterol' : 0.0,
					'sodium' : 2.0,
					'fiber' : 430.0,
					'sugar' : 18600.0,
					'protein' : 500.0,
					'calcium' : 11.0,
					'potassium' : 192.0,
					'iron' : 1.0,
					'vitamin_a' : 98.0,
					'vitamin_c' : 8.0
				}
			},
			'blackberry' : {
				'instance' : ['food'],
				'mesh' : ["res://mesh/food/blackberry.obj"],
				'food' : {
					'weight' : 1500.0,
					'calorie' : 0.43,
					'sat_fat' : 10.0,
					'pol_fat' : 10.0,
					'mon_fat' : 10.0,
					'cholesterol' : 0.0,
					'sodium' : 1.0,
					'fiber' : 50.0,
					'sugar' : 50.0,
					'protein' : 10.0,
					'calcium' : 0.3,
					'potassium' : 1.6,
					'iron' : 0.1,
					'vitamin_a' : 2.2,
					'vitamin_c' : 0.2}
			},
			'blueberry' : {
				'instance' : ['food'],
				'mesh' : ["res://mesh/food/blueberry.obj"],
				'food' : {
					'weight' : 1250.0,
					'calorie' : 0.6,
					'sat_fat' : 10.0,
					'pol_fat' : 10.0,
					'mon_fat' : 10.0,
					'cholesterol' : 0.0,
					'sodium' : 0.1,
					'fiber' : 20.0,
					'sugar' : 1000.0,
					'protein' : 10.0,
					'calcium' : 1.0,
					'potassium' : 0.8,
					'iron' : 1.0,
					'vitamin_a' : 6.0,
					'vitamin_c' : 1.0}
			},
			'carrot' : {
				'instance' : ['food', 'plant'],
				'mesh' : ["res://mesh/food/carrot.obj"],
				'food' : {
					'weight' : 85000.0,
					'calorie' : 31.0,
					'sat_fat' : 100.0,
					'pol_fat' : 0.0,
					'mon_fat' : 100.0,
					'cholesterol' : 0.0,
					'sodium' : 52.0,
					'fiber' : 2100.0,
					'sugar' : 3400.0,
					'protein' : 700.0,
					'calcium' : 25.0,
					'potassium' : 242.0,
					'iron' : 1.0,
					'vitamin_a' : 12725.0,
					'vitamin_c' : 4.0},
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
			},
			'clover' : {
				'instance' : ['cluster', 'food', 'plant'],
				'mesh' : ["res://mesh/plant/clover.obj"],
				'food' : {
					'weight' : 85000.0,
					'calorie' : 25.0,
					'sat_fat' : 200.0,
					'pol_fat' : 100.0,
					'mon_fat' : 100.0,
					'cholesterol' : 0.0,
					'sodium' : 5.0,
					'fiber' : 2000.0,
					'sugar' : 0.0,
					'protein' : 3000.0,
					'calcium' : 20.4,
					'potassium' : 0.0,
					'iron' : 0.7,
					'vitamin_a' : 0.0,
					'vitamin_c' : 6.0},
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 15,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'grass' : {
				'instance' : ['cluster'],
				'mesh' : ["res://mesh/plant/grass0.obj",
				"res://mesh/plant/grass1.obj",
				"res://mesh/plant/grass2.obj",
				"res://mesh/plant/grass3.obj"],
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 25,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
			},
			'greenonion' : {
				'instance' : ['food', 'plant'],
				'mesh' : ["res://mesh/food/greenonion.obj"],
				'food' : {
					'weight' : 915.0,
					'calorie' : 0.0,
					'sat_fat' : 0.0,
					'pol_fat' : 0.0,
					'mon_fat' : 0.0,
					'cholesterol' : 0.0,
					'sodium' : 2.0,
					'fiber' : 300.0,
					'sugar' : 300.0,
					'protein' : 200.0,
					'calcium' : 10.0,
					'potassium' : 0.0,
					'iron' : 1.0,
					'vitamin_a' : 100.0,
					'vitamin_c' : 2.0},
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
			},
			'potato' : {
				'instance' : ['food', 'plant'],
				'mesh' : ["res://mesh/food/potato.obj"],
				'food' : {
					'weight' : 173000.0,
					'calorie' : 168.0,
					'sat_fat' : 100.0,
					'pol_fat' : 100.0,
					'mon_fat' : 100.0,
					'cholesterol' : 0.0,
					'sodium' : 14.0,
					'fiber' : 4000.0,
					'sugar' : 1900.0,
					'protein' : 4500.0,
					'calcium' : 31.0,
					'potassium' : 952.0,
					'iron' : 2.0,
					'vitamin_a' : 17.0,
					'vitamin_c' : 22.0},
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
			},
			'raspberry' : {
				'instance' : ['food'],
				'mesh' : ["res://mesh/food/raspberry.obj"],
				'food' : {
					'weight' : 1000.0,
					'calorie' : 0.5,
					'sat_fat' : 100.0,
					'pol_fat' : 100.0,
					'mon_fat' : 100.0,
					'cholesterol' : 0.0,
					'sodium' : 1.0,
					'fiber' : 700.0,
					'sugar' : 400.0,
					'protein' : 100.0,
					'calcium' : 3.0,
					'potassium' : 15.0,
					'iron' : 1.0,
					'vitamin_a' : 4.0,
					'vitamin_c' : 3.0}
			},
			'rye' : {
				'instance' : ['cluster', 'food', 'plant'],
				'mesh' : ["res://mesh/plant/rye.obj"],
				'food' : {
					'weight' : 0.0,
					'calorie' : 0.0,
					'sat_fat' : 0.0,
					'pol_fat' : 0.0,
					'mon_fat' : 0.0,
					'cholesterol' : 0.0,
					'sodium' : 0.0,
					'fiber' : 0.0,
					'sugar' : 0.0,
					'protein' : 0.0,
					'calcium' : 0.0,
					'potassium' : 0.0,
					'iron' : 0.0,
					'vitamin_a' : 0.0,
					'vitamin_c' : 0.0},
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 10,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'watercress' : {
				'instance' : ['cluster', 'food', 'plant'],
				'mesh' : ["res://mesh/plant/watercress.obj"],
				'food' : {
					'weight' : 0.0,
					'calorie' : 0.0,
					'sat_fat' : 0.0,
					'pol_fat' : 0.0,
					'mon_fat' : 0.0,
					'cholesterol' : 0.0,
					'sodium' : 0.0,
					'fiber' : 0.0,
					'sugar' : 0.0,
					'protein' : 0.0,
					'calcium' : 0.0,
					'potassium' : 0.0,
					'iron' : 0.0,
					'vitamin_a' : 0.0,
					'vitamin_c' : 0.0},
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 5,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'wheat' : {
				'instance' : ['cluster', 'food', 'plant'],
				'mesh' : ["res://mesh/plant/wheat.obj"],
				'food' : {
					'weight' : 0.0,
					'calorie' : 0.0,
					'sat_fat' : 0.0,
					'pol_fat' : 0.0,
					'mon_fat' : 0.0,
					'cholesterol' : 0.0,
					'sodium' : 0.0,
					'fiber' : 0.0,
					'sugar' : 0.0,
					'protein' : 0.0,
					'calcium' : 0.0,
					'potassium' : 0.0,
					'iron' : 0.0,
					'vitamin_a' : 0.0,
					'vitamin_c' : 0.0},
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 10,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},

			'bush' : {
				'instance' : ['plant'],
				'mesh' : ["res://mesh/plant/bush0.obj",
					"res://mesh/plant/bush1.obj",
					"res://mesh/plant/bush2.obj",
					"res://mesh/plant/bush3.obj"],
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'cactus' : {
				'instance' : ['plant'],
				'mesh' : ["res://mesh/plant/cactus0.obj",
				"res://mesh/plant/cactus1.obj",
				"res://mesh/plant/cactus2.obj",
				"res://mesh/plant/cactus3.obj"],
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'cattail' : {
				'instance' : ['plant'],
				'mesh' : ["res://mesh/plant/cattail.obj"],
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'daisy' : {
				'instance' : ['plant'],
				'mesh' : ["res://mesh/plant/daisy0.obj",
					"res://mesh/plant/daisy1.obj",
					"res://mesh/plant/daisy2.obj",
					"res://mesh/plant/daisy3.obj"],
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'purslane' : {
				'instance' : ['plant'],
				'mesh' : ["res://mesh/plant/purslane.obj"],
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 5,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'sunflower' : {
				'instance' : ['plant'],
				'mesh' : ["res://mesh/plant/sunflower.obj"],
				'data' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'treeash' : {
				'instance' : ['plant'],
				'mesh' : ["res://mesh/plant/tree-ash0.obj",
					"res://mesh/plant/tree-ash1.obj",
					"res://mesh/plant/tree-ash2.obj",
					"res://mesh/plant/tree-ash3.obj"],
				'data' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'treeaspen' : {
				'instance' : ['plant'],
				'mesh' : ["res://mesh/plant/tree-aspen0.obj",
					"res://mesh/plant/tree-aspen1.obj",
					"res://mesh/plant/tree-aspen2.obj",
					"res://mesh/plant/tree-aspen3.obj"],
				'data' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'treeoak' : {
				'instance' : ['plant'],
				'mesh' : ["res://mesh/plant/tree-oak0.obj",
					"res://mesh/plant/tree-oak1.obj",
					"res://mesh/plant/tree-oak2.obj",
					"res://mesh/plant/tree-oak3.obj"],
				'data' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'treepine' : {
				'instance' : ['plant'],
				'mesh' : ["res://mesh/plant/tree-pine0.obj",
					"res://mesh/plant/tree-pine1.obj",
					"res://mesh/plant/tree-pine2.obj",
					"res://mesh/plant/tree-pine3.obj"],
				'data' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},

			'acorn' : {
				'instance' : ['food', 'material'],
				'mesh' : ["res://mesh/material/acorn.obj"],
				'food' : {
					'weight' : 10.0,
					'calorie' : 39.0,
					'sat_fat' : 300.0,
					'pol_fat' : 500.0,
					'mon_fat' : 1500.0,
					'cholesterol' : 0.0,
					'sodium' : 0.0,
					'fiber' : 2500.0,
					'sugar' : 500.0,
					'protein' : 600.0,
					'calcium' : 4.0,
					'potassium' : 54.0,
					'iron' : 1.0,
					'vitamin_a' : 4.0,
					'vitamin_c' : 0.0},
					'material' : {'weight' : 10.0}
				},
			'boulder' : {
				'instance' : ['material'],
				'mesh' : ["res://mesh/material/boulder0.obj",
					"res://mesh/material/boulder1.obj",
					"res://mesh/material/boulder2.obj",
					"res://mesh/material/boulder3.obj"],
				'material' : {'weight' : 10000000.0}
				},
			'hive' : {
				'instance' : ['material'],
				'mesh' : ["res://mesh/material/hive.obj"],
				'material' : {'weight' : 10000.0}
				},
			'leaves' : {
				'instance' : ['cluster'],
				'mesh' : ["res://mesh/material/leaves.obj"],
				'material' : {'weight' : 0.0},
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 10,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'pinecone' : {
				'instance' : ['material'],
				'mesh' : ["res://mesh/material/pinecone.obj"],
				'material' : {'weight' : 5000.0}
				},
			'pinestraw' : {
				'instance' : ['cluster'],
				'mesh' : ["res://mesh/material/pinestraw.obj"],
				'material' : {'weight' : 0.0},
				'plant' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'density' : 10,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'stump' : {
				'instance' : ['material'],
				'mesh' : ["res://mesh/material/stump.obj"],
				'material' : {'weight' : 10000000.0}
				},
			'stone' : {
				'instance' : ['material'],
				'mesh' : ["res://mesh/material/stone0.obj",
					"res://mesh/material/stone1.obj",
					"res://mesh/material/stone2.obj",
					"res://mesh/material/stone3.obj"],
				'material' : {'weight' : 100000.0}
				},

			'anvil' : {
				'instance' : ['tool'],
				'mesh' : ["res://mesh/tool/anvil.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					},
				'use' : ['repair', 'craft']
				},
			'axeiron' : {
				'instance' : ['tool'],
				'mesh' : ["res://mesh/tool/axe-iron.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					},
				'use' : ['destroy', 'harvest', 'craft']
				},
			'axestone' : {
				'instance' : ['tool'],
				'mesh' : ["res://mesh/tool/axe-stone.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					},
				'use' : ['destroy', 'harvest', 'craft']
				},
			'bowlclay' : {
				'instance' : ['tool'],
				'mesh' : ["res://mesh/tool/bowl-clay.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					},
				'use' : ['consume', 'destroy', 'harvest']
				},
			'cupclay' : {
				'instance' : ['tool'],
				'mesh' : ["res://mesh/tool/cup-clay.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					},
				'use' : ['consume', 'destroy', 'harvest']
				},
			'firepit' : {
				'instance' : ['tool'],
				'mesh' : ["res://mesh/tool/firepit.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					},
				'use' : ['destroy', 'craft', 'light']
				},
			'hammeriron' : {
				'instance' : ['tool'],
				'mesh' : ["res://mesh/tool/hammer-iron.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					},
				'use' : ['destroy', 'harvest', 'repair', 'build', 'craft']
				},
			'hammerstone' : {
				'instance' : ['tool'],
				'mesh' : ["res://mesh/tool/hammerstone.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					},
				'use' : ['destroy', 'harvest', 'repair', 'build', 'craft']
				},
			'handaxe' : {
				'instance' : ['tool'],
				'mesh' : ["res://mesh/tool/handaxe.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					},
				'use' : ['destroy', 'harvest', 'craft']
				},
			'knifestone' : {
				'instance' : ['tool'],
				'mesh' : ["res://mesh/tool/knife-stone.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					},
				'use' : ['destroy', 'harvest', 'craft']
				},
			'pickaxeiron' : {
				'instance' : ['tool'],
				'mesh' : ["res://mesh/tool/pickaxe-iron.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					},
				'use' : ['destroy', 'harvest']
				},
			'plateclay' : {
				'instance' : ['tool'],
				'mesh' : ["res://mesh/tool/plate-clay.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					},
				'use' : ['consume', 'destroy', 'harvest', 'craft']
				},
			'spearstone' : {
				'instance' : ['tool'],
				'mesh' : ["res://mesh/tool/spear-stone.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					},
				'use' : ['destroy']
				},
			'torch' : {
				'instance' : ['tool'],
				'mesh' : ["res://mesh/tool/torch.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					},
				'use' : ['light']
				},

			'arrowiron' : {
				'instance' : ['projectile'],
				'mesh' : ["res://mesh/weapon/arrow-iron.obj"],
				'data' : {
					'damage' : 0.0,
					'weight' : 0.0,
					'speed' : 0.0
				}
				},
			'arrowstone' : {
				'instance' : ['projectile'],
				'mesh' : ["res://mesh/weapon/arrow-stone.obj"],
				'data' : {
					'damage' : 0.0,
					'weight' : 0.0,
					'speed' : 0.0
				}
				},
			'pulsecannon' : {
				'instance' : ['weapon'],
				'mesh' : ["res://mesh/weapon/pulse-cannon.obj"],
				'data' : {
					'damage' : 0,
					'weight' : 0,
					'range' : 0,
					'HP' : 0,
					'hp' : 0,
					}
				},
			'pulsecharge' : {
				'instance' : ['fuel'],
				'mesh' : ["res://mesh/weapon/pulse-cannon_charge.obj"],
				'data' : {
					'energy' : 0.0,
					'weight' : 0.0
				}
				},

			'tile0' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/0.obj"],
				'data' : {
				}
				},
			'tile1' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/1.obj"],
				'data' : {
				}
				},
			'tile2' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/2.obj"],
				'data' : {
				}
				},
			'tile3' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/3.obj"],
				'data' : {
				}
				},
			'tile4' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/4.obj"],
				'data' : {
				}
				},
			'tile5' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/5.obj"],
				'data' : {
				}
				},
			'tile6' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/6.obj"],
				'data' : {
				}
				},
			'tile7' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/7.obj"],
				'data' : {
				}
				},
			'tile8' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/8.obj"],
				'data' : {
				}
				},
			'tile9' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/9.obj"],
				'data' : {
				}
				},
			'tile10' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/10.obj"],
				'data' : {
				}
				},
			'tile11' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/11.obj"],
				'data' : {
				}
				},
			'tile12' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/12.obj"],
				'data' : {
				}
				},
			'tile13' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/13.obj"],
				'data' : {
				}
				},
			'tile14' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/14.obj"],
				'data' : {
				}
				},
			'tile15' : {
				'instance' : ['tile'],
				'mesh' : ["res://mesh/tile/15.obj"],
				'data' : {
				}
				},
			'water' : {
				'instance' : ['water'],
				'mesh' : ["res://mesh/tile/water.dae"],
				'data' : {
				}
				},
			},



		"texture" : {
			'cursor_texture' : "res://image/ui/cursor.png",
			'menu_texture' : "res://image/ui/menu.png",
			},



		"material" : {
			'global' : "res://skin/global_material.tres",
			'foliage0' : "res://skin/foliage_material0.tres",
			'foliage1' : "res://skin/foliage_material1.tres",
			'foliage2' : "res://skin/foliage_material2.tres",
			'foliage3' : "res://skin/foliage_material3.tres",
			'foliage4' : "res://skin/foliage_material4.tres",
			'foliage5' : "res://skin/foliage_material5.tres",
			'foliage6' : "res://skin/foliage_material6.tres",
			'foliage7' : "res://skin/foliage_material7.tres",
			'sand0' : "res://skin/sand_material0.tres",
			'sand1' : "res://skin/sand_material1.tres",
			'sand2' : "res://skin/sand_material2.tres",
			'sand3' : "res://skin/sand_material3.tres",
			'sand4' : "res://skin/sand_material4.tres",
			'sand5' : "res://skin/sand_material5.tres",
			'sand6' : "res://skin/sand_material6.tres",
			'sand7' : "res://skin/sand_material7.tres",
			'soil0' : "res://skin/soil_material0.tres",
			'soil1' : "res://skin/soil_material1.tres",
			'soil2' : "res://skin/soil_material2.tres",
			'soil3' : "res://skin/soil_material3.tres",
			'soil4' : "res://skin/soil_material4.tres",
			'soil5' : "res://skin/soil_material5.tres",
			'soil6' : "res://skin/soil_material6.tres",
			'soil7' : "res://skin/soil_material7.tres",
			'stone0' : "res://skin/stone_material0.tres",
			'stone1' : "res://skin/stone_material1.tres",
			'stone2' : "res://skin/stone_material2.tres",
			'stone3' : "res://skin/stone_material3.tres",
			'stone4' : "res://skin/stone_material4.tres",
			'stone5' : "res://skin/stone_material5.tres",
			'stone6' : "res://skin/stone_material6.tres",
			'stone7' : "res://skin/stone_material7.tres",
			},



		"recipe" : {
			"" : {
				'give' : {},
				'need' : {}},
			},



		"physics" : {
			"world_size" : 64,
			"chunk_size" : 4,
			"tile_size" : 1,
			
			"height_scale" : 32,
			"water_scale" : 64,
			"heat_scale" : 128,
			
			"max_height" : 12.0,
			"max_water" : 7.0,
			"max_heat" : 2.0,
			"sea_level" : -7.75,
			"bedrock_level" : -10.0,
			"gravity" : 0.5,
			},



		"controls" : {
			'menu' : 'Escape',
			'run' : 'Control',
			'jog' : 'Shift',
			'jump' : 'Space',
			'move_forward' : 'W',
			'move_backward' : 'S',
			'move_left' : 'A',
			'move_right' : 'D',
			},



		"instance" : {
			'drone' : "res://scene/instance/Drone.tscn",
			'player' : "res://scene/instance/Player.tscn",
			'food' : "res://scene/instance/Food.tscn",
			'material' : "res://scene/instance/Material.tscn",
			'cluster' : "res://scene/instance/Cluster.tscn",
			'plant' : "res://scene/instance/Plant.tscn",
			'tool' : "res://scene/instance/Tool.tscn",
			'weapon' : "res://scene/instance/Weapon.tscn",
			'tile' : "res://scene/instance/Tile.tscn",
			'water' : "res://scene/instance/Water.tscn",
			'voxel' : "res://scene/instance/Voxel.tscn",
			
			'text' : "res://scene/ui/Text.tscn",
			'pause' : "res://scene/ui/PauseMenu.tscn",
			'setter' : "res://scene/ui/SettingSetter.tscn",
			'controls' : "res://scene/ui/ControlSettings.tscn",
			'settings' : "res://scene/ui/Settings.tscn",
			},



		"settings" : {
			'game_seed' : {'value' : '', 'min' : 0, 'max' : 16},
			'font_name' : {'value' : '', 'min' : 0, 'max' : 128},
			
			'message_font' : {'value' : 16, 'min' : 16, 'max' : 16},
			'spawn_distance' : {'value' : 4, 'min' : 1, 'max' : 32},
			
			'mouse_sensitivity' : {'value' : 0.25, 'min' : 0.0, 'max' : 0.0},
			'wheel_sensitivity' : {'value' : 0.25, 'min' : 0.0, 'max' : 0.0},
			'hud_opacity' : {'value' : 0.25, 'min' : 0.0, 'max' : 0.0},
			'max_pitch' : {'value' : 80.0, 'min' : 45.0, 'max' : 90.0},
			'effects_volume' : {'value' : 0.0, 'min' : 0.0, 'max' : 0.0},
			'music_volume' : {'value' : 0.0, 'min' : 0.0, 'max' : 0.0},
			},



		"allowance" : {
			'calorie' : 1100.0,
			'sat_fat' : 27500.0,
			'pol_fat' : 13750.0,
			'mon_fat' : 13750.0,
			'cholesterol' : 6000.0,
			'sodium' : 75.0,
			'fiber' : 750.0,
			'sugar' : 500.0,
			'protein' : 875.0,
			'calcium' : 550.0,
			'potassium' : 2350.0,
			'iron' : 4.0,
			'vitamin_a' : 0.4,
			'vitamin_c' : 40.0
		}



	}
	return vanilla
