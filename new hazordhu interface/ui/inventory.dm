inventory_ui
	parent_type = /ui
	layer = 100

	var width
	var height

	var inventory_ui/part
		item_slot/item_slots[]

	New(Client, Width, Height)
		..()
		width = Width
		height = Height

	Build()
		..()
		item_slots = new (width * height)
		for(var/n in 1 to item_slots.len)
			item_slots[n] = new /inventory_ui/part/item_slot (src)
		events.Notify(EVENT_BUILT)

	proc/AddItem(obj/item/Item)
		var slot = GetEmptySlot()
		if(slot)
			SetItem(slot, Item)
			return TRUE
		else
			events.Notify(EVENT_MAX_CAPACITY_REACHED)

	proc/AddItems(Items[])
		for(var/obj/item/item in Items)
			if(!AddItem(item))
				break

	proc/GetEmptySlot()
		for(var/inventory_ui/part/item_slot/slot in item_slots)
			if(!slot.GetItem())
				return slot

	proc/SetItem(inventory_ui/part/item_slot/Slot, obj/item/Item)
		item_slots[Slot] = Item
		events.Notify(EVENT_ITEM_ADDED, Slot, Item)

	part
		parent_type = /ui_part

		var inventory_ui/inventory_ui
		New()
			..()
			inventory_ui = ui

		item_slot
			parent_type = /ui_part/item_slot
			icon_state = "inventory"
			underlays = list("background")

			var inventory_ui/inventory_ui
			var slot_name
			var image/item_overlay
			New()
				..()
				inventory_ui = ui
				ui.events.Add(EVENT_ITEM_ADDED, src)
				ui.events.Add(EVENT_ITEM_SWAPPED, src)

			SetItem(obj/item/Item)
				inventory_ui.SetItem(src, Item)

			GetItem()
				return inventory_ui.item_slots[src]

			GetIndex()
				return inventory_ui.item_slots.Find(src)

			MouseDrop(atom/over_object)
				if(istype(over_object, /ui_part/item_slot))
					SwapItem(over_object)

			proc/GetX()
				return (GetIndex() - 1) % inventory_ui.width + 1

			proc/GetY()
				return round((GetIndex() - 1) / inventory_ui.width) + 1

			// events
			proc/Built()
				slot_name = "inventory [GetIndex()] ([GetX()], [GetY()])"
				name = slot_name
				SetRelativeScreenLoc((GetX() - 1) * 32, (GetY() - 1) * 32)

			proc/ItemAdded(Slot, obj/item/Item)
				if(src == Slot)
					if(item_overlay)
						overlays -= item_overlay
					if(Item)
						item_overlay = image(Item, layer = -1)
						overlays += item_overlay
						name = Item.name
					else
						item_overlay = null
						name = slot_name
				else
					if(Item && Item == GetItem())
						SetItem(null)