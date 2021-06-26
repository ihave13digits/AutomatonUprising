extends Control

var noise_bump
var noise_height
var noise_water
var noise_heat

onready var heat = $Heat
onready var height = $Height
#onready var bump = $Bump
onready var water = $Water

onready var heat_value = $HeatValue
onready var height_value = $HeightValue
onready var bump_value = $BumpValue
onready var water_value = $WaterValue

onready var heat_rough = $HeatRough
onready var height_rough = $HeightRough
onready var bump_rough = $BumpRough
onready var water_rough = $WaterRough

onready var heat_gap = $HeatGap
onready var height_gap = $HeightGap
onready var bump_gap = $BumpGap
onready var water_gap = $WaterGap

onready var heat_fade = $HeatFade
onready var height_fade = $HeightFade
onready var bump_fade = $BumpFade
onready var water_fade = $WaterFade

func _ready():
	noise_bump = load(Data.noise['bump'])
	noise_height = load(Data.noise['height'])
	noise_water = load(Data.noise['water'])
	noise_heat = load(Data.noise['heat'])
	
	var limit = Data.physics['world_size']*Data.physics['chunk_size']
	
	set_noise_values(
		noise_bump,
		Data.settings['game_seed']['value'].hash(),
		Data.physics['bump_scale'],
		Data.physics['bump_rough'],
		Data.physics['bump_gap'],
		Data.physics['bump_fade'])
	set_noise_values(
		noise_height,
		Data.settings['game_seed']['value'].hash(),
		Data.physics['height_scale'],
		Data.physics['height_rough'],
		Data.physics['height_gap'],
		Data.physics['height_fade'])
	set_noise_values(
		noise_heat,
		Data.settings['game_seed']['value'].hash(),
		Data.physics['heat_scale'],
		Data.physics['heat_rough'],
		Data.physics['heat_gap'],
		Data.physics['heat_fade'])
	set_noise_values(
		noise_water,
		Data.settings['game_seed']['value'].hash(),
		Data.physics['water_scale'],
		Data.physics['water_rough'],
		Data.physics['water_gap'],
		Data.physics['water_fade'])
	
	#set_noise_size(bump, limit, limit)
	set_noise_size(height, limit, limit)
	set_noise_size(heat, limit, limit)
	set_noise_size(water, limit, limit)
	
	#set_noise_texture(bump, noise_bump)
	set_noise_texture(height, noise_height)
	set_noise_texture(heat, noise_heat)
	set_noise_texture(water, noise_water)
	
	modify_value(noise_height, Data.physics['bump_scale'])
	modify_value(noise_bump, Data.physics['height_scale'])
	modify_value(noise_heat, Data.physics['heat_scale'])
	modify_value(noise_water, Data.physics['water_scale'])
	
	modify_rough(noise_height, Data.physics['bump_rough'])
	modify_rough(noise_bump, Data.physics['height_rough'])
	modify_rough(noise_heat, Data.physics['heat_rough'])
	modify_rough(noise_water, Data.physics['water_rough'])
	
	modify_gap(noise_height, Data.physics['bump_gap'])
	modify_gap(noise_bump, Data.physics['height_gap'])
	modify_gap(noise_heat, Data.physics['heat_gap'])
	modify_gap(noise_water, Data.physics['water_gap'])
	
	modify_fade(noise_height, Data.physics['bump_fade'])
	modify_fade(noise_bump, Data.physics['height_fade'])
	modify_fade(noise_heat, Data.physics['heat_fade'])
	modify_fade(noise_water, Data.physics['water_fade'])
	
	bump_value.value = float(Data.physics['bump_scale'])/256.0
	height_value.value = float(Data.physics['height_scale'])/256.0
	heat_value.value = float(Data.physics['heat_scale'])/256.0
	water_value.value = float(Data.physics['water_scale'])/256.0
	
	bump_rough.value = float(Data.physics['bump_rough'])/6.0
	height_rough.value = float(Data.physics['height_rough'])/6.0
	heat_rough.value = float(Data.physics['heat_rough'])/6.0
	water_rough.value = float(Data.physics['water_rough'])/6.0
	
	bump_gap.value = float(Data.physics['bump_gap'])/4.0
	height_gap.value = float(Data.physics['height_gap'])/4.0
	heat_gap.value = float(Data.physics['heat_gap'])/4.0
	water_gap.value = float(Data.physics['water_gap'])/4.0
	
	bump_fade.value = Data.physics['bump_fade']
	height_fade.value = Data.physics['height_fade']
	heat_fade.value = Data.physics['heat_fade']
	water_fade.value = Data.physics['water_fade']

func save_noise_values():
	pass

func set_noise_size(t, x, y):
	t.rect_size.x = x
	t.rect_size.y = y

func set_noise_values(n, sd, pd, oc, la, pr):
	n.seed = sd
	n.period = pd
	n.octaves = oc
	n.lacunarity = la
	n.persistence = pr

func set_noise_texture(t, n):
	t.texture.noise = n


func modify_alpha(t, value):
	t.modulate.a = value

func modify_value(n, value):
	n.period = 256.0*value
func modify_rough(n, value):
	n.octaves = int(6*value)
func modify_gap(n, value):
	n.lacunarity = 4.0*value
func modify_fade(n, value):
	n.persistence = value


func _on_Button_pressed():
	print("done")


func _on_HeightValue_value_changed(value):
	modify_value(noise_height, value)
func _on_BumpValue_value_changed(value):
	modify_value(noise_bump, value)
func _on_HeatValue_value_changed(value):
	modify_value(noise_heat, value)
func _on_WaterValue_value_changed(value):
	modify_value(noise_water, value)

func _on_HeightRough_value_changed(value):
	modify_rough(noise_height, value)
func _on_BumpRough_value_changed(value):
	modify_rough(noise_bump, value)
func _on_HeatRough_value_changed(value):
	modify_rough(noise_heat, value)
func _on_WaterRough_value_changed(value):
	modify_rough(noise_water, value)

func _on_HeightGap_value_changed(value):
	modify_gap(noise_height, value)
func _on_BumpGap_value_changed(value):
	modify_gap(noise_bump, value)
func _on_HeatGap_value_changed(value):
	modify_gap(noise_heat, value)
func _on_WaterGap_value_changed(value):
	modify_gap(noise_water, value)

func _on_HeightFade_value_changed(value):
	modify_fade(noise_height, value)
func _on_BumpFade_value_changed(value):
	modify_fade(noise_bump, value)
func _on_HeatFade_value_changed(value):
	modify_fade(noise_heat, value)
func _on_WaterFade_value_changed(value):
	modify_fade(noise_water, value)
