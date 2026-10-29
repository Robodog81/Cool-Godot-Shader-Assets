extends CharacterBody2D
var slide_vel: Vector2 = Vector2(0, 0)

@export var speed = 20

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	slide_vel += input_direction * speed
	slide_vel *= 0.8
	velocity = slide_vel

func _physics_process(delta):
	get_input()
	move_and_slide()
