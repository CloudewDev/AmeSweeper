extends Node2D

onready var TileGenerator = $TileGenerator
onready var Timer = $Timer
onready var MineLeft = $MineLeft
onready var LifeLeft = $LifeLeft

var timeElapsed = 0
var minute
var second

func _process(delta):
	timeElapsed += delta
	minute = timeElapsed/60
	second = fmod(timeElapsed, 60)
	
	Timer.text = "%02d:%02d" % [minute, second]
	
	MineLeft.text = String(TileGenerator.leftBomb)
	LifeLeft.text = String(TileGenerator.life)
