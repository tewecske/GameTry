extends Control

@onready var playerPos = $PlayerPos
@onready var playerUp = $PlayerUp
@onready var playerRight = $PlayerRight
@onready var playerDown = $PlayerDown
@onready var playerLeft = $PlayerLeft
@onready var fps = $FPS

func update():
	playerPos.text = str(Global.player_location)
	playerUp.text = vecsToString(Global.player_up, Global.player_up_atlas)
	playerRight.text = vecsToString(Global.player_right, Global.player_right_atlas)
	playerDown.text = vecsToString(Global.player_down, Global.player_down_atlas)
	playerLeft.text = vecsToString(Global.player_left, Global.player_left_atlas)

func vecsToString(pos: Vector2i, atlas_pos: Vector2i):
	return "P:" + str(pos.x) + "," + str(pos.y) + "\nA:" + str(atlas_pos.x) + "," + str(atlas_pos.y)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update()
