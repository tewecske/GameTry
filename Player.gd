extends CharacterBody2D

@onready var cave = $"../Cave"

signal collision_cave

const SPEED = 100.0

func _ready():
	$AnimatedSprite2D.play()

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionx = Input.get_axis("ui_left", "ui_right")
	if directionx:
		velocity.x = directionx * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var directiony = Input.get_axis("ui_up", "ui_down")
	if directiony:
		velocity.y = directiony * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	
	#for index in get_slide_collision_count():
		#var collision : KinematicCollision2D = get_slide_collision(index)
	var collision : KinematicCollision2D = get_last_slide_collision()
	if collision:
		var collision_angle : float = collision.get_angle()
		var collider = collision.get_collider() 
		var collision_normal : Vector2 = collision.get_normal()
		var collision_position : Vector2 = collision.get_position()
		#print("collision_angle " + str(collision_angle))
		#print("collider " + str(collider))
		print("collision_normal " + str(collision_normal))
		var local_player_position = cave.local_to_map(position)
		print("local player position " + str(local_player_position))
		print("local collision_position " + str(cave.local_to_map(collision_position)))
		
		var collision_update = local_player_position - Vector2i(collision_normal)
		collision_cave.emit(collision_update)

