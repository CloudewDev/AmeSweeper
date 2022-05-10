extends Node2D

onready var TileGenerator = $TileGenerator
onready var Timer = $Timer
onready var MineLeft = $MineLeft
onready var LifeLeft = $LifeLeft
onready var AmeDanceNode = $AmeBG
onready var AmeDanceTween = $AmeBG/Tween

var timeElapsed = 0
var minute = 0
var second = 0

var twistAlert = false

func _ready():
	$AmeBG/AmeDance/AnimationPlayer.play("AmeDance1")

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
		
	if twistAlert == true:
		AmeDanceTween.interpolate_property(
			AmeDanceNode, 
			"position", 
			Vector2(529, -200), 
			Vector2(529, 980), 
			1.0, 
			Tween.TRANS_SINE, 
			Tween.EASE_OUT_IN
		)
		AmeDanceTween.start()
		twistAlert = false

func _input(event):
	if event is InputEventKey and event.scancode == KEY_R:
		if event.pressed:
			TileGenerator.TwistTimeLine()
			twistAlert = true

func _on_TextureButton_button_down():
	$Restart.self_modulate = Color(0.3, 0.3, 0.5)


func _on_TextureButton_button_up():
	$Restart.self_modulate = Color(0.6, 0.6, 0.8)
	TileGenerator.Restart()
	timeElapsed = 0
	minute = 0
	second = 0
