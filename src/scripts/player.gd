extends CharacterBody3D

class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var visual: Node3D
var animation: AnimationPlayer

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
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_backward", "move_forward", "ui_left", "ui_left")
	var direction := (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	if direction:
		if direction.x > 0:
			visual.rotation_degrees.y = 90;
		else:
			visual.rotation_degrees.y = -90;
		velocity.x = direction.x * SPEED
		velocity.z = 0
		if animation.current_animation != "sword_walk":
			animation.play("sword_walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = 0
		if animation.current_animation != "sword_idle_2":
			animation.play("sword_idle_2")

	move_and_slide()
