extends Node2D

onready var TileGenerator = $TileGenerator
onready var Timer = $Timer
onready var MineLeft = $MineLeft
onready var LifeLeft = $LifeLeft
onready var AmeDanceNode = $AmeBG
onready var AmeDanceTween = $AmeBG/Tween
onready var AmeRunNode = $AmeRun
onready var AmeRunTween = $AmeRun/Tween

var timeElapsed = 0
var minute = 0
var second = 0

var twistInterval = 0
var twistTimer = 0

var runOverAnim = true

var rng = RandomNumberGenerator.new()

func _ready():
	$AmeBG/AmeDance/AnimationPlayer.play("AmeDance1")
	$AmeRun/AnimationPlayer.play("AmeRun")
	rng.randomize()
	
	twistInterval = rng.randi_range(15, 30)

func _process(delta):
	
	if TileGenerator.playing == true:
		timeElapsed += delta
		twistTimer += delta
		minute = timeElapsed/60
		second = fmod(timeElapsed, 60)
	
	Timer.text = "%02d:%02d" % [minute, second]
	MineLeft.text = String(TileGenerator.leftBomb)
	LifeLeft.text = String(TileGenerator.life)
	
	if TileGenerator.life == 0:
		$MineLeft/Ame.hide()
		if runOverAnim == true:
			GameOverAnim()
			runOverAnim = false
			
	else:
		$MineLeft/Ame.show()
		runOverAnim = true
		
	if TileGenerator.leftBomb == 0:
		$LifeLeft/Kronii.hide()
	else:
		$LifeLeft/Kronii.show()
		
	if twistTimer > twistInterval:
		TwistTimeLineAnim()
		TileGenerator.TwistTimeLine()
		twistTimer = 0
		twistInterval = rng.randi_range(15, 30)
		
	if TileGenerator.gameOver:
		get_tree().call_group("Tiles", "ProhibitInput")
	elif TileGenerator.ready:
		get_tree().call_group("Tiles", "AllowInput")
		
	if TileGenerator.leftBomb == 0:
		TileGenerator.GameSuccess()

func _input(event):
	if event is InputEventKey and event.scancode == KEY_R:
		if event.pressed:
			TileGenerator.TwistTimeLine()
			TwistTimeLineAnim()

func TwistTimeLineAnim():
	AmeDanceTween.interpolate_property(
			AmeDanceNode, 
			"position", 
			Vector2(529, -200), 
			Vector2(529, 980), 
			3.0, 
			Tween.TRANS_SINE, 
			Tween.EASE_OUT_IN
		)
	AmeDanceTween.start()

func GameOverAnim():
	AmeRunTween.interpolate_property(
			AmeRunNode, 
			"position", 
			Vector2(-150, 400), 
			Vector2(1150, 400), 
			1.5, 
			Tween.TRANS_SINE, 
			Tween.EASE_IN_OUT
		)
	AmeRunTween.start()
	

func _on_TextureButton_button_down():
	$Restart.self_modulate = Color(0.3, 0.3, 0.5)


func _on_TextureButton_button_up():
	$Restart.self_modulate = Color(0.6, 0.6, 0.8)
	TileGenerator.Restart()
	timeElapsed = 0
	minute = 0
	second = 0
	twistTimer = 0
	twistInterval = rng.randi_range(15, 30)

func _on_Tween_tween_started(object, key):
	get_tree().call_group("Tiles", "ProhibitInput")

func _on_Tween_tween_all_completed():
	get_tree().call_group("Tiles", "AllowInput")


