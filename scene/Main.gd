extends Node

var world
var player

func _ready():
	add_player()
	$HUD.cursor.position = OS.get_real_window_size() / 2

func _process(_delta):
	if Input.is_action_just_pressed("ui_up"):
		$HUD.display_message('stacked popup test')
	if Input.is_action_just_pressed("ui_left"):
		$HUD.display_stats(player.data)
	if Input.is_action_just_pressed("ui_right"):
		$HUD.display_nutrition(player.nutrients)

func _update_hud():
	$HUD.cursor.position = OS.get_real_window_size() / 2

func add_player():
	player = spawn('player')
	player.mesh['body'] = Data.object['player']['mesh'][0]
	#player.mesh['hand'] = Data.object['apple']['mesh'][0]
	
	player.set_held(Data.object['apple']['mesh'][0])
	player.ready()
	add_child(player)
	player.connect('update_hud', self, '_update_hud')
	

func mesh(m):
	var M = load(Data.object[m])
	return M

func spawn(i):
	var I = load(Data.instance[i])
	return I.instance()
