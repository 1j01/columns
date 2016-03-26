
jump_sound = new Howl urls: ["sound/jump.wav"], volume: 0.1
pickup_sound = new Howl urls: ["sound/pickup.wav"], volume: 0.1
deposit_sound = new Howl urls: ["sound/deposit.wav"], volume: 0.01
respawn_sound = new Howl urls: ["sound/respawn.wav"], volume: 0.1
drop_sound = new Howl urls: ["sound/drop.wav"], volume: 0.05

class Column
	constructor: (@x, @y, @w, @h)->
		@rim_extension = 5
		@rim_height = 5
		
	draw: ->
		if @gradient
			ctx.save()
			ctx.translate(@x, @y)
			
			ctx.strokeStyle = "black"
			ctx.lineWidth = 2
			ctx.fillStyle = @gradient
			
			ctx.beginPath()
			ctx.rect(0, 0, @w, @h)
			ctx.stroke()
			ctx.fill()
			ctx.beginPath()
			curve_length = 10
			ctx.moveTo(0, @rim_height + curve_length)
			ctx.quadraticCurveTo(0, @rim_height, -@rim_extension, @rim_height)
			ctx.lineTo(-@rim_extension, 0)
			ctx.lineTo(@w+@rim_extension, 0)
			ctx.lineTo(@w+@rim_extension, @rim_height)
			ctx.quadraticCurveTo(@w, @rim_extension, @w, @rim_height + curve_length)
			ctx.rect(-1, @h-5, @w+2, 5)
			ctx.stroke()
			ctx.fill()
			ctx.beginPath()
			ctx.fillStyle = @top_gradient
			ctx.rect(-@rim_extension, 0, @w+@rim_extension*2, 5)
			ctx.stroke()
			ctx.fill()
			
			ctx.restore()
		else
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
		ctx.rect(-@rim_extension, 0, @w+@rim_extension*2, 5) # top
		# ctx.rect(0, 0, @w, 5) # top
		ctx.rect(-@rim_extension, @h-5, @w+@rim_extension*2, 5) # bottom
		# ctx.rect(0, @h-5, @w, 5) # bottom
		mini_columns = 3
		for i in [0...mini_columns]
			ctx.rect(@w/(mini_columns-1)*(i-0.25), 0, @w/mini_columns/2+1, @h)
		
		ctx.fillStyle = gradient
		ctx.strokeStyle = "black"
		ctx.lineWidth = 2
		ctx.stroke()
		ctx.fill()
		
		ctx.restore()
		
		# ctx.fillStyle = "rgba(255, 0, 0, 0.5)"
		# ctx.fillRect(@x, @y, @w, @h)

class YellowColumn extends Column
	gradient = ctx.createLinearGradient(0.000, 150.000, 20, 150.000)

	gradient.addColorStop(0.000, 'rgba(255, 110, 2, 1.000)')
	gradient.addColorStop(0.083, 'rgba(255, 187, 0, 1.000)')
	gradient.addColorStop(0.223, 'rgba(255, 233, 0, 1.000)')
	gradient.addColorStop(0.495, 'rgba(255, 255, 0, 1.000)')
	gradient.addColorStop(0.748, 'rgba(255, 229, 0, 1.000)')
	gradient.addColorStop(0.901, 'rgba(255, 109, 0, 1.000)')
	gradient.addColorStop(1.000, 'rgba(127, 0, 0, 1.000)')

	top_gradient = ctx.createLinearGradient(-5, 150.000, 30, 150.000)

	top_gradient.addColorStop(0.000, 'rgba(255, 110, 2, 1.000)')
	top_gradient.addColorStop(0.083, 'rgba(255, 187, 0, 1.000)')
	top_gradient.addColorStop(0.223, 'rgba(255, 233, 0, 1.000)')
	top_gradient.addColorStop(0.495, 'rgba(255, 255, 0, 1.000)')
	top_gradient.addColorStop(0.748, 'rgba(255, 229, 0, 1.000)')
	top_gradient.addColorStop(0.901, 'rgba(255, 109, 0, 1.000)')
	top_gradient.addColorStop(1.000, 'rgba(127, 0, 0, 1.000)')
	
	gradient: gradient
	top_gradient: top_gradient

class CheckpointColumn extends Column
	
	gradient = ctx.createLinearGradient(0.000, 150.000, 40, 150.000)
	
	gradient.addColorStop(0.000, 'rgba(0, 167, 175, 1.000)')
	gradient.addColorStop(0.271, 'rgba(0, 255, 33, 1.000)')
	gradient.addColorStop(0.477, 'rgba(167, 255, 104, 1.000)')
	gradient.addColorStop(0.851, '#00ffa5')
	gradient.addColorStop(1.000, 'rgba(0, 63, 127, 1.000)')
	
	gradient: gradient

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
		move = (keys[39]? or keys[68]?) - (keys[37]? or keys[65]?)
		jump =
			(keys[38]? and not keys_previous[38]?) or
			(keys[87]? and not keys_previous[87]?) or
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
				jump_sound.play()
		
		if grounded instanceof CheckpointColumn
			@checkpoint = grounded
			for gem in gems when gem.collected and not gem.deposited
				gem.vy -= 20
				gem.deposited = yes
				gem.deposited_to = @checkpoint
		
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
		# ctx.fillStyle = "rgba(255, 0, 0, 0.5)"
		# ctx.fillRect(@x, @y, @w, @h)
		
		###
		# LEGS
		###
		
		ctx.save()
		ctx.translate(@x + @w/2, @y + @h/2 - 4)
		ctx.fillStyle = "#B0BCC5"
		
		leg_angle = if @collision(@x, @y + 1) then 0.2 else 0.8
		leg_angle =
			if @collision(@x, @y + 1)
				0.2 + Math.sin(Date.now() / 800) / 30
			else
				0.8 + Math.sin(Date.now() / 100) / 10
		
		if @vy > 2
			leg_angle /= @vy / 2
		
		ctx.save()
		ctx.rotate(leg_angle)
		ctx.fillRect(-2, 0, 4, @h/2+4)
		ctx.restore()
		
		ctx.save()
		ctx.rotate(-leg_angle)
		ctx.fillRect(-2, 0, 4, @h/2+4)
		# todo: shoes?
		# ctx.fillStyle = "#51576C"
		# ctx.fillRect(-2, @h/2+4, 5, 3)
		ctx.restore()
		
		ctx.restore()
		
		###
		# TORSO
		###
		
		ctx.fillStyle = "#EFD57C"
		ctx.fillRect @x+@w*0.2, @y, @w*0.6, @h/2
		
		###
		# ARMS
		###
		
		derp_angle = 0.8
		derp_angle_2 = 1.6
		derp_angle_2 += Math.sin(Date.now() / 100) / 20
		if @vy > 2
			derp_angle += Math.sin(Date.now() / 155)
			derp_angle_2 += Math.sin(Date.now() / 94)
		
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

class Gem
	gradient = ctx.createLinearGradient(-5, -8, 5, 15)

	gradient.addColorStop(0.00, 'rgba(255, 255, 255, 0.0)')
	gradient.addColorStop(0.25, 'rgba(255, 255, 255, 1.0)')
	gradient.addColorStop(0.40, 'rgba(255, 255, 255, 0.3)')
	gradient.addColorStop(0.50, 'rgba(255, 255, 255, 0.5)')
	# gradient.addColorStop(0.55, 'rgba(255, 255, 255, 0.9)')
	gradient.addColorStop(0.60, 'rgba(255, 255, 255, 0.3)')
	# gradient.addColorStop(0.65, 'rgba(255, 255, 255, 0.6)')
	gradient.addColorStop(0.75, 'rgba(255, 255, 255, 0.0)')
	gradient.addColorStop(1.00, 'rgba(255, 255, 255, 0.3)')
	
	constructor: (@x, @y)->
		@color = "hsl(#{random()*360}, 100%, 50%)"
		@sides = ~~(random() * 5 + 3)
		@radius = 3 + @sides / 2
		@rotation = random() * TAU
		@start_x = @x
		@start_y = @y
		@vx = 0
		@vy = 0
		@collected = no
		@deposited = no
		@deposited_to = null
		@deposited_fully = no # for animation
		@dropped = no # for sound (and maybe score animation)
		# @value = @sides * 100
		@value = 100
	
	step: ->
		dx = player.x + player.w/2 - @x
		dy = player.y + player.h/2 - @y
		dist = sqrt(dx*dx + dy*dy)
		force = 0
		if dist > 1
			if dist < 50
				force = 3
				if dist < 20
					force = 2
				if dist < 10
					force = 1
					unless @collected or @deposited
						pickup_sound.play()
						@collected = yes
			if @collected
				force = 1.1
		if force > 0
			@vx += dx / dist * force
			@vy += dy / dist * force
		
		if @deposited
			dx = @deposited_to.x + @deposited_to.w/2 - @x
			dy = @deposited_to.y - @y
			dist = sqrt(dx*dx + dy*dy)
			if abs(dx > 100)
				@vy -= 1
			if dist > 1
				force = 3
				@vx += dx / dist * force
				@vy += dy / dist * force
				unless @deposited_fully
					deposit_sound.play()
					@deposited_fully = yes if dist < 10
		
		dx = @start_x - @x
		dy = @start_y - @y
		dist = sqrt(dx*dx + dy*dy)
		if dist > 1
			force = 1
			if dist < 5
				force = 0.5
				if @dropped
					@dropped = no
					drop_sound.play()
			if dist < 2
				force = 0.1
			@vx += dx / dist * force
			@vy += dy / dist * force
		
		@x += @vx *= 0.9
		@y += @vy *= 0.9
	
	draw: ->
		if @deposited_fully
			return
		ctx.save()
		if @collected
			ctx.globalAlpha = 0.1
		ctx.translate(@x, @y)
		ctx.beginPath()
		for i in [0..@sides]
			ctx.lineTo(
				@radius * sin(i / @sides * TAU + @rotation)
				@radius * cos(i / @sides * TAU + @rotation)
			)
		ctx.fillStyle = @color
		ctx.stroke()
		ctx.fill()
		ctx.fillStyle = gradient
		ctx.fill()
		# ctx.rotate(@rotation)
		# ctx.rotate(2 / @sides * TAU)
		# ctx.globalCompositeOperation = "soft-light"
		# ctx.fill()
		# ctx.globalCompositeOperation = "exclusion"
		# ctx.globalAlpha = 1 / @sides
		# for i in [0..@sides]
		# 	ctx.rotate(1 / @sides * TAU)
		# 	ctx.fill()
		ctx.restore()

level_bottom = 500
columns = []
last_checkpoint = 0
x = 0
while x < 1500
	SomeColumn = if random() < 0.5 then PinkColumn else YellowColumn
	width = 20
	if random() < 0.4 and x > last_checkpoint + 400
		SomeColumn = CheckpointColumn
		last_checkpoint = x
		width = 40
	height = random() * level_bottom/2
	column = new SomeColumn(x, level_bottom-height, width, height)
	columns.push column
	
	x += width/4 if width > 20
	
	if random() < 0.3
		SomeColumn = if random() < 0.5 then PinkColumn else YellowColumn
		floater_width = 20
		floater_height = random() * 20 + 20
		floater_y = column.y - floater_height - random() * 250 - if column instanceof CheckpointColumn then 60 else 20
		floating_column = new SomeColumn(x, floater_y, floater_width, floater_height)
		columns.push floating_column
	
	x -= width/4 if width > 20
	
	x += 30 + width + if random() < 0.5 then 10 else 0

gems = []
for x in [0..1500] by 50
	for [0..2]
		gems.push new Gem(x + random() * 50, random() * level_bottom)

player = null
do spawn_player = ->
	for gem in gems when gem.collected
		gem.collected = no
		gem.dropped = yes
	column = player?.checkpoint ? columns[3]
	player = new Player(column.x + 2, column.y)
	player.checkpoint = column
	player.y -= player.h * 5
	player.y -= 1 while player.collision(player.x, player.y)

respawn_player = ->
	spawn_player()
	respawn_sound.play()

view = {cx: player.x, cy: player.y, scale: 1}
view_to = {cx: player.x, cy: player.y, scale: 1}

keys = {}
addEventListener "keydown", (e)->
	keys[e.keyCode] = on
	console.log e.keyCode if e.altKey
addEventListener "keyup", (e)->
	delete keys[e.keyCode]

animate ->
	ctx.fillStyle = "#fff"
	ctx.fillRect 0, 0, canvas.width, canvas.height
	
	ctx.save()
	view_to.cx = player.x
	view_to.cy = player.y
	view_to.scale =
		if canvas.width > 1500 then 2
		else if canvas.width > 1000 then 1.5 else 1
	view.cx += (view_to.cx - view.cx) / 10
	view.cy += (view_to.cy - view.cy) / 10
	view.scale += (view_to.scale - view.scale) / 20
	view.cy = Math.min(view.cy, level_bottom-canvas.height/2/view.scale)
	ctx.scale(view.scale, view.scale)
	ctx.translate(canvas.width/2/view.scale-view.cx, canvas.height/2/view.scale-view.cy)
	
	gem.step() for gem in gems
	gem.draw() for gem in gems
	column.draw() for column in columns
	
	player.step()
	player.draw()
	
	if player.y + player.h > level_bottom
		respawn_player()
	
	ctx.restore()
	
	holding_score = 0
	deposited_score = 0
	for gem in gems
		if gem.deposited
			deposited_score += gem.value
		else if gem.collected
			holding_score += gem.value 
	
	# font_size = max(20, min(canvas.width, canvas.height) / 30)
	# font_size = max(20, canvas.width / 30)
	font_size = max(20, (canvas.width + canvas.height) / 60)
	ctx.font = "#{font_size}px sans-serif"
	ctx.textAlign = "right"
	ctx.textBaseline = "top"
	ctx.fillStyle = "black"
	ctx.fillText(deposited_score, canvas.width-15, 15)
	if holding_score > 0
		ctx.fillStyle = "rgb(0, 150, 0)"
		ctx.fillText("+#{holding_score}", canvas.width-15, 20 + font_size)
