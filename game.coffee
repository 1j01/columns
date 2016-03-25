
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


columns = [
	new PinkColumn(150, 50, 20, 150)
	new YellowColumn(50, 50, 20, 150)
]

animate ->
	{width: w, height: h} = canvas
	
	ctx.fillStyle = "#fff"
	ctx.fillRect 0, 0, w, h
	
	for column in columns
		column.draw()
