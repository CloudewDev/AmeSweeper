extends Node2D

var width = 30
var height = 20
var bombCnt = 100
var leftBomb = 100
var life = 3

var tempBombCnt = 0

var board = []

var searchStack = []

var Tile = preload("res://Scenes/Tile.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	SetupBoard()


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
			
			add_child(t)
			board[x].append(t)
			
	for i in bombCnt:
		var randX = rng.randi_range(0, width - 1)
		var randY = rng.randi_range(0, height - 1)
		
		while board[randX][randY].nearBombNum == 9:
			randX = rng.randi_range(0, width - 1)
			randY = rng.randi_range(0, height - 1)
		
		board[randX][randY].nearBombNum = 9
		board[randX][randY].NumberSet()
	
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
			
			
func RevealAsManyAsPossible(xPos, yPos, num):
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
