extends Node

var roundCounter : int = 1
var enemykilled : int = 0
var totalRounds : int = 5
var roundStarted : bool = false
var didWin : bool = false

# [# of enemy, time of spawn]
var path1D : Dictionary = {
	1 : [1,3], #10
	2 : [1,2], #15
	3 : [1,3], #20
	4 : [1,2], #25
	5 : [1,2] #30
}
