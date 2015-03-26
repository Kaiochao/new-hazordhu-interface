event_handler
	var sender
	var listeners[]

	New(Sender)
		sender = Sender

	listener
		parent_type = /datum
		proc/Event()

	// Broadcasts Event to all of its listeners.
	proc/Notify(Event)
		var params[] = args.Copy(2)
		var event_handler/listener/e
		world.log << "\[Event] [sender]: [Event][params && params.len ? " ([url_decode(list2params(params))])" :])"
		for(var/listener in GetListeners(Event))
			e = listener
			e.Event(Event, params)

	// Make Listener listen to Event.
	proc/Add(Event, Listener)
		if(listeners)
			listeners[Event] = listeners[Event] ? listeners[Event] | Listener : list(Listener)
		else
			listeners = new
			listeners[Event] = list(Listener)

	// Make Listener ignore Event.
	proc/Remove(Event, Listener)
		if(listeners)
			var l[] = listeners[Event]
			l -= Listener
			if(!l.len)
				listeners -= Event
				if(!listeners.len)
					listeners = null

	proc/AddAll(Event, Listeners[])
		for(var/listener in Listeners)
			Add(Event, listener)

	proc/RemoveAll(Event, Listeners[])
		for(var/listener in Listeners)
			Remove(Event, listener)

	proc/GetListeners(Event)
		return listeners && listeners[Event]