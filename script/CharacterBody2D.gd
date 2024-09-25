extends CharacterBody2D

var speedX = 0
var speedY = 0
var dash_speed = 300
const slowness = 10
const  maxSpeed = 120
var current_dir = 'front'
var attack = false
var timer = 0
var timer_dash = 0
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var can_take_damagee = false
	
func _physics_process(delta):
	enemy_attack()
	player_movement(delta)
	play_anim(speedX, speedY)
	
	if health <= 0:
		player_alive = false 
		health = 0
		print("player has been killed")
		self.queue_free()
	
func player_movement(_delta):
	velocity.y = speedY
	velocity.x = speedX
	
			
	# Desaceleration code
	if speedX > 0:
		speedX -= slowness
	elif speedX < 0:
		speedX += slowness
		
	if speedY > 0:
		speedY -= slowness	
	elif speedY < 0:
		speedY += slowness
		
	if Input.is_action_pressed("ui_click") and timer_dash == 0:
			attack = true
			Global.player_current_attack = true
		

	
	if attack != true:
		Global.player_current_attack = false
		
		if timer_dash == 0:
			# Movement code
			if Input.is_action_pressed('ui_right'):
				
				speedX += 35
				if speedX > maxSpeed:
					speedX = maxSpeed


			if Input.is_action_pressed('ui_left'):
				
				speedX -= 35
				if speedX < -maxSpeed:
					speedX = -maxSpeed


			if Input.is_action_pressed('ui_down'):
				
				speedY += 35
				if speedY > maxSpeed:
					speedY = maxSpeed


			if Input.is_action_pressed('ui_up'):
				
				speedY -= 35
				if speedY < -maxSpeed:
					speedY = -maxSpeed
					
			if Input.is_action_pressed('ui_dash'):
				if speedX != 0 or speedY != 0:
					timer_dash += 1
					if speedX > 0:
						speedX = dash_speed
					elif speedX < 0:
						speedX = -dash_speed
					if speedY > 0:
						speedY = dash_speed
					elif speedY < 0:
						speedY = -dash_speed
				
			
		if timer_dash > 0:
			timer_dash += 1
			if timer_dash > 50:
				timer_dash = 0
			
		move_and_slide()
		
		
	
func play_anim(_speedX, _speedY):
	var anim = $AnimatedSprite2D
	
			
	if attack != true:
		Global.player_current_attack = false
		if timer_dash == 0:
			if abs(_speedX) > abs(_speedY):
				if _speedX > 0:
					anim.play("side_walk")
					anim.flip_h = false
					current_dir = 'side'
				else:
					anim.play("side_walk")
					anim.flip_h = true
					current_dir = 'side'
				
			if abs(_speedX) < abs(_speedY):
				if _speedY > 0:
					anim.play("front_walk")
					current_dir = 'front'
				else:
					anim.play("back_walk")
					current_dir = 'back'
					
			if _speedX == 0 and _speedY == 0:
				anim.play(current_dir)
				
		else:
			anim.play("die")
			
			
	
	else:
		anim.play(current_dir + '_attack')
		timer += 1
		if timer > 30:
			attack = false
			timer = 0
	
func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true
		can_take_damagee = true 

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false
		can_take_damagee = false
		
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown and can_take_damagee == true:
		health = health -5
		$attack_cooldown.start() 
		enemy_attack_cooldown = false
		health = health -5
		print("player health =" ,health)
		
		
func _on_attack_cooldown_timeout(): 
	enemy_attack_cooldown = true
	
	
	

