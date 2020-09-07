extends StaticBody

var id = ""

var mesh = {
	'body' : "",
}

var data = {
	'energy' : 0.0,
	'weight' : 0.0
}

func _ready():
	$Mesh.mesh = load(mesh['body'])
	$Mesh.material_override = load("res://skin/global_material.tres")
