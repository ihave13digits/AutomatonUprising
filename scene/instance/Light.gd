extends OmniLight

func prepare_glow(light, shade):
	light_color = light['color']
	light_energy = light['energy']
	light_specular = light['specular']
	
	shadow_color = shade['color']
	shadow_bias = shade['bias']
