extends StaticBody

var id = "tile"

var type = ""

var mesh = {
	'body' : "",
}

func _ready():
	$Mesh.mesh = load(mesh['body'])
	$Mesh.material_override = load("res://skin/global_material.tres")
	set_collision(type)

func set_collision(t):
	var mdt = MeshDataTool.new()
	mdt.create_from_surface($Mesh.mesh, 0)

	if t == 'vex':
		var point_array = []
		for v in range(mdt.get_vertex_count()):
			var vtx = mdt.get_vertex(v)
			point_array.append(vtx)
		
		$Box.shape = ConvexPolygonShape.new()
		$Box.shape.set_points(point_array)
	if t == 'cave':
		var face_array = [
			[Vector3(1, 1, 1), Vector3(0, 0, 0), Vector3(-1, -1, 1)],
			[Vector3(0, 0, 0), Vector3(0, 0, 0), Vector3(0, 0, 0)],
			[Vector3(0, 0, 0), Vector3(0, 0, 0), Vector3(0, 0, 0)],
			[Vector3(0, 0, 0), Vector3(0, 0, 0), Vector3(0, 0, 0)]
		]
		for f in range(mdt.get_face_count()):
			var face = mdt.get_face_meta(f)
			face_array.append(face)
		$Box.shape = ConcavePolygonShape.new()
		$Box.shape.set_faces(PoolVector3Array(face_array))
