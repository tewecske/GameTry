extends CharacterBody2D

@onready var cave = $"../Cave"
@onready var miner_animation = $MinerAnimation
@onready var miner = $Miner
@onready var pickaxe = $PickaxeNode/Pickaxe
@onready var pickaxe_animation = $PickaxeNode/PickaxeAnimation
@onready var pike_node: Node2D = $PikeNode
@onready var pike: Sprite2D = $PikeNode/Pike
@onready var pike_animation: AnimationPlayer = $PikeNode/PikeAnimation

signal collision_cave(player_position: Vector2i, collision_position: Vector2i, collision_normal: Vector2i)

var in_collision = false
var mining = false

@onready var tool_node := pike_node
@onready var tool := pike
@onready var tool_animation := pike_animation

const SPEED = 100.0

func start(pos):
	position = pos
	show()

func _ready():
	set_motion_mode(CharacterBody2D.MOTION_MODE_FLOATING)
	miner_animation.play("idle")
	tool.hide()
	hide()

var last_velocity = Vector2(0.0, 0.0)

func _process(delta: float) -> void:
	if !tool_animation.is_playing():
		tool.hide()

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
		miner_animation.play("run")
	else:
		miner_animation.play("idle")

	Global.player_direction = Vector2i(directionx, directiony)
	Global.player_velocity = Vector2i(velocity) / 100

	move_and_slide()
	
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

func mine_animation():
	mining = true
	if !tool_animation.assigned_animation == "mine" or !tool_animation.is_playing():
		tool.show()
		print("tool.position " + str(tool.position))
		if velocity.x < 0:
			tool.flip_h = true
			tool.offset.x = -8
			tool_node.set_rotation_degrees(0)
			tool_animation.play("mine", -1)
		elif velocity.x > 0:
			tool.flip_h = false
			tool.offset.x = 0
			tool_node.set_rotation_degrees(0)
			tool_animation.play("mine")
		elif velocity.y > 0:
			tool.flip_h = false
			if miner.flip_h:
				tool_node.position.x = 5
			else:
				tool_node.position.x = 0
			tool_node.set_rotation_degrees(90)
			tool_animation.play("mine")
		elif velocity.y < 0:
			tool.flip_h = false
			if miner.flip_h:
				tool_node.position.x = -5
			else:
				tool_node.position.x = 0
			tool_node.set_rotation_degrees(-90)
			tool_animation.play("mine")

func _on_game_collision_ended() -> void:
	in_collision = false

