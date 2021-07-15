extends Area2D

func _ready():
	pass # Replace with function body.
	
func _on_Flag_body_entered(body):
	if body.get_collision_layer_bit(3) :
		body.collect_item()
		queue_free()
