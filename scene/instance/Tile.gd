extends StaticBody

var id = "tile"

var mesh = {
	'body' : "",
}

func _ready():
	$Mesh.mesh = load(mesh['body'])
	$Box.shape = $Mesh.create_trimesh_collision()
