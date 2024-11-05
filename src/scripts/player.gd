extends CharacterBody3D

class_name Player

const SPEED = 0.8
const ROTATION_SPEED = 12
const ANIMATION_SPEED_SCALE = 1.5
const JUMP_VELOCITY = 4.5
const ATTACK_COOLDOWN = 1.1
var attack_in_progress := false
var attack_delay := 0.0
var visual: Node3D
var animation: AnimationPlayer
var facing_direction := 1

func _ready() -> void:
	visual = get_node("main_character_prototype")
	animation = find_child("AnimationPlayer")
	animation.get_animation("sword_idle_2").loop_mode = Animation.LOOP_LINEAR
	var walk_anim = animation.get_animation("sword_walk")
	walk_anim.loop_mode = Animation.LOOP_LINEAR
	animation.speed_scale = ANIMATION_SPEED_SCALE
	animation.play("sword_idle_2")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action_attack"): attack()

func _process(delta: float) -> void:
	attack_delay = max(0, attack_delay - delta);
	if attack_delay == 0:
		attack_in_progress = false

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
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if !attack_in_progress and animation.current_animation != "sword_idle_2":
			animation.play("sword_idle_2")
	else:
		if !attack_in_progress:
			velocity.x = move_dir * SPEED * ANIMATION_SPEED_SCALE
			if animation.current_animation != "sword_walk":
				animation.play("sword_walk")

			# Change facing direction
			facing_direction = move_dir
	move_and_slide()

func attack() -> void:
	if attack_delay > 0:
		return
	
	attack_in_progress = true
	velocity.x = 0
	attack_delay = ATTACK_COOLDOWN
	animation.play("sword_slash")
