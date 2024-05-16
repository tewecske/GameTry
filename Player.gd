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
	minerAnimation.play("idle")
	pickaxe.hide()
	hide()

var last_velocity = Vector2(0.0, 0.0)

func _physics_process(delta):

	if !in_collision:
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
	else:
		last_velocity -= last_velocity * delta
		velocity = last_velocity


	move_and_slide()
	
	#for index in get_slide_collision_count():
		#var collision : KinematicCollision2D = get_slide_collision(index)
	if !in_collision:
		var collision : KinematicCollision2D = get_last_slide_collision()
		if collision:
			var local_player_position = cave.local_to_map(position)
			print("player local player position " + str(position) + str(local_player_position))
			var collider = collision.get_collider()
			var collision_normal : Vector2 = collision.get_normal()
			var collision_position : Vector2 = collision.get_position()
			
			in_collision = true
			velocity = -last_velocity * 2
			collision_cave.emit(local_player_position, collision_position, collision_normal)
			move_and_slide()



func _on_game_collision_ended() -> void:
	in_collision = false
