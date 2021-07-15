extends KinematicBody2D

export var run_speed = 100
export var gravity = 2000
export var jump_speed =- 500
var velocity = Vector2()
var doubleJumpcount = 0

export var animations = []
var isRight = true

var bullet = preload("res://Scenes/Bullets.tscn")

var isLive = true
var player_health = 10

var keycount = 0

func _ready():
	GameManager.player = self 

func get_input() :
	velocity.x = 0
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var jump = Input.is_action_just_pressed("ui_up")
	var shoot = Input.is_action_just_pressed("ui_fire")
		
	#double jump
	if(is_on_floor() || doubleJumpcount == 1 ) and jump :
		velocity.y = jump_speed
		doubleJumpcount += 1
		
	if right :
		velocity.x += run_speed
		isRight = true
		if is_on_floor() :
			play_player_ani(1, isRight)
		
	if left :
		velocity.x -= run_speed
		isRight = false
		if is_on_floor() :
			play_player_ani(1, isRight)
			
	if shoot :
		play_player_ani(3, isRight)
		if isRight :
			fire($ShootRight.global_position, $ShootRight.global_rotation)
		else :
			fire($ShootLeft.global_position, $ShootLeft.global_rotation)
		
	if !is_on_floor() :
		if !isPlaying(animations[3]) :
			play_player_ani(2, isRight)
		
func _physics_process(delta):
	if !isLive :
		return
	velocity.y += gravity * delta
	get_input()
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if velocity.is_equal_approx(Vector2.ZERO) :
		doubleJumpcount = 0
		if !isPlaying(animations[3]) :
			play_player_ani(0, isRight)

func play_player_ani(_aniIndex : int,_isRight : bool) :
	$CollisionPlayer/PlayerAnimSprite.animation = animations[_aniIndex]
	$CollisionPlayer/PlayerAnimSprite.flip_h =! isRight
	
func isPlaying(aniName:String) -> bool :
	if aniName == $CollisionPlayer/PlayerAnimSprite.animation and $CollisionPlayer/PlayerAnimSprite.frame < 5 :
		return true
	return false
	
func fire(bulletPos, bulletRot) :
	var new_bullet = bullet.instance()
	add_child(new_bullet)
	new_bullet.global_position = bulletPos
	new_bullet.global_rotation = bulletRot

func hit_by_enemy() :
	if !isLive :
		return
	
	player_health -= 2
	GameManager.gui.player_health_bar(player_health)
	if player_health == 0.0 :
		isLive = false
		play_player_ani(4, isRight)
		yield($CollisionPlayer/PlayerAnimSprite, "animation_finished")
		GameManager.gui.show_winlose("Maaf Kamu Belum Berhasil")
		
func collect_item():
	keycount += 1
	if keycount == 5 :
		GameManager.gui.show_winlose("Selamat Kamu Berhasil")
		pass
	keycount = clamp(keycount,0,5)
	GameManager.gui.player_key_count(keycount)
	print("key_collected")
