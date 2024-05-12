extends Node2D

@onready var cave : TileMap = $Cave

@export var noise_height_texture :  NoiseTexture2D

const cave_layer : int = 0
const source_id : int = 0
const terrain_set : int = 0
const terrain_id : int = 0
const clear_terrain_id : int = -1

const width : int = 100
const height : int = 100

var draw_dragging = false
var clear_dragging = false

var noise : Noise

var TEST_noise_arr = []

func _ready():
	noise = noise_height_texture.noise
	generate_world()

func generate_world():
	for x in range(-width / 2, width / 2):
		for y in range(-height / 2, height / 2):
			var noise_value : float = noise.get_noise_2d(x, y)
			TEST_noise_arr.append(noise_value)
			if noise_value >= 0.0:
				#cave.set_cell(cave_layer, Vector2i(x, y), source_id, Vector2i(3, 3))
				cave.set_cells_terrain_connect(cave_layer, [Vector2i(x, y)], 0, 0, true)
	print("highest ", TEST_noise_arr.max())
	print("lowest ", TEST_noise_arr.min())
	

func _process(delta):
	pass

func _input(event):
	#var click_event = Input.is_action_just_pressed("click")
	#var right_click_event = Input.is_action_just_pressed("rightclick")
	if Input.is_action_pressed("click"):
		draw_dragging = true
		draw_tile_mouse()
	elif Input.is_action_pressed("rightclick"):
		clear_dragging = true
		clear_tile_mouse()
	elif Input.is_action_just_released("click"):
		draw_dragging = false
	elif Input.is_action_just_released("rightclick"):
		clear_dragging = false
	
	if event is InputEventMouseMotion and draw_dragging:
		draw_tile_mouse()
	if event is InputEventMouseMotion and clear_dragging:
		clear_tile_mouse()
		
func draw_tile_mouse():
	var mouse_pos : Vector2 = get_global_mouse_position()
	var local_mouse_pos : Vector2i = cave.local_to_map(mouse_pos)
	cave.set_cells_terrain_connect(cave_layer, [local_mouse_pos], terrain_set, terrain_id, true)

func clear_tile_mouse():
	var mouse_pos : Vector2 = get_global_mouse_position()
	var local_mouse_pos : Vector2i = cave.local_to_map(mouse_pos)
	cave.set_cells_terrain_connect(cave_layer, [local_mouse_pos], terrain_set, clear_terrain_id, true)
	
func clear_tile(pos : Vector2i):
	var local_pos : Vector2i = cave.local_to_map(pos)
	cave.set_cells_terrain_connect(cave_layer, [local_pos], terrain_set, clear_terrain_id, true)
	
const ADJ_VECS = [
	Vector2i(0,1),
	Vector2i(0,-1),
	Vector2i(1,0),
	Vector2i(-1,0),
	Vector2i(1,1),
	Vector2i(-1,1),
	Vector2i(1,-1),
	Vector2i(-1,-1),
	]
func clearCellFromPosition(pos):
	var cell = cave.local_to_map(pos)
	if cell != null:
		var cellsToUpdate = []
		print("Cell found ", cell)
		print(cave.get_cell_tile_data(0, cell))
		cave.set_cell(-1, cell)
		print(cave.get_cell_tile_data(0, cell))
		print(cave.get_surrounding_cells(cell))
		for nebCell in ADJ_VECS:
			if cave.get_cell_tile_data(0, cell + nebCell) != null:
				cellsToUpdate.append(cell + nebCell)
				
		print(cellsToUpdate)
		
		cave.set_cells_terrain_connect(0, cell, 0, -1, true)
		
	else:
		print("Cell not found at ", pos)
		
