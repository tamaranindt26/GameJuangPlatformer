extends Node

var player
var gui

var Scenes = [
	"res://Scenes/MainMenu.tscn",
	"res://Scenes/GamePlay.tscn"
]

func change_scene(index : int):
	get_tree().change_scene(Scenes[index])
	
func reload_currentScene():
	get_tree().reload_current_scene()
