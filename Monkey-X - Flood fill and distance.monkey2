Import mojo

Global screenwidth:Int=640
Global screenheight:Int=480
Global mapwidth:Int=20
Global mapheight:Int=20
Global tilewidth:Float=Float(screenwidth)/Float(mapwidth)
Global tileheight:Float=Float(screenheight)/Float(mapheight)

Class MyGame Extends App
	Field flood:Bool=False
	Field fillval:Int=1
	Field delay:Int
	Field map:Int[][]
	Field mapd:Int[][] 'map containing the distance (distance map)
	Field floodx:Stack<Int> = New Stack<Int> 'flood 
	Field floody:Stack<Int> = New Stack<Int>
	Field floodv:Stack<Int> = New Stack<Int> 'distance
	Field mx:Int[] = [0,1,0,-1] 'expand up/right/down/left
	Field my:Int[] = [-1,0,1,0]
    Method OnCreate()
        SetUpdateRate(60)
        map = New Int[mapwidth][]
        For Local i=0 Until mapwidth
        	map[i] = New Int[mapheight]
        Next
        mapd = New Int[mapwidth][]
        For Local i=0 Until mapwidth
        	mapd[i] = New Int[mapheight]
        Next
		For Local x=0 Until mapwidth/2
			map[x][mapheight/2] = 6
		Next
    End Method
    Method OnUpdate()
    	Local tx:Int=MouseX()/tilewidth
    	Local ty:Int=MouseY()/tileheight
    	If MouseDown(MOUSE_LEFT) And flood=False And map[tx][ty] <> 6
    		Print "Flooding - "+Millisecs()
    		floodx.Clear
    		floody.Clear
    		floodv.Clear
    		For Local y=0 Until mapheight
    		For Local x=0 Until mapwidth
    			mapd[x][y] = 0
    		Next
    		Next
    		floodx.Push(tx)
    		floody.Push(ty)
    		floodv.Push(1)
    		flood = True
    		fillval+=1
    		If fillval > 5 Then fillval = 0
    		map[tx][ty] = fillval
    		mapd[tx][ty] = 1
    	End If
    	If flood = True
    		If floodx.Length > 0
    		Local x1:Int=floodx.Top
    		Local y1:Int=floody.Top
    		Local v1:Int=floodv.Top
    		floodx.Pop
    		floody.Pop
    		floodv.Pop
			For Local i=0 Until 4
				Local x2:Int=x1+mx[i]
				Local y2:Int=y1+my[i]
				If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
				If map[x2][y2] <> fillval
				If map[x2][y2] <> 6
					map[x2][y2] = fillval
					' if you insert the new locations at the bottom
					' of the list then you will get correct distance values (flooding)
					floodx.Insert(0,x2)
					floody.Insert(0,y2)
					floodv.Insert(0,v1+1)
					'store the distance in the map
					mapd[x2][y2] = v1+1
				End If
				End If
				End If
			Next
			Else
			flood=False
			Print "Flooding done"
			End If
    	End If
    End Method
    Method OnRender()
    	For Local y=0 Until mapheight
    	For Local x=0 Until mapwidth
    		Local col:Int=map[x][y]
    		SetColor col*30,col*30,col*30
    		DrawRect x*tilewidth,y*tileheight,tilewidth+1,tileheight+1
    	Next
    	Next
    	For Local i=0 Until floodx.Length
    	    	SetColor 255,255,0
    		DrawCircle floodx.Get(i)*tilewidth+tilewidth/2,floody.Get(i)*tileheight+tileheight/2,tilewidth/2
    	Next
		SetColor 255,255,255
		For Local y=0 Until mapheight
		For Local x=0 Until mapwidth
			DrawText mapd[x][y],x*tilewidth+tilewidth-10,y*tileheight+tileheight-10
		Next
		Next
		SetColor 255,255,255
		DrawText "Press Left Mouse to flood map..",0,0
    End Method

End Class

Function Main()
    New MyGame()
End Function
