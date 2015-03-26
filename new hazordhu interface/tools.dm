tool
	var name as text

	// specifies how many slots the tool has access to.
	var crafting_slots as num

	// a list of resource types associated with a material type
	// e.g. list(/.../boulder = /.../stone)
	var gather_types[]

	// graphical representation of this tool
	var image/icon

	// returns true or false based on success
	proc/Gather()

	hatchet
		name = "hatchet"
		crafting_slots = 2

		gather_types = list(
			/obj/resource/tree = /obj/item/log)

		icon = new /image {
			icon = 'hatchet.dmi'
			icon_state = "item"
		}

	pickaxe
		name = "pickaxe"
		gather_types = list(
			/obj/resource/boulder = /obj/item/stone)

		icon = new /image {
			icon = 'pickaxe.dmi'
			icon_state = "item"
		}

	chisel
		name = "chisel"
		crafting_slots = 5

		icon = new /image {
			icon = 'chisel.dmi'
			icon_state = "item"
		}