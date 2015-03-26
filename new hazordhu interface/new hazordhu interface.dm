world
	maxx = 10
	maxy = 10
	fps = 60

mob
	var toolbelt_ui/toolbelt_ui

	var tools[] = newlist(
		/tool/hatchet,
		/tool/pickaxe,
		/tool/chisel)

	var inventory_ui/inventory_ui

	Login()
		..()
		inventory_ui = new (client, 3, 3)
		inventory_ui.Build()
		inventory_ui.Show()

		inventory_ui.AddItems(newlist(/obj/item/log, /obj/item/board, /obj/item/stone, /obj/item/brick))

		toolbelt_ui = new (client, 3)
		toolbelt_ui.SetScreenLoc(1, 4)
		toolbelt_ui.Build()
		toolbelt_ui.Show()

		for(var/n in 1 to tools.len)
			var tool_ui/tool_ui = new (client, tools[n])
			tools[tools[n]] = tool_ui
			tool_ui.SetScreenLoc(1, n + 4)
			tool_ui.Build()
			tool_ui.Show()

		if(0) spawn for()
			sleep world.tick_lag

			var dx = 0.5 * cos(world.time * 10)
			var dy = 0.5 * sin(world.time * 10)
			toolbelt_ui.Move(dx, dy)

			for(var/n in 1 to tools.len)
				var tool_ui/tool_ui = tools[tools[n]]
				tool_ui.Move(dx, dy)