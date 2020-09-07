extends StaticBody

var id = ''

var mesh = {
	'body' : "",
}

var data = {
	'weight' : 0,
}

func _ready():
	$Mesh.mesh = load(mesh['body'])
	$Mesh.material_override = load("res://skin/global_material.tres")
