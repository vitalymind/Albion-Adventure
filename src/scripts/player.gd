extends CharacterBody3D

class_name Player

const SPEED = 0.8
const ROTATION_SPEED = 12
const JUMP_VELOCITY = 4.5
var visual: Node3D
var animation: AnimationPlayer
var facing_direction := 1

func _ready() -> void:
	visual = get_node("main_character_prototype")
	animation = find_child("AnimationPlayer")
	animation.get_animation("sword_idle_2").loop_mode = Animation.LOOP_LINEAR
	animation.get_animation("sword_walk").loop_mode = Animation.LOOP_LINEAR
	animation.play("sword_idle_2")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("action_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Enforce z position
	velocity.z = 0
	position.z = 0

	# Rotate
	rotation.y = clamp(rotation.y + ROTATION_SPEED * delta * facing_direction, -PI + 0.001, 0);
		
	# Movement
	var input := Input.get_vector("move_backward", "move_forward", "action_down", "action_up")
	var move_dir := input[0] as int
	
	if move_dir == 0:
		velocity.x = 0
		# velocity.x = move_toward(velocity.x, 0, SPEED)
		if animation.current_animation != "sword_idle_2":
			animation.play("sword_idle_2")
	else:
		velocity.x = move_dir * SPEED
		if animation.current_animation != "sword_walk":
			animation.play("sword_walk")

		# Change facing direction
		facing_direction = move_dir
			


	move_and_slide()
