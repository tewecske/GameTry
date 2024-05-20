extends CharacterBody2D

@onready var cave = $"../Cave"
@onready var minerAnimation = $MinerAnimation
@onready var miner = $Miner
@onready var pickaxe = $PickaxeNode/Pickaxe

signal collision_cave(player_position: Vector2i, collision_position: Vector2i, collision_normal: Vector2i)

var in_collision = false

const SPEED = 100.0

func start(pos):
	position = pos
	show()

func _ready():
	set_motion_mode(CharacterBody2D.MOTION_MODE_FLOATING)
	minerAnimation.play("idle")
	pickaxe.hide()
	hide()

var last_velocity = Vector2(0.0, 0.0)

func _physics_process(delta):

	var directionx = Input.get_axis("ui_left", "ui_right")
	if directionx:
		velocity.x = directionx * SPEED
		miner.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var directiony = Input.get_axis("ui_up", "ui_down")
	if directiony:
		velocity.y = directiony * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if velocity.length() > 0:
		last_velocity = velocity
		minerAnimation.play("run")
	else:
		minerAnimation.play("idle")

	Global.player_direction = Vector2i(directionx, directiony)
	Global.player_velocity = Vector2i(velocity) / 100

	move_and_slide()
	
	var slide_collision_count = get_slide_collision_count()
	for i in slide_collision_count:
		var slide_collision = get_slide_collision(i)
		print("slide_collision " + str(i) + ": " + str(cave.local_to_map(slide_collision.get_position())))
	
	#if !in_collision:
	var collision : KinematicCollision2D = get_last_slide_collision()
	if collision:
		var local_player_position = cave.local_to_map(position)
		var collider = collision.get_collider()
		var collision_normal : Vector2 = collision.get_normal()
		var collision_position : Vector2 = collision.get_position()
		
		in_collision = true
		Global.player_collision_position = cave.local_to_map(collision_position)
		Global.player_collision_normal = collision_normal
		collision_cave.emit(local_player_position, collision_position, collision_normal)


func _on_game_collision_ended() -> void:
	in_collision = false
