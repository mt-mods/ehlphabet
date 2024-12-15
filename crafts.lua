-- TODO: xcompat: paper, stick, coal lump

core.register_craft({
	type = "shapeless",
	output = "ehlphabet:block",
	recipe = { "group:ehlphabet_block" },
if ehlphabet.has_unified_inventory then
	unified_inventory.register_craft_type("ehlphabet", {
		description = "Printing",
		icon = 'ehlphabet_machine_front.png',
		width = 1,
		height = 1,
	})

core.register_craft({
	output = "ehlphabet:block 8",
	recipe = {
		{ "default:paper", "default:paper", "default:paper" },
		{ "default:paper", "", "default:paper" },
		{ "default:paper", "default:paper", "default:paper" },
	},
})
	unified_inventory.register_craft({
		type = "ehlphabet",
		items = { "default:paper" },
		output = "ehlphabet:32_sticker",
	})
end

-- Build the machine!
core.register_craft({
	output = "ehlphabet:machine",
	recipe = {
		{ "default:stick", "default:coal_lump", "default:stick" },
		{ "default:coal_lump", "ehlphabet:block", "default:coal_lump" },
		{ "default:stick", "default:coal_lump", "default:stick" },
	},
})

-- Blank blocks.
-- Uncraft blocks back into paper
core.register_craft({
	output = "default:paper",
	recipe = { "ehlphabet:block" },
	type = "shapeless",
})

-- Recycle printed blocks.
-- Recycle printed stickers.
-- Chinese character blocks - craft from latin characters.
core.register_craft({
	output = "ehlphabet:231140 4",
	recipe = {
		{ "", "", "" },
		{ "ehlphabet:78", "", "" },
		{ "ehlphabet:69", "ehlphabet:75", "ehlphabet:79" },
	},
})

core.register_craft({
	output = "ehlphabet:229140 5",
	recipe = {
		{ "ehlphabet:78", "ehlphabet:79", "ehlphabet:82" },
		{ "ehlphabet:84", "ehlphabet:72", "" },
		{ "", "", "" },
	},
})

core.register_craft({
	output = "ehlphabet:228184 5",
	recipe = {
		{ "ehlphabet:69", "ehlphabet:65", "ehlphabet:83" },
		{ "ehlphabet:84", "", "ehlphabet:83" },
		{ "", "", "" },
	},
})

core.register_craft({
	output = "ehlphabet:230157 5",
	recipe = {
		{ "ehlphabet:69", "ehlphabet:65", "ehlphabet:83" },
		{ "ehlphabet:84", "", "ehlphabet:84" },
		{ "", "", "" },
	},
})

core.register_craft({
	output = "ehlphabet:229141 5",
	recipe = {
		{ "ehlphabet:83", "ehlphabet:79", "ehlphabet:85" },
		{ "ehlphabet:84", "ehlphabet:72", "" },
		{ "", "", "" },
	},
})

core.register_craft({
	output = "ehlphabet:232165 4",
	recipe = {
		{ "ehlphabet:87", "ehlphabet:69", "ehlphabet:83" },
		{ "ehlphabet:84", "", "" },
		{ "", "", "" },
	},
})

core.register_craft({
	output = "ehlphabet:231171 7",
	recipe = {
		{ "ehlphabet:83", "ehlphabet:84", "ehlphabet:65" },
		{ "ehlphabet:84", "ehlphabet:73", "ehlphabet:79" },
		{ "ehlphabet:78", "", "" },
	},
})

-- Chinese stickers.
core.register_craft({
	output = "ehlphabet:231140_sticker 4",
	recipe = {
		{ "", "", ""},
		{ "ehlphabet:78_sticker", "", "" },
		{ "ehlphabet:69_sticker", "ehlphabet:75_sticker", "ehlphabet:79_sticker" },
	},
})

core.register_craft({
	output = "ehlphabet:229140_sticker 5",
	recipe = {
		{ "ehlphabet:78_sticker", "ehlphabet:79_sticker", "ehlphabet:82_sticker" },
		{ "ehlphabet:84_sticker", "ehlphabet:72_sticker", "" },
		{ "", "", "" },
	},
})

core.register_craft({
	output = "ehlphabet:228184_sticker 5",
	recipe = {
		{ "ehlphabet:69_sticker", "ehlphabet:65_sticker", "ehlphabet:83_sticker" },
		{ "ehlphabet:84_sticker", "", "ehlphabet:83_sticker" },
		{ "", "", "" },
	},
})

core.register_craft({
	output = "ehlphabet:230157_sticker 5",
	recipe = {
		{ "ehlphabet:69_sticker", "ehlphabet:65_sticker", "ehlphabet:83_sticker" },
		{ "ehlphabet:84_sticker", "", "ehlphabet:84_sticker" },
		{ "", "", "" },
	},
})

core.register_craft({
	output = "ehlphabet:229141_sticker 5",
	recipe = {
		{ "ehlphabet:83_sticker", "ehlphabet:79_sticker", "ehlphabet:85_sticker" },
		{ "ehlphabet:84_sticker", "ehlphabet:72_sticker", "" },
		{ "", "", "" },
	},
})

core.register_craft({
	output = "ehlphabet:232165_sticker 4",
	recipe = {
		{ "ehlphabet:87_sticker", "ehlphabet:69_sticker", "ehlphabet:83_sticker" },
		{ "ehlphabet:84_sticker", "", "" },
		{ "", "", "" },
	},
})

core.register_craft({
	output = "ehlphabet:231171_sticker 7",
	recipe = {
		{ "ehlphabet:83_sticker", "ehlphabet:84_sticker", "ehlphabet:65_sticker" },
		{ "ehlphabet:84_sticker", "ehlphabet:73_sticker", "ehlphabet:79_sticker" },
		{ "ehlphabet:78_sticker", "", "" },
	},
})

