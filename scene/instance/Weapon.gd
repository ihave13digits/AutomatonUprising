extends StaticBody

var id = ''

var mesh = {
	'body' : "",
}

var data = {
	'damage' : 0,
	'weight' : 0,
	'range' : 0,
	'HP' : 0,
	'hp' : 0,
}

func _ready():
	$Mesh.mesh = load(mesh['body'])
	$Mesh.material_override = load("res://skin/global_material.tres")
