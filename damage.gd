extends TextureRect


func setup(pos: Vector2i, hp: int):
	var txt: NoiseTexture2D = get_texture()
	var noise: FastNoiseLite = txt.get_noise()
	noise.set_seed(randi())
	var cramp: Gradient = txt.get_color_ramp()
	cramp.set_offset(1, 0.33 * hp)

	set_global_position((pos * 16))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
