extends Node2D

onready var TileGenerator = $TileGenerator
onready var Timer = $Timer
onready var MineLeft = $MineLeft
onready var LifeLeft = $LifeLeft

var timeElapsed = 0
var minute = 0
var second = 0

func _process(delta):
	
	if TileGenerator.playing == true:
		timeElapsed += delta
		minute = timeElapsed/60
		second = fmod(timeElapsed, 60)
	
	Timer.text = "%02d:%02d" % [minute, second]
	MineLeft.text = String(TileGenerator.leftBomb)
	LifeLeft.text = String(TileGenerator.life)
	
	if TileGenerator.life == 0:
		$MineLeft/Ame.hide()
	else:
		$MineLeft/Ame.show()


func _on_TextureButton_button_down():
	$Restart.self_modulate = Color(0.3, 0.3, 0.5)


func _on_TextureButton_button_up():
	$Restart.self_modulate = Color(0.6, 0.6, 0.8)
	TileGenerator.Restart()
	timeElapsed = 0
	minute = 0
	second = 0
