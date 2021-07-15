extends Control

export var keycount_texture = []

func _ready():
	GameManager.gui = self
	
func player_health_bar(val : float) :
	$HealthBar.value = val

func player_key_count(val : int):
	$keyCount.texture = keycount_texture[val - 1]

func _on_HomeBTN_pressed():
	GameManager.change_scene(0)
	print("home pressed")

func _on_RestartBTN_pressed():
	GameManager.reload_currentScene()
	print("rest pressed")
	
func show_winlose(msg : String):
	$WinLose/Label.text = msg
	$WinLose.visible = true
