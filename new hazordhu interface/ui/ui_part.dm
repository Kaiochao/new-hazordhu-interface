ui_part
	parent_type = /obj
	icon = 'ui.dmi'
	layer = 0

	var ui/ui
	var screen_x = 0
	var screen_y = 0

	New(UI)
		ui = UI
		ui.parts += src
		layer += ui.layer
		SetRelativeScreenLoc(screen_x, screen_y)

		ui.events.Add(EVENT_BUILT, src)

	proc/Event(Event, Params[])
		if(hascall(src, Event))
			call(src, Event)(arglist(Params))

	proc/SetRelativeScreenLoc(X, Y)
		screen_x = X
		screen_y = Y
		screen_loc = "[ui.x]:[round(ui.px + X)], [ui.y]:[round(ui.py + Y)]"