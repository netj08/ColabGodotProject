extends Node

func _unhandled_input(_event):
	if Input.is_action_just_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
	if Input.is_action_just_pressed("menu"):
		var menu = $CanvasLayer/PauseMenu
		if menu.visible:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			menu.hide()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			menu.show()
		
func _on_quit_button_pressed():
	get_tree().quit()
