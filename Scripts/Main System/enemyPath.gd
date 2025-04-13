extends Path3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func newCurve() -> Curve3D:
	#construct curve for path (CHANGE THIS INGAME)
	var x = 0
	var y = 1
	var z = 5
	var endX = 19
	var endZ = 14
	#y in this case is steps down, x is steps to right
	var startPos = Vector2i(x,z)
	var endPos = Vector2i(endX,endZ)
	print("Calculating path (Curve)\n path:\n")
	var path:Array = Risk.calculate_path(startPos,endPos)
	Risk.print2DArray(path)
	var curve:Curve3D = self.curve
	curve.clear_points()
	var zVector = Vector3(0,0,0)
	var index = 1
	
	print("Successfully accessed")
	curve.add_point(Vector3(x,y,z),zVector,zVector,0)
	
	path[z][x] = 0
	
	while(x != endX || z != endZ):
		print("This is fine")
		if(x == endX):
			if(z<endZ):
				z += 1
			else:
				z -= 1
		elif(z == 0 || z == path.size()-1):
			if(path[z][x+1] == 1):
					x += 1
			else:
				if(z == 0):
					z+= 1
				else:
					z -= 1
		else:
			if(path[z][x+1] == 1):
					x += 1
			elif(path[z+1][x] == 1):
					z += 1
			elif(path[z-1][x] == 1):
					z -= 1
			else:
				print("problem occurred here")
				x += 1
		
		
		curve.add_point(Vector3(x,y,z),zVector,zVector,index)
		index += 1
		path[z][x] = 0
		#ensures no backtracking by accident
		
		#debug
		print("New point at x:" + str(x) + ", z:" + str(z))
		
		
		# end loop
	#final point added (endpos)
	curve.add_point(Vector3(x,y,z),zVector,zVector,index)
	return curve

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
