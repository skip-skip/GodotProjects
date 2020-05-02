extends Node

class_name Tile
# Declare member variables here. Examples:
var adjacentTiles = [null, null, null, null, null, null];

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func addAdjacent(index: int, tile: Tile):
	self.adjacentTiles[index] = tile
	tile.adjacentTiles[(index+3)%6] = self

func addAllAdjacent(array: Array):
	adjacentTiles = array
	

func printReady():
	print("ready")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
