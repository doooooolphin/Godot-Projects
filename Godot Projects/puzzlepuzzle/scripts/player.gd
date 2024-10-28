extends LevelObject


func move(amt:Vector2):
	var moved = super(amt)
	if moved && false:
		$AnimatedSprite2D.stop()
		if Input.is_action_pressed("right") != Input.is_action_pressed("left"):
			$AnimatedSprite2D.flip_h = Input.is_action_pressed("left")
			$AnimatedSprite2D.play("slide_x")
		elif Input.is_action_pressed("down"):
			$AnimatedSprite2D.play("roll_down")
		else:
			$AnimatedSprite2D.play("roll_up")
	return moved

func update_visual_position(delta):
	super(delta)


func _on_animation_finished():
	position = goal_position
	$AnimatedSprite2D.play("default")
