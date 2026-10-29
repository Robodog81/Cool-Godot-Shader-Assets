extends CharacterBody2D
const INPUTCOOLDOWN = 10
const MOVEMENTSPEED = 20
const TILESIZE = 16

var slide_vel: Vector2 = Vector2(0, 0)
var target_pos: Vector2 = Vector2(0, 0)

var input_cooldown_timer = 0
@export var speed = 20

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	if (input_cooldown_timer == 0):
		var movement_dir = round(input_direction) * TILESIZE
		# multiply the intended movement direction vec 2 by the collision vector
		# if there is a collision in an axis collision() will return that axis false
		# the movement vector on that axis is multiplied by 'false' cancelling that move
		# this allows you to slide along walls if you hold into them
		target_pos += movement_dir * collision(input_direction)
		if (input_direction.length() > 0):
			input_cooldown_timer += INPUTCOOLDOWN
	else:
		input_cooldown_timer -= 1
	velocity = (target_pos - position) * MOVEMENTSPEED

func collision(direction) -> Vector2:
	# individually checks for a collision on the x and y axis
	# inverts them so a collision in that axis is a 'false' as is can't move there
	var x_move = direction.x * TILESIZE
	var y_move = direction.y * TILESIZE
	var player_pos = self.transform
	
	var can_move_x = !test_move(player_pos, Vector2(x_move, 0))
	player_pos.origin.x += x_move * float(can_move_x)
	var can_move_y = !test_move(player_pos, Vector2(0, y_move))
	# move from the new point on the x axis
	# pack the collision into a vec2 of booleans
	var collision_vector = Vector2(can_move_x, can_move_y)
	return collision_vector

func _physics_process(delta):
	get_input()
	move_and_slide()
