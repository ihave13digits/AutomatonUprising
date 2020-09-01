extends Node

var time = {}
var biome = {}
var effect = {}
var object = {}
var recipe = {}
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
	data['instance'] = parse_json(file.get_line())
	data['settings'] = parse_json(file.get_line())
	data['allowance'] = parse_json(file.get_line())
	file.close()
	
	if data != get_vanilla():
		print("Game modded")
	
	load_mod(time, data['time'])
	load_mod(biome, data['biome'])
	load_mod(object, data['object'])
	load_mod(recipe, data['recipe'])
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
			'glacial ocean' : {
				'noise' : {'fissure' : -1.0, 'moisture' : 0.6, 'temperature' : -0.66},
				'spawn' : {},
				},
			'ocean' : {
				'noise' : {'fissure' : -1.0, 'moisture' : 0.6, 'temperature' : 0.0},
				'spawn' : {},
				},
			'tropical ocean' : {
				'noise' : {'fissure' : -1.0, 'moisture' : 0.6, 'temperature' : 0.66},
				'spawn' : {},
				},
			
			'beach' : {
				'noise' : {'fissure' : 0.0, 'moisture' : 0.5, 'temperature' : 0.66},
				'spawn' : {},
				},
			'coast' : {
				'noise' : {'fissure' : 0.0, 'moisture' : 0.5, 'temperature' : 0.0},
				'spawn' : {},
				},
			'shore' : {
				'noise' : {'fissure' : 0.0, 'moisture' : 0.5, 'temperature' : -0.66},
				'spawn' : {},
				},
			
			'desert' : {
				'noise' : {'fissure' : 0.1, 'moisture' : -0.5, 'temperature' : 0.66},
				'spawn' : {},
				},
			'lowlands' : {
				'noise' : {'fissure' : 0.1, 'moisture' : 0.0, 'temperature' : 0.0},
				'spawn' : {},
				},
			'tundra' : {
				'noise' : {'fissure' : 0.1, 'moisture' : 0.0, 'temperature' : -0.66},
				'spawn' : {},
				},
			
			'bog' : {
				'noise' : {'fissure' : 0.25, 'moisture' : 0.25, 'temperature' : -0.66},
				'spawn' : {},
				},
			'marsh' : {
				'noise' : {'fissure' : 0.25, 'moisture' : 0.25, 'temperature' : 0.0},
				'spawn' : {},
				},
			'swamp' : {
				'noise' : {'fissure' : 0.25, 'moisture' : 0.25, 'temperature' : 0.66},
				'spawn' : {},
				},
			
			'grasslands' : {
				'noise' : {'fissure' : 0.25, 'moisture' : 0.15, 'temperature' : 0.66},
				'spawn' : {},
				},
			'meadow' : {
				'noise' : {'fissure' : 0.25, 'moisture' : 0.05, 'temperature' : 0.0},
				'spawn' : {},
				},
			'taiga' : {
				'noise' : {'fissure' : 0.25, 'moisture' : 0.05, 'temperature' : -0.66},
				'spawn' : {},
				},
			
			'alpines' : {
				'noise' : {'fissure' : 0.5, 'moisture' : 0.1, 'temperature' : -0.66},
				'spawn' : {},
				},
			'forest' : {
				'noise' : {'fissure' : 0.5, 'moisture' : 0.15, 'temperature' : 0.0},
				'spawn' : {},
				},
			'jungle' : {
				'noise' : {'fissure' : 0.5, 'moisture' : 0.2, 'temperature' : 0.66},
				'spawn' : {},
				},
			
			'dunes' : {
				'noise' : {'fissure' : 0.75, 'moisture' : -0.5, 'temperature' : 0.66},
				'spawn' : {},
				},
			'highlands' : {
				'noise' : {'fissure' : 0.75, 'moisture' : 0.25, 'temperature' : -0.66},
				'spawn' : {},
				},
			'hills' : {
				'noise' : {'fissure' : 0.75, 'moisture' : 0.0, 'temperature' : 0.0},
				'spawn' : {},
				},
			
			'cliff' : {
				'noise' : {'fissure' : 1.0, 'moisture' : -0.25, 'temperature' : 0.66},
				'spawn' : {},
				},
			'mountain' : {
				'noise' : {'fissure' : 1.0, 'moisture' : 0.0, 'temperature' : 0.0},
				'spawn' : {},
				},
			'snowcap' : {
				'noise' : {'fissure' : 1.0, 'moisture' : 0.25, 'temperature' : -0.66},
				'spawn' : {},
				}
			},



		"object" : {
			'dronecarrier' : {
				'instance' : 'drone',
				'mesh' : [],
				'data' : {}
			},
			'dronefighter' : {
				'instance' : 'drone',
				'mesh' : [],
				'data' : {}
			},
			'dronescout' : {
				'instance' : 'drone',
				'mesh' : [],
				'data' : {}
			},
			'player' : {
				'instance' : 'player',
				'mesh' : [],
				'data' : {}
			},

#			'' : {
#				'instance' : 'food',
#				'mesh' : [],
#				'data' : {
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
			'apple' : {
				'instance' : 'food',
				'mesh' : ["res://mesh/food/apple.obj"],
				'data' : {
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
					'vitamin_c' : 0.0
				}
			},
			'blackberry' : {
				'instance' : 'food',
				'mesh' : ["res://mesh/food/blackberry.obj"],
				'data' : {
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
					'vitamin_c' : 0.0}
			},
			'blueberry' : {
				'instance' : 'food',
				'mesh' : ["res://mesh/food/blueberry.obj"],
				'data' : {
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
					'vitamin_c' : 0.0}
			},
			'carrot' : {
				'instance' : 'food',
				'mesh' : ["res://mesh/food/carrot.obj"],
				'data' : {
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
					'vitamin_c' : 0.0}
			},
			'greenonion' : {
				'instance' : 'food',
				'mesh' : ["res://mesh/food/greenonion.obj"],
				'data' : {
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
					'vitamin_c' : 0.0}
			},
			'potato' : {
				'instance' : 'food',
				'mesh' : ["res://mesh/food/potato.obj"],
				'data' : {
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
					'vitamin_c' : 0.0}
			},
			'raspberry' : {
				'instance' : 'food',
				'mesh' : ["res://mesh/food/raspberry.obj"],
				'data' : {
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
					'vitamin_c' : 0.0}
			},

			'acorn' : {
				'instance' : 'material',
				'mesh' : ["res://mesh/material/acorn.obj"],
				'data' : {'weight' : 0.0}
				},
			'boulder' : {
				'instance' : 'material',
				'mesh' : ["res://mesh/material/boulder0.obj",
					"res://mesh/material/boulder1.obj",
					"res://mesh/material/boulder2.obj",
					"res://mesh/material/boulder3.obj"],
				'data' : {'weight' : 0.0}
				},
			'hive' : {
				'instance' : 'material',
				'mesh' : ["res://mesh/material/hive.obj"],
				'data' : {'weight' : 0.0}
				},
			'pinecone' : {
				'instance' : 'material',
				'mesh' : ["res://mesh/material/pinecone.obj"],
				'data' : {'weight' : 0.0}
				},
			'stone' : {
				'instance' : 'material',
				'mesh' : ["res://mesh/material/stone0.obj",
					"res://mesh/material/stone1.obj",
					"res://mesh/material/stone2.obj",
					"res://mesh/material/stone3.obj"],
				'data' : {'weight' : 0.0}
				},

			'amaranth' : {
				'instance' : 'plant',
				'mesh' : ["res://mesh/plant/amaranth.obj"],
				'data' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'bush' : {
				'instance' : 'plant',
				'mesh' : ["res://mesh/plant/bush0.obj",
					"res://mesh/plant/bush1.obj",
					"res://mesh/plant/bush2.obj",
					"res://mesh/plant/bush3.obj"],
				'data' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'cattail' : {
				'instance' : 'plant',
				'mesh' : ["res://mesh/plant/cattail.obj"],
				'data' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'clover' : {
				'instance' : 'plant',
				'mesh' : ["res://mesh/plant/clover.obj"],
				'data' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'purslane' : {
				'instance' : 'plant',
				'mesh' : ["res://mesh/plant/purslane.obj"],
				'data' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'treeash' : {
				'instance' : 'plant',
				'mesh' : ["res://mesh/plant/tree-ash0.obj",
					"res://mesh/plant/tree-ash1.obj",
					"res://mesh/plant/tree-ash2.obj",
					"res://mesh/plant/tree-ash3.obj"],
				'data' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'treeoak' : {
				'instance' : 'plant',
				'mesh' : ["res://mesh/plant/tree-oak0.obj",
					"res://mesh/plant/tree-oak1.obj",
					"res://mesh/plant/tree-oak2.obj",
					"res://mesh/plant/tree-oak3.obj"],
				'data' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'treepine' : {
				'instance' : 'plant',
				'mesh' : ["res://mesh/plant/tree-pine0.obj",
					"res://mesh/plant/tree-pine1.obj",
					"res://mesh/plant/tree-pine2.obj",
					"res://mesh/plant/tree-pine3.obj"],
				'data' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},
			'watercress' : {
				'instance' : 'plant',
				'mesh' : ["res://mesh/plant/watercress.obj"],
				'data' : {
					'growthrate' : 0,
					'lifespan' : 0,
					'weight' : 0,
					'HP' : 0,
					'hp' : 0
					}
				},

			'anvil' : {
				'instance' : 'tool',
				'mesh' : ["res://mesh/tool/anvil.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					}
				},
			'axeiron' : {
				'instance' : 'tool',
				'mesh' : ["res://mesh/tool/axe-iron.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					}
				},
			'axestone' : {
				'instance' : 'tool',
				'mesh' : ["res://mesh/tool/axe-stone.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					}
				},
			'bowlclay' : {
				'instance' : 'tool',
				'mesh' : ["res://mesh/tool/bowl-clay.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					}
				},
			'cupclay' : {
				'instance' : 'tool',
				'mesh' : ["res://mesh/tool/cup-clay.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					}
				},
			'firepit' : {
				'instance' : 'tool',
				'mesh' : ["res://mesh/tool/firepit.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					}
				},
			'hammeriron' : {
				'instance' : 'tool',
				'mesh' : ["res://mesh/tool/hammer-iron.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					}
				},
			'hammerstone' : {
				'instance' : 'tool',
				'mesh' : ["res://mesh/tool/hammerstone.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					}
				},
			'handaxe' : {
				'instance' : 'tool',
				'mesh' : ["res://mesh/tool/handaxe.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					}
				},
			'knifestone' : {
				'instance' : 'tool',
				'mesh' : ["res://mesh/tool/knife-stone.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					}
				},
			'pickaxeiron' : {
				'instance' : 'tool',
				'mesh' : ["res://mesh/tool/pickaxe-iron.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					}
				},
			'plateclay' : {
				'instance' : 'tool',
				'mesh' : ["res://mesh/tool/plate-clay.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					}
				},
			'spearstone' : {
				'instance' : 'tool',
				'mesh' : ["res://mesh/tool/spear-stone.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					}
				},
			'torch' : {
				'instance' : 'tool',
				'mesh' : ["res://mesh/tool/torch.obj"],
				'data' : {
					'weight' : 0.0,
					'HP' : 0.0,
					'hp' : 0.0
					}
				},

			'arrowiron' : {
				'instance' : 'projectile',
				'mesh' : ["res://mesh/weapon/arrow-iron.obj"],
				'data' : {
					'damage' : 0.0,
					'weight' : 0.0,
					'speed' : 0.0
				}
				},
			'arrowstone' : {
				'instance' : 'projectile',
				'mesh' : ["res://mesh/weapon/arrow-stone.obj"],
				'data' : {
					'damage' : 0.0,
					'weight' : 0.0,
					'speed' : 0.0
				}
				},
			'pulsecannon' : {
				'instance' : 'weapon',
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
				'instance' : 'fuel',
				'mesh' : ["res://mesh/weapon/pulse-cannon_charge.obj"],
				'data' : {
					'energy' : 0.0,
					'weight' : 0.0
				}
				},
			},



		"recipe" : {
			"" : {
				'give' : {},
				'need' : {}},
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
			'text' : "res://scene/ui/Text.tscn",
			},



		"settings" : {
			'game_seed' : '',
			'font_name' : '',
			'mouse_sensitivity' : 0.25,
			'wheel_sensitivity' : 0.25,
			'message_font' : 16,
			'effects' : 0.0,
			'music' : 0.0,
			},



		"allowance" : {
			'calorie' : 2200.0,
			'sat_fat' : 55000.0,
			'pol_fat' : 27500.0,
			'mon_fat' : 27500.0,
			'cholesterol' : 12000.0,
			'sodium' : 150.0,
			'fiber' : 1500.0,
			'sugar' : 1000.0,
			'protein' : 1750.0,
			'calcium' : 1100.0,
			'potassium' : 4700.0,
			'iron' : 8.0,
			'vitamin_a' : 0.8,
			'vitamin_c' : 80.0
		}



	}
	return vanilla
