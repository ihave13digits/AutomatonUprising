extends OmniLight

var mesh = {
	'body' : "",
}

func _ready():
	$Mesh.mesh = load(mesh['body'])
	$Mesh.material_override = load("res://skin/global_material.tres")

func prepare_glow(light, shade):
	light_color = light['color']
	light_energy = light['energy']
	light_specular = light['specular']
	
	shadow_color = shade['color']
	shadow_bias = shade['bias']
