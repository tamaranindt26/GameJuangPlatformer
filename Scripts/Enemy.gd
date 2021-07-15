extends KinematicBody2D

const speed = 15
const gravity = 200
var velocity = Vector2()
const FLOOR = Vector2(0, -1)
var direction = 1
var startposition

var isAttack = false
export var attackDis = 50

func _ready():
	startposition = position
	direction = direction * -1
	$RayCast2D.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
func _physics_process(delta):
	velocity.x = speed * direction
	if direction == 1:
		$EnemyAnimSorite.flip_h = false
	else :
		$EnemyAnimSorite.flip_h = true
		
	$EnemyAnimSorite.play("Run")
	
	velocity.y += 20
	velocity.x = 15 * direction
	velocity = move_and_slide(velocity, Vector2.UP)	
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
	if $RayCast2D.is_colliding() == false :
		direction = direction * -1
		$RayCast2D.position.x *= -1
	
