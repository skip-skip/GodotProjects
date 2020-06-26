extends Node

const TileClass = preload("Tile.gd")
class_name SuperTile

var minSubtiles: int
var totalSubtiles: int
var subtiles = [[]]



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _init(minSubs: int):
	self.minSubtiles = minSubs
	self.totalSubtiles = (minSubtiles*(minSubtiles*2-1)) + ((minSubtiles-1)*(minSubtiles-1))
	createSubtiles()
	setAdjacencies()

func createSubtiles():
	for _rows in range(0, minSubtiles*2-2):
		subtiles.append([])
	for row in range(0, minSubtiles):
		for _tiles in range(0, minSubtiles+row):
			subtiles[row].append(Tile.new())
	var distanceFromCenter = 0
	for bottomRows in range(minSubtiles, minSubtiles*2 -1):
		distanceFromCenter+=1
		for _tiles in range(0, minSubtiles+(minSubtiles-1-distanceFromCenter)):
			subtiles[bottomRows].append(Tile.new())

#check to the right
func setAdjacencies():
	var rowSize: int
	var currentTile: Tile
	#upper rows
	for row in range(0, subtiles.size()/2):
		rowSize = subtiles[row].size()
		for tile in range(0, rowSize):
			currentTile = subtiles[row][tile]
			currentTile.addAdjacent(2, subtiles[row+1][tile+1])	#bottom right
			currentTile.addAdjacent(3, subtiles[row+1][tile])	#bottom left
			if tile != rowSize-1:
				currentTile.addAdjacent(1, subtiles[row][tile+1])	#right
	#lower rows
	for row in range(subtiles.size()/2+1, subtiles.size()):
		rowSize = subtiles[row].size()
		for tile in range(0, rowSize):
			currentTile = subtiles[row][tile]
			currentTile.addAdjacent(0, subtiles[row-1][tile+1])	#upper right
			currentTile.addAdjacent(5, subtiles[row-1][tile])	#upper left
			if tile != rowSize-1:
				currentTile.addAdjacent(1, subtiles[row][tile+1])	#right
	#middle row
	rowSize = subtiles[subtiles.size()/2].size()
	for tile in range(0, rowSize):
		currentTile = subtiles[subtiles.size()/2][tile]
		if tile != rowSize-1:
			currentTile.addAdjacent(1, subtiles[subtiles.size()/2][tile+1])	#right

