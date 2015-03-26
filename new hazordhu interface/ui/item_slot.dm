ui_part
	item_slot
		// procs to be implemented
		// set the item to be displayed by this slot
		proc/SetItem(obj/item/Item)

		// returns the /obj/item displayed by this slot
		proc/GetItem()

		// returns a number for where this slot is in a 1-dimensional item list
		proc/GetIndex()

		// procs not to be implemented
		proc/SwapItem(ui_part/item_slot/OtherSlot)
			var obj/item/a = GetItem()
			var obj/item/b = OtherSlot.GetItem()

			SetItem(null)
			OtherSlot.SetItem(null)

			SetItem(b)
			OtherSlot.SetItem(a)

			ui.events.Notify(EVENT_ITEM_SWAPPED, src, OtherSlot, a, b)
			OtherSlot.ui.events.Notify(EVENT_ITEM_SWAPPED, OtherSlot, src, b, a)