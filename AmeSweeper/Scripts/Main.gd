extends Node2D

var width = 30
var height = 20
var bombCnt = 100
var leftBomb = 100
var life = 3

var randX
var randY
var randNum

var tempCnt1 = 0
var tempBombCnt = 0

var board = []
var bombList = []

var searchStack = []

var ready = true
var playing = false
var gameOver = false

var Tile = preload("res://Scenes/Tile.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	SetupBoard()
	SetTileProperty()
	
func _process(_delta):
	
	if life == 0:
		for x in width:
			for y in height:
				if board[x][y].nearBombNum == 9:
					board[x][y].Reveal()
					
	for x in width:
		for y in height:
			if board[x][y].bothHold == true:
				for x2 in width:
					for y2 in height:
						if x2 >= x-1 and x2 <= x+1 and y2 >= y-1 and y2 <= y+1:
							if board[x2][y2].revealed == false:
								board[x2][y2].emphasized = true
						else:
							board[x2][y2].emphasized = false
			if board[x][y].isCursorOn == false:
				board[x][y].emphasized = false

func Restart():
	for x in width:
		for y in height:
			board[x][y].initialize()
	SetTileProperty()
	leftBomb = 100
	life = 3
	
	ready = true
	playing = false
	gameOver = false

func SetupBoard():
	for x in width:
		board.append([])
		
		for y in height:
			var t = Tile.instance()
			
			t.position = Vector2(x, y) * 32
			t.CheckPatternColor(x , y)
			
			t.xPos = x
			t.yPos = y
			
			t.connect("my_nearBombNum", self, "RevealAsManyAsPossible")
			t.connect("flag_result", self, "FoundAme")
			t.connect("bomb", self, "GameFail")
			t.connect("open_near", self, "OpenNear")
			add_child(t)
			board[x].append(t)
			t.add_to_group("Tiles")
			
			
func SetTileProperty():
	bombList.clear()
	for i in bombCnt:
		randX = rng.randi_range(0, width - 1)
		randY = rng.randi_range(0, height - 1)
		
		while board[randX][randY].nearBombNum == 9:
			randX = rng.randi_range(0, width - 1)
			randY = rng.randi_range(0, height - 1)
		
		board[randX][randY].nearBombNum = 9
		board[randX][randY].NumberSet()
		
		bombList.append(Vector2(randX, randY))
	
	for x in width:
		for y in height:
			for nearX in range(x-1, x+2):
				for nearY in range(y-1, y+2):
					if nearX >= 0 and nearX < width and nearY >= 0 and nearY < height:
						if board[nearX][nearY].nearBombNum == 9:
							tempBombCnt += 1
			if board[x][y].nearBombNum != 9 :
				board[x][y].nearBombNum = tempBombCnt
				board[x][y].NumberSet()
			tempBombCnt = 0

func TwistTimeLine():
	for x in width:
		for y in height:
			board[x][y].initialize()

	SetTileProperty()
	
	var tempCnt2 = 0
	
	while tempCnt2 < bombCnt - leftBomb:
		randNum = rng.randi_range(0, bombCnt - leftBomb - tempCnt2 - 1)
		
		randX = bombList[randNum].x
		randY = bombList[randNum].y
		bombList.remove(randNum)
		
		board[randX][randY].revealed = true
		board[randX][randY].CoverNode.hide()
		board[randX][randY].FlagNode.show()
		board[randX][randY].flaged = true
		
		var tempCnt3 = 0
		randNum = rng.randi_range(3, 8)
		
		while tempCnt3 < randNum:
			for x in range(randX - 1 , randX + 2):
				for y in range(randY - 1, randY + 2):
					if x >= 0 and x < width and y >= 0 and y < height:
						
						if rng.randf() < 0.5:
							if board[x][y].nearBombNum != 9:
								board[x][y].Reveal()
								OpenNear(x, y, board[x][y].nearBombNum)
								tempCnt3 += 1
							else:
								tempCnt3 += 1
		tempCnt2 += 1

func RevealAsManyAsPossible(xPos, yPos, num):
	if ready == true:
		playing = true
		ready = false
	
	if num != 9:
		board[xPos][yPos].Reveal()
		if num == 0:
			for x in range(xPos - 1, xPos + 2):
				for y in range( yPos - 1, yPos + 2):
					if x >= 0 and x < width and y >= 0 and y < height:
					
						if board[x][y].nearBombNum != 9 and board[x][y].revealed == false:
							board[x][y].Reveal()
						
							if board[x][y].nearBombNum == 0:
								searchStack.append(Vector2(x, y))
						
	if searchStack.size() > 0:
		var nextCoordinate = searchStack.pop_back()
		var nextX = nextCoordinate.x
		var nextY = nextCoordinate.y
		RevealAsManyAsPossible(nextX, nextY, board[nextX][nextY].nearBombNum)
		
func FoundAme(result):
	if result == true:
		leftBomb -= 1
	else:
		life -= 1
		
func GameFail():
	life = 0
	playing = false
	gameOver = true

func GameSuccess():
	playing = false
	gameOver = true

func OpenNear(x, y, num):
	tempCnt1 = 0
	for nearX in range (x-1, x+2):
		for nearY in range(y-1, y+2):
			if nearX >= 0 and nearX < width and nearY >= 0 and nearY < height:
				if board[nearX][nearY].flaged == true:
					tempCnt1 += 1
	if tempCnt1 == num:
		for nearX in range (x-1, x+2):
			for nearY in range(y-1, y+2):
				if nearX >= 0 and nearX < width and nearY >= 0 and nearY < height:
					if board[nearX][nearY].revealed == false:
						board[nearX][nearY].Reveal()
						if board[nearX][nearY].nearBombNum == 0:
							RevealAsManyAsPossible(nearX, nearY, 0)
	else:
		if board[x][y].rightHold and board[x][y].leftHold:
			for mapX in width:
				for mapY in height:
					if mapX >= x-1 and mapX <= x+1 and mapY >= y-1 and mapY <= y+1:
						if board[mapX][mapY].revealed == false:
							board[mapX][mapY].emphasized = true
					else:
						board[mapX][mapY].emphasized = false
