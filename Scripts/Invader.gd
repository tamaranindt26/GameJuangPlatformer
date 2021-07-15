extends KinematicBody2D

var key = preload("res://Scenes/Key.tscn")

export var run_speed = 10
export var gravity = 2000
var velocity = Vector2()

export var animations = []
var isRight = true

export var moveableDistance = 50
var startposition

var isAttack = false
export var attackDis = 60

var isLive = true
var health = 2

func _ready():
	startposition = position

func MoveOnPath() :
	var distance = GameManager.player.position.distance_to(position)
	if (distance > attackDis) :
		if isRight :
			velocity.x = run_speed
			if is_on_floor() :
				play_invader_ani(1, isRight)
			
		else:
			velocity.x =- run_speed
			if is_on_floor() :
				play_invader_ani(1, isRight)
	elif !isAttack :
		attack_player()
	position_state_check()
	
func position_state_check():
	if moveableDistance > 0:
		if position.x < startposition.x :
			isRight = true
		elif position.x > (startposition.x + moveableDistance):
			isRight = false
	else :
		if position.x > startposition.x :
			isRight = false
		elif position.x < (startposition.x + moveableDistance):
			isRight = true

func attack_player() :
	isAttack = true
	play_invader_ani(2, isRight)
	yield($CollisionShape2D/InvaderAnim, "animation_finished")
	GameManager.player.hit_by_enemy()
	isAttack = false
			
func _physics_process(delta):
	velocity.y += gravity * delta
	if !isLive :
		return
	MoveOnPath()
	velocity = move_and_slide(velocity, Vector2(0, -1))

func play_invader_ani(_aniIndex : int,_isRight : bool) :
	$CollisionShape2D/InvaderAnim.animation = animations[_aniIndex]
	$CollisionShape2D/InvaderAnim.flip_h =! isRight

func hit_by_bullet(pos) :
	if !isLive :
		return
	
	health -= 1
	play_invader_ani(4, isRight)
	
	if health < 0:
		play_invader_ani(3, isRight)
		isLive = false
		yield($CollisionShape2D/InvaderAnim, "animation_finished")
		spawn_key()

func spawn_key():
	var new_key = key.instance()
	get_node("../KeyContainer").add_child(new_key)
	new_key.global_position = global_position
	queue_free()
