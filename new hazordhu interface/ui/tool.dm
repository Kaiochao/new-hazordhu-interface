tool_ui
	parent_type = /ui/expandable
	layer = 100

	var tool/tool
	var tool_ui/part
		tool_display/tool_display

		crafting_slot/crafting_slots[]
		plus/pluses[]
		equals/equals

		button
			expand/expand_button
			collapse/collapse_button
			gather/gather_button
			craft/craft_button

	New(Client, Tool)
		..()
		tool = Tool

	Build()
		..()
		tool_display = new (src)
		expand_button = new (src)
		collapse_button = new (src)

		collapsed_parts.Add(tool_display, expand_button)
		expanded_parts.Add(tool_display, collapse_button)

		if(IsCrafting())
			craft_button = new (src)
			crafting_slots = new (CraftingSlotCount())
			for(var/n in 1 to crafting_slots.len)
				crafting_slots[n] = new /tool_ui/part/crafting_slot (src)
			if(crafting_slots.len > 1)
				pluses = new (crafting_slots.len - 1)
				for(var/n in 1 to pluses.len)
					pluses[n] = new /tool_ui/part/plus (src)
				expanded_parts.Add(pluses)
			equals = new (src)
			expanded_parts.Add(equals, craft_button, crafting_slots)

		if(IsGathering())
			gather_button = new (src)
			expanded_parts.Add(gather_button)

		events.Notify(EVENT_BUILT)

	Expand()
		..()
		var tx = 0
		if(crafting_slots) tx -= (crafting_slots.len + 1) * 32
		var matrix/m = matrix(tx, 0, MATRIX_TRANSLATE)
		for(var/ui_part/part in expanded_parts)
			var matrix/m2 = part.transform
			part.transform *= m
			animate(part, transform = m2, time = 5, easing = BOUNCE_EASING)

	Collapse()
		var tx = 0
		if(crafting_slots) tx -= (crafting_slots.len + 1) * 32
		var matrix/m = matrix(tx, 0, MATRIX_TRANSLATE)
		var m2[expanded_parts.len]
		for(var/ui_part/part in expanded_parts)
			m2[part] = part.transform
			animate(part, transform = part.transform * m, time = 5, easing = SINE_EASING | EASE_OUT)
		if(crafting_slots) sleep 5
		for(var/ui_part/part in expanded_parts)
			part.transform = m2[part]
		..()

	// For crafting tools
	proc/IsCrafting()
		return !!CraftingSlotCount()

	proc/CraftingSlotCount()
		return tool.crafting_slots

	proc/CraftingItems()
		var items[] = crafting_slots.Copy()
		for(var/n in 1 to items.len)
			items[n] = items[items[n]]
		return items

	proc/Craft()
		events.Notify(EVENT_CRAFT_ATTEMPTED)

	proc/AddCraftingItem(obj/item/Item, tool_ui/part/Slot)
		if(Item in CraftingItems()) return
		if(isnum(Slot)) Slot = crafting_slots[Slot]
		crafting_slots[Slot] = Item
		events.Notify(EVENT_ADDED_CRAFTING_ITEM, Slot, Item)

	proc/RemoveCraftingItem(obj/item/Item, tool_ui/part/Slot)
		crafting_slots[Slot] = null
		events.Notify(EVENT_REMOVED_CRAFTING_ITEM, Slot, Item)

	proc/GetCraftingItem(tool_ui/part/Slot)
		if(isnum(Slot)) Slot = crafting_slots[Slot]
		return crafting_slots[Slot]

	// For gathering tools
	proc/IsGathering()
		return !!tool.gather_types

	proc/Gather()
		events.Notify(EVENT_GATHER_ATTEMPTED)
		if(tool.Gather())
			events.Notify(EVENT_GATHER_SUCCEEDED)
		else
			events.Notify(EVENT_GATHER_FAILED)

	part
		parent_type = /ui_part

		var tool_ui/tool_ui

		New()
			..()
			tool_ui = ui

		tool_display
			icon = null
			layer = 1
			mouse_opacity = FALSE

			var image/tool_image

			proc/Built()
				tool_image = image(tool_ui.tool.icon, layer = -1)
				overlays = list(tool_image)

				var matrix/m = transform
				m.Scale(22/32)
				transform = m

				ui.events.Add(EVENT_EXPANDED, src)
				ui.events.Add(EVENT_COLLAPSED, src)

			proc/Expanded()
				SetRelativeScreenLoc(tool_ui.collapse_button.screen_x - 2, 0)

			proc/Collapsed()
				SetRelativeScreenLoc(0, 0)

		button
			var command

			Click()
				call(tool_ui, command)()

			expand
				icon_state = "expand"
				command = "Expand"
				proc/Built()
					name = tool_ui.tool.name

			collapse
				icon_state = "collapse"
				command = "Collapse"
				proc/Built()
					var sx = 2
					if(tool_ui.crafting_slots)
						sx += (tool_ui.crafting_slots.len + 1) * 32
					SetRelativeScreenLoc(sx, 0)

			gather
				icon_state = "gather"
				command = "Gather"
				layer = 2
				proc/Built()
					var sx = tool_ui.collapse_button.screen_x
					SetRelativeScreenLoc(sx, 0)

			craft
				icon_state = "craft"
				layer = 2
				command = "Craft"
				underlays = list("slot")
				proc/Built()
					SetRelativeScreenLoc(tool_ui.collapse_button.screen_x - 32, 0)

		crafting_slot
			parent_type = /ui_part/item_slot

			icon_state = "slot"

			var tool_ui/tool_ui
			var image/item_image

			New()
				..()
				tool_ui = ui
				ui.events.Add(EVENT_ADDED_CRAFTING_ITEM, src)
				ui.events.Add(EVENT_REMOVED_CRAFTING_ITEM, src)

			// item_slot implementation
			SetItem(obj/item/Item)
				if(Item)
					tool_ui.AddCraftingItem(Item, src)
				else if(GetItem())
					tool_ui.RemoveCraftingItem(GetItem(), src)

			GetItem()
				return tool_ui.GetCraftingItem(src)

			GetIndex()
				return tool_ui.crafting_slots.Find(src)

			MouseDrop(atom/over_object)
				if(istype(over_object, /ui_part/item_slot))
					SwapItem(over_object)

			// events
			proc/AddedCraftingItem(Slot, obj/item/Item)
				if(src == Slot)
					item_image = image(Item, layer = -1)
					item_image.pixel_x = -4
					overlays += item_image

			proc/RemovedCraftingItem(Slot, obj/item/Item)
				if(src == Slot)
					overlays -= item_image

			proc/Built()
				name = "crafting slot [GetIndex()]"
				SetRelativeScreenLoc(32*(GetIndex() - 1) + 2, 0)

		plus
			layer = 1
			icon_state = "+"
			proc/Built()
				SetRelativeScreenLoc(tool_ui.pluses.Find(src) * 32 - 4, 13)

		equals
			layer = 10
			icon_state = "="
			proc/Built()
				SetRelativeScreenLoc(tool_ui.crafting_slots.len * 32 - 4, 13)