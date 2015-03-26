toolbelt_ui
	parent_type = /ui
	layer = 110

	var length

	New(Client, Length)
		..()
		length = Length

	Build()
		..()
		parts.Add(
			new /toolbelt_ui/part/top (src),
			new /toolbelt_ui/part/bottom (src))
		for(var/n in 1 to length)
			parts.Add(new /toolbelt_ui/part/middle (src, n))
		events.Notify(EVENT_BUILT)

	part
		parent_type = /ui_part

		var toolbelt_ui/toolbelt_ui

		New()
			..()
			toolbelt_ui = ui

		top
			icon_state = "corner"
			dir = SOUTH
			proc/Built()
				SetRelativeScreenLoc(0, (toolbelt_ui.length + 1) * 32)

		bottom
			icon_state = "corner"
			dir = NORTH

		middle
			icon_state = "middle"
			New(UI, Index)
				screen_y = Index * 32
				..()