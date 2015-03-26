ui
	var client/client
	var layer
	var x = 1
	var y = 1
	var px = 0
	var py = 0

	var parts[]

	var event_handler/events

	New(Client)
		events = new (src)
		client = Client

	proc/Build()
		parts = new

	proc/Show()
		client.screen.Add(parts)
		events.Notify(EVENT_SHOWN)

	proc/Hide()
		client.screen.Remove(parts)
		events.Notify(EVENT_HIDDEN)

	proc/SetScreenLoc(X, Y, Px, Py)
		x = X
		y = Y
		px = Px
		py = Py
		for(var/ui_part/part in parts)
			part.SetRelativeScreenLoc(part.screen_x, part.screen_y)

	proc/Move(Px, Py)
		SetScreenLoc(x, y, px + Px, py + Py)

	expandable
		var collapsed_parts[]
		var expanded_parts[]

		Build()
			..()
			collapsed_parts = new
			expanded_parts = new

		Show()
			client.screen.Add(collapsed_parts)
			events.Notify(EVENT_SHOWN)

		proc/Expand()
			client.screen.Remove(collapsed_parts)
			client.screen.Add(expanded_parts)
			events.Notify(EVENT_EXPANDED)

		proc/Collapse()
			client.screen.Remove(expanded_parts)
			client.screen.Add(collapsed_parts)
			events.Notify(EVENT_COLLAPSED)