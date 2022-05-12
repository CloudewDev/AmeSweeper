extends Node2D

var xPos = 0
var yPos = 0

var isCursorOn = false
var revealed = false
var flaged = false

var emphasized = false

var leftHold = false
var rightHold = false
var bothHold = false

var allowInput = true

var nearBombNum = 0 # 9 means mine

onready var NumberNode = $Number
onready var MineNode = $Mine
onready var CoverNode = $Cover
onready var FlagNode = $Flag
onready var EmphasizeNode = $Emphasize
onready var BaseNode = $Base

signal my_nearBombNum(x, y, num)
signal flag_result(result)
signal bomb
signal open_near(x, y, num)

func _process(_delta):
	if emphasized == true:
		EmphasizeNode.self_modulate.a = 0.2
	else:
		EmphasizeNode.self_modulate.a = 0
		
	if leftHold and rightHold and isCursorOn and revealed:
		emit_signal("open_near", xPos, yPos, nearBombNum)
		bothHold = true
	else:
		bothHold = false

func initialize():
	revealed = false
	flaged = false
	nearBombNum = 0
	CoverNode.show()
	FlagNode.hide()

func NumberSet():
	if nearBombNum < 9:
		if nearBombNum > 0:
			NumberNode.show()
			NumberNode.text = String(nearBombNum)
			MineNode.hide()
		else:
			NumberNode.hide()
			MineNode.hide()
	else:
		MineNode.show()
		NumberNode.hide()
	NumberColor()
	
func Reveal():
	emphasized = false
	CoverNode.hide()
	revealed = true
	
	if nearBombNum == 9:
		emit_signal("bomb")
	
func Flag():
	emphasized = false
	revealed = true
	if nearBombNum == 9:
		CoverNode.hide()
		FlagNode.show()
		flaged = true
		emit_signal("flag_result", true)
	else:
		CoverNode.hide()
		emit_signal("my_nearBombNum", xPos, yPos, nearBombNum)
		emit_signal("flag_result", false)
	
func _input(event):
	if event is InputEventMouseButton and allowInput:
		if revealed == false:
			if isCursorOn:
				if event.button_index == BUTTON_LEFT:
					if event.pressed:
						Reveal()
						emit_signal("my_nearBombNum", xPos, yPos, nearBombNum)
				
				if event.button_index == BUTTON_RIGHT:
					if event.pressed:
						Flag()
		else:
			if event.button_index == BUTTON_LEFT:
				if event.pressed:
					leftHold = true
				else:
					leftHold = false
				
			if event.button_index == BUTTON_RIGHT:
				if event.pressed:
					rightHold = true
				else:
					rightHold = false

func CheckPatternColor(x, y):
	if (x + y)%2 == 0:
		$Cover.self_modulate = Color(0.9, 0.7, 0.5)
		$Base.self_modulate = Color(0.76, 0.76, 0.8)


func _on_Area2D_mouse_entered():
	isCursorOn = true
	if revealed == false:
		emphasized = true


func _on_Area2D_mouse_exited():
	isCursorOn = false
	emphasized = false

func NumberColor():
	match nearBombNum:
		1:
			NumberNode.self_modulate = Color(0.3, 0.3, 0.9)
		2:
			NumberNode.self_modulate = Color(0.1, 0.5, 0.2)
		3:
			NumberNode.self_modulate = Color(0.7, 0.2, 0.2)
		4:
			NumberNode.self_modulate = Color(0.1, 0.1, 0.3)
		5:
			NumberNode.self_modulate = Color(0.3, 0.2, 0)
		6:
			NumberNode.self_modulate = Color(0.1, 0.5, 0.5)
		7:
			NumberNode.self_modulate = Color(0, 0, 0)
		8:
			NumberNode.self_modulate = Color(0.4, 0.4, 0.4)

func ProhibitInput():
	allowInput = false
func AllowInput():
	allowInput = true
