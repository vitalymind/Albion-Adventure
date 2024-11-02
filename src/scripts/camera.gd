extends Camera3D

var player: Player
var offset := Vector2(0,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = player.position.x + offset.x
	position.y = player.position.y + offset.y
	pass
