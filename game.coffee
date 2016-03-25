
class Column
	constructor: (@x, @y, @w, @h)->
		
	draw: ->
		ctx.fillStyle = "gray"
		ctx.fillRect(@x, @y, @w, @h)

class PinkColumn extends Column
	colors = ["rgb(119, 84, 83)", "rgb(139, 81, 85)", "rgb(170, 84, 92)", "rgb(199, 90, 104)", "rgb(211, 97, 124)", "rgb(219, 102, 139)", "rgb(211, 102, 138)", "rgb(217, 127, 164)", "rgb(222, 160, 188)", "rgb(231, 186, 206)", "rgb(229, 177, 202)", "rgb(220, 135, 171)", "rgb(205, 98, 133)", "rgb(189, 87, 114)", "rgb(194, 118, 141)", "rgb(235, 202, 214)", "rgb(247, 238, 241)", "rgb(233, 228, 229)", "rgb(232, 213, 221)", "rgb(234, 188, 207)", "rgb(233, 167, 193)", "rgb(223, 128, 164)", "rgb(207, 107, 136)", "rgb(181, 92, 114)", "rgb(211, 115, 149)", "rgb(218, 116, 153)", "rgb(211, 101, 130)", "rgb(199, 91, 107)", "rgb(178, 83, 92)", "rgb(134, 72, 78)", "rgb(118, 71, 73)", "rgb(157, 80, 90)"]
	
	gradient = ctx.createLinearGradient(0.000, 0.000, 120, 25.000)
	
	# for color, i in colors
	# 	gradient.addColorStop i/colors.length, color
	
	repeat = 3
	for color, i in colors
		for j in [0..repeat]
			gradient.addColorStop (i / colors.length) / repeat, color
	
	draw: ->
		ctx.save()
		ctx.translate(@x, @y)
		
		ctx.beginPath()
		ctx.rect(0, 0, @w, 5) # top
		ctx.rect(0, @h-5, @w, 5) # bottom
		mini_columns = 3
		for i in [0...mini_columns]
			ctx.rect(@w/mini_columns*(i+0.25), 0, @w/mini_columns/2, @h)
		
		ctx.fillStyle = gradient # "pink"
		ctx.strokeStyle = "black"
		ctx.lineWidth = 2
		ctx.stroke()
		ctx.fill()
		
		ctx.restore()

class YellowColumn extends Column
	gradient = ctx.createLinearGradient(0.000, 150.000, 20, 150.000)

	gradient.addColorStop(0.000, 'rgba(255, 110, 2, 1.000)')
	gradient.addColorStop(0.083, 'rgba(255, 187, 0, 1.000)')
	gradient.addColorStop(0.223, 'rgba(255, 233, 0, 1.000)')
	gradient.addColorStop(0.495, 'rgba(255, 255, 0, 1.000)')
	gradient.addColorStop(0.748, 'rgba(255, 229, 0, 1.000)')
	gradient.addColorStop(0.901, 'rgba(255, 109, 0, 1.000)')
	gradient.addColorStop(1.000, 'rgba(127, 0, 0, 1.000)')

	draw: ->
		ctx.save()
		ctx.translate(@x, @y)
		
		ctx.strokeStyle = "black"
		ctx.lineWidth = 2
		ctx.strokeRect(0, 0, @w, 5)
		
		ctx.fillStyle = gradient # "yellow"
		ctx.fillRect(0, 0, @w, @h)
		
		ctx.fillStyle = "yellow"
		ctx.fillRect(0, 0, @w, 5)
		
		ctx.restore()

class Player
	keys_previous = {}
	
	constructor: (@x, @y)->
		@w = 16
		@h = 32
		@vx = 0
		@vy = 0
		@gravity = 0.5
		@jumps = 0
	
	step: ->
		move = keys[39]? - keys[37]?
		jump =
			(keys[38]? and not keys_previous[38]?) or
			(keys[32]? and not keys_previous[32]?)
		
		keys_previous = {}
		keys_previous[k] = v for k, v of keys
		
		grounded = @collision(@x, @y + 1)
		
		@vx += move
		
		if grounded
			@jumps = 2
		if jump
			if @jumps
				@jumps -= 1
				@vy = -9
		
		@vx *= 0.8
		@vy += @gravity
		
		mx = @vx
		my = @vy
		resolution = 0.1
		x_step = resolution * sign(mx)
		y_step = resolution * sign(my)
		while abs(mx) > resolution
			if @collision(@x + x_step, @y)
				@vx = 0
				break
			mx -= x_step
			@x += x_step
		while abs(my) > resolution
			if @collision(@x, @y + y_step)
				@vy = 0
				break
			my -= y_step
			@y += y_step
	
	collision: (x, y)->
		for column in columns
			unless x + @w < column.x or column.x + column.w < x or y + @h < column.y or column.y + column.h < y
				return column
		return null
	
	draw: ->
		ctx.fillStyle = "#EFD57C"
		
		###
		# LEGS
		###
		
		ctx.save()
		ctx.translate(@x + @w/2, @y + @h/2 - 4)
		ctx.fillStyle = "#B0BCC5"
		
		# leg_angle = Math.sin(Date.now() / 100)
		leg_angle = if @collision(@x, @y + 1) then 0.2 else 0.8
		leg_angle =
			if @collision(@x, @y + 1)
				0.2 + Math.sin(Date.now() / 800) / 30
			else
				0.8 + Math.sin(Date.now() / 100) / 10
		
		ctx.save()
		ctx.rotate(leg_angle)
		ctx.fillRect(-2, 0, 4, @h/2+4)
		ctx.restore()
		
		ctx.save()
		ctx.rotate(-leg_angle)
		ctx.fillRect(-2, 0, 4, @h/2+4)
		# ctx.fillStyle = "#51576C"
		# ctx.fillRect(-2, @h/2+4, 5, 3)
		ctx.restore()
		
		ctx.restore()
		
		###
		# TORSO
		###
		
		# ctx.fillRect @x, @y, @w, @h
		# ctx.fillRect @x, @y, @w, @h/2
		ctx.fillRect @x+@w*0.2, @y, @w*0.6, @h/2
		
		###
		# ARMS
		###
		
		derp_angle = 0.8
		derp_angle_2 = 1.6
		derp_angle_2 += Math.sin(Date.now() / 100) / 20
		
		ctx.save()
		ctx.translate(@x + @w/2, @y + @h/20 - 4)
		
		ctx.save()
		ctx.rotate(derp_angle)
		ctx.fillRect(-2, 0, 4, @h/3)
		ctx.translate(0, @h/3)
		ctx.rotate(derp_angle_2)
		ctx.fillStyle = "#DFAF78"
		ctx.fillRect(-2, 0, 3, @h/3)
		ctx.restore()
		
		ctx.save()
		ctx.rotate(-derp_angle)
		ctx.fillRect(-2, 0, 4, @h/3)
		ctx.translate(0, @h/3)
		ctx.rotate(-derp_angle_2)
		ctx.fillStyle = "#DFAF78"
		ctx.fillRect(-2, 0, 3, @h/3)
		ctx.restore()
		
		ctx.restore()
		
		###
		# HEAD
		###
		
		ctx.fillStyle = "#DFAF78"
		ctx.fillRect @x+@w*0.3, @y-8, @w*0.4, 8
		ctx.fillStyle = "#3D3127"
		ctx.fillRect @x+@w*0.3, @y-8, @w*0.4, 2
		

level_bottom = 500
columns = []
for x in [0..1500] by 50
	SomeColumn = if random() < 0.5 then PinkColumn else YellowColumn
	height = random() * level_bottom/2
	columns.push new SomeColumn(x, level_bottom-height, 20, height)

player = new Player(152, 15)

keys = {}
addEventListener "keydown", (e)->
	keys[e.keyCode] = on
	console.log e.keyCode
addEventListener "keyup", (e)->
	delete keys[e.keyCode]

animate ->
	{width: w, height: h} = canvas
	
	ctx.fillStyle = "#fff"
	ctx.fillRect 0, 0, w, h
	
	for column in columns
		column.draw()
	
	player.step()
	player.draw()
	
	if player.y + player.h > level_bottom
		player = new Player(152, 15)

