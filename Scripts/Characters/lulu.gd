extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const footstep_frames : Array = [2,6]

#sons
@export var sfx_footsteps : AudioStream


func _physics_process(delta: float) -> void:
	handle_movements(delta)
	move_and_slide()


func handle_movements(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		%AnimatedSprite2D.play("walk")
		if direction == 1:
			%AnimatedSprite2D.flip_h = false
		elif direction == -1:
			%AnimatedSprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		%AnimatedSprite2D.play("idle")


#Contrôle les animations
func _on_animated_sprite_2d_frame_changed() -> void:
	#Joue de manière random un clignement des yeux pour la rendre plus naturelle
	if %AnimatedSprite2D.animation == "idle":
		if %AnimatedSprite2D.frame == 2:
			var rng = randf()
			if rng > 0.8:
				%AnimatedSprite2D.play("idle_2")
	#Joue le bruit des pas sur sol "classique"
	if %AnimatedSprite2D.animation == "walk":
		load_sfx(sfx_footsteps)
		if %AnimatedSprite2D.frame in footstep_frames: $sfx_player.play()
			


func _on_animated_sprite_2d_animation_finished() -> void:
	#lorsque clignement des yeux fini, on reprendre "idle"
	if %AnimatedSprite2D.animation == "idle_2":
		%AnimatedSprite2D.play("idle")

func load_sfx(sfx_to_load) -> void:
	if $sfx_player.stream != sfx_to_load:
		$sfx_player.stop()
		$sfx_player.stream = sfx_to_load
