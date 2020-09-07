extends StaticBody

var id = ''

var mesh = {
	'surface' : "",
	'body' : "",
}

var data = {
	'growthrate' : 0,
	'lifespan' : 0,
	'density' : 0,
	'HP' : 0,
	'hp' : 0
}

func _ready():
	$Mesh.mesh = load(mesh['body'])
	$Mesh.material_override = load("res://skin/global_material.tres")
