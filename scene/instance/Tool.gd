extends StaticBody

var id = ''

var mesh = {
	'body' : "",
}

var use = {
	'consume' : false,
	'destroy' : false,
	'harvest' : false,
	'repair' : false,
	'build' : false,
	'craft' : false,
	'light' : false
}

var data = {
	'weight' : 0.0,
	'HP' : 0.0,
	'hp' : 0.0
}

func _ready():
	$Mesh.mesh = load(mesh['body'])
	$Mesh.material_override = load("res://skin/global_material.tres")
