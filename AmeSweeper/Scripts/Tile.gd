extends Node2D

var xPos = 0
var yPos = 0

var isCursorOn = false
var revealed = false
var flaged = false

var nearBombNum = 0 # 9 means mine

onready var Number = $Number
onready var Mine = $Mine
onready var Cover = $Cover
onready var Flag = $Flag
onready var Emphasize = $Emphasize
onready var Base = $Base

signal my_nearBombNum(x, y, num)
signal flag_result(result)
signal bomb

func initialize():
	revealed = false
	flaged = false
	nearBombNum = 0
	Cover.show()
	Flag.hide()

func NumberSet():
	if nearBombNum < 9:
		if nearBombNum > 0:
			Number.show()
			Number.text = String(nearBombNum)
			Mine.hide()
		else:
			Number.hide()
			Mine.hide()
	else:
		Mine.show()
		Number.hide()
	NumberColor()
	
func Reveal():
	Emphasize.self_modulate.a = 0
	Cover.hide()
	revealed = true
	
	if nearBombNum == 9:
		emit_signal("bomb")
	
func Flag():
	revealed = true
	Emphasize.self_modulate.a = 0
	Flag.show()
	Cover.hide()
	if nearBombNum == 9:
		flaged = true
		emit_signal("flag_result", true)
	else:
		Flag.hide()
		emit_signal("flag_result", false)
	
func _input(event):
	if event is InputEventMouseButton and isCursorOn and revealed == false:
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
		Emphasize.self_modulate.a = 0.2


func _on_Area2D_mouse_exited():
	isCursorOn = false
	Emphasize.self_modulate.a = 0

func NumberColor():
	match nearBombNum:
		1:
			Number.self_modulate = Color(0.3, 0.3, 0.9)
		2:
			Number.self_modulate = Color(0.1, 0.5, 0.2)
		3:
			Number.self_modulate = Color(0.7, 0.2, 0.2)
		4:
			Number.self_modulate = Color(0.1, 0.1, 0.3)
		5:
			Number.self_modulate = Color(0.3, 0.2, 0)
		6:
			Number.self_modulate = Color(0, 0.6, 0.3)
		7:
			Number.self_modulate = Color(0, 0, 0)
		8:
			Number.self_modulate = Color(0.4, 0.4, 0.4)
