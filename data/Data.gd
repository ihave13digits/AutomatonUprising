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
				'mesh' : [],
				'data' : {}
			},
			'dronefighter' : {
				'mesh' : [],
				'data' : {}
			},
			'dronescout' : {
				'mesh' : [],
				'data' : {}
			},
			'player' : {
				'mesh' : [],
				'data' : {}
			},

			'apple' : {
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
				'mesh' : ["res://mesh/material/acorn.obj"],
				'data' : {}
				},
			'boulder' : {
				'mesh' : ["res://mesh/material/boulder0.obj",
					"res://mesh/material/boulder1.obj",
					"res://mesh/material/boulder2.obj",
					"res://mesh/material/boulder3.obj"],
				'data' : {}
				},
			'hive' : {
				'mesh' : ["res://mesh/material/hive.obj"],
				'data' : {}
				},
			'pinecone' : {
				'mesh' : ["res://mesh/material/pinecone.obj"],
				'data' : {}
				},
			'stone' : {
				'mesh' : ["res://mesh/material/stone0.obj",
					"res://mesh/material/stone1.obj",
					"res://mesh/material/stone2.obj",
					"res://mesh/material/stone3.obj"],
				'data' : {}
				},

			'amaranth' : {
				'mesh' : ["res://mesh/plant/amaranth.obj"],
				'data' : {}
				},
			'bush0' : {
				'mesh' : ["res://mesh/plant/bush0.obj",
					"res://mesh/plant/bush1.obj",
					"res://mesh/plant/bush2.obj",
					"res://mesh/plant/bush3.obj"],
				'data' : {}
				},
			'cattail' : {
				'mesh' : ["res://mesh/plant/cattail.obj"],
				'data' : {}
				},
			'clover' : {
				'mesh' : ["res://mesh/plant/clover.obj"],
				'data' : {}
				},
			'purslane' : {
				'mesh' : ["res://mesh/plant/purslane.obj"],
				'data' : {}
				},
			'treeash' : {
				'mesh' : ["res://mesh/plant/tree-ash0.obj",
					"res://mesh/plant/tree-ash1.obj",
					"res://mesh/plant/tree-ash2.obj",
					"res://mesh/plant/tree-ash3.obj"],
				'data' : {}
				},
			'treeoak' : {
				'mesh' : ["res://mesh/plant/tree-oak0.obj",
					"res://mesh/plant/tree-oak1.obj",
					"res://mesh/plant/tree-oak2.obj",
					"res://mesh/plant/tree-oak3.obj"],
				'data' : {}
				},
			'treepine' : {
				'mesh' : ["res://mesh/plant/tree-pine0.obj",
					"res://mesh/plant/tree-pine1.obj",
					"res://mesh/plant/tree-pine2.obj",
					"res://mesh/plant/tree-pine3.obj"],
				'data' : {}
				},
			'watercress' : {
				'mesh' : ["res://mesh/plant/watercress.obj"],
				'data' : {}
				},

			'anvil' : {
				'mesh' : ["res://mesh/tool/anvil.obj"],
				'data' : {}
				},
			'axeiron' : {
				'mesh' : ["res://mesh/tool/axe-iron.obj"],
				'data' : {}
				},
			'axestone' : {
				'mesh' : ["res://mesh/tool/axe-stone.obj"],
				'data' : {}
				},
			'bowlclay' : {
				'mesh' : ["res://mesh/tool/bowl-clay.obj"],
				'data' : {}
				},
			'cupclay' : {
				'mesh' : ["res://mesh/tool/cup-clay.obj"],
				'data' : {}
				},
			'firepit' : {
				'mesh' : ["res://mesh/tool/firepit.obj"],
				'data' : {}
				},
			'hammeriron' : {
				'mesh' : ["res://mesh/tool/hammer-iron.obj"],
				'data' : {}
				},
			'hammerstone' : {
				'mesh' : ["res://mesh/tool/hammerstone.obj"],
				'data' : {}
				},
			'handaxe' : {
				'mesh' : ["res://mesh/tool/handaxe.obj"],
				'data' : {}
				},
			'knifestone' : {
				'mesh' : ["res://mesh/tool/knife-stone.obj"],
				'data' : {}
				},
			'pickaxeiron' : {
				'mesh' : ["res://mesh/tool/pickaxe-iron.obj"],
				'data' : {}
				},
			'plateclay' : {
				'mesh' : ["res://mesh/tool/plate-clay.obj"],
				'data' : {}
				},
			'spearstone' : {
				'mesh' : ["res://mesh/tool/spear-stone.obj"],
				'data' : {}
				},
			'torch' : {
				'mesh' : ["res://mesh/tool/torch.obj"],
				'data' : {}
				},

			'arrowiron' : {
				'mesh' : ["res://mesh/weapon/arrow-iron.obj"],
				'data' : {}
				},
			'arrowstone' : {
				'mesh' : ["res://mesh/weapon/arrow-stone.obj"],
				'data' : {}
				},
			'pulsecannon' : {
				'mesh' : ["res://mesh/weapon/pulse-cannon.obj"],
				'data' : {}
				},
			'pulsecharge' : {
				'mesh' : ["res://mesh/weapon/pulse-cannon_charge.obj"],
				'data' : {}
				},
			},



		"recipe" : {
			"" : {
				'give' : {},
				'need' : {}},
			},



		"instance" : {
			'drone' : "res://scene/entity/Drone.tscn",
			'player' : "res://scene/entity/Player.tscn",
			'food' : "res://scene/food/Food.tscn",
			'material' : "res://scene/material/Material.tscn",
			'cluster' : "res://scene/plant/Cluster.tscn",
			'plant' : "res://scene/plant/Plant.tscn",
			'tool' : "res://scene/tool/Tool.tscn",
			'weapon' : "res://scene/weapon/Weapon.tscn",
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
