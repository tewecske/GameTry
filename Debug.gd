extends Control

@onready var player = $PlayerPos
@onready var fps = $FPS

func update():
	player.text = "Player Pos:\n" + str(Global.player_location)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update()
