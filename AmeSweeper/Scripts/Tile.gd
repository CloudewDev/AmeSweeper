extends Node2D

var xPos = 0
var yPos = 0

var isCursorOn = false
var revealed = false
var flagCnt = 0

var life = 3

var nearBombNum = 0 # 9 means mine

signal my_nearBombNum(x, y, num)

func _process(delta):
	if nearBombNum < 9:
		if nearBombNum > 0:
			$Number.text = String(nearBombNum)
			$Mine.hide()
		else:
			$Number.hide()
			$Mine.hide()
	else:
		$Number.hide()
	
func Reveal():
	$Cover.hide()
	revealed = true
	
	if nearBombNum == 9:
		life == 0
	
func Flag():
	$Flag.show()
	$Cover.hide()
	if nearBombNum == 9:
		flagCnt += 1
	else:
		life -= 1
		$Flag.hide()
	
func _input(event):
	if event is InputEventMouseButton and isCursorOn:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				Reveal()
				emit_signal("my_nearBombNum", xPos, yPos, nearBombNum)
				
		if event.button_index == BUTTON_RIGHT:
			if event.pressed:
				Flag()
				
func CheckPatternColor(x, y):
	if (x + y)%2 == 0:
		$Cover.self_modulate = Color(0.9, 0.7, 0.5)
		$Base.self_modulate = Color(0.76, 0.76, 0.8)


func _on_Area2D_mouse_entered():
	if revealed == false:
		isCursorOn = true
		$Emphasize.self_modulate.a = 0.2


func _on_Area2D_mouse_exited():
	isCursorOn = false
	$Emphasize.self_modulate.a = 0
