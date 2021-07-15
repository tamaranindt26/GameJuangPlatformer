extends Area2D

export(int) var bulletSpeed

func _ready():
	set_as_toplevel(true)

func _process(delta):
	if is_outside_view_bound():
		queue_free()
	move_local_x(delta * bulletSpeed)

func is_outside_view_bound() :
	return position.x > OS.get_screen_size().x or position.x < 0.0\
			or position.y > OS.get_screen_size().y or position.y < 0.0

func _on_Bullets_body_entered(body):
	if body.get_collision_layer_bit(2) :
		body.hit_by_bullet(body.position)
	queue_free()
	pass # Replace with function body.
