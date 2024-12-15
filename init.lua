
ehlphabet = {}
ehlphabet.path = core.get_modpath(core.get_current_modname())

local S = core.get_translator("ehlphabet")

ehlphabet.has_unified_inventory = core.get_modpath("unified_inventory")
			and core.global_exists("unified_inventory") and true or false

-- Register crafting recipes.
dofile(ehlphabet.path .. "/crafts.lua")


-- Helper function to append table to table.
-- Since table.insert_all() might not be available.
local function table_merge(t1, t2)
	for _, v in ipairs(t2) do
		table.insert(t1, v)
	end
	return t1
end


local digits = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
local base_chars = {
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
	"P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
}
local special_chars = {
	"!", "#", "$", "%", "&", "(", ")", "*", "+", ",", "-", ".", "/", ":", ";",
	"<", "=", ">", "?", "@", "'", '"'
}
local german_chars = { "Ä", "Ö", "Ü", "ß" }
local cyrillic_chars = {
	"А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н",
	"О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы", "Ь",
	"Э", "Ю", "Я"
}
local greek_chars = {
	"Α", "Β", "Γ", "Δ", "Ε", "Ζ", "Η", "Θ", "Ι", "Κ", "Λ", "Μ", "Ν", "Ξ", "Ο",
	"Π", "Ρ", "Σ", "Τ", "Υ", "Φ", "Χ", "Ψ", "Ω"
}
local additional_chars = {
	"猫","北","东","東","南","西","站",
}

local characters = {}
local characters_sticker = {}

table_merge(characters, base_chars)
table_merge(characters, digits)
table_merge(characters, special_chars)
table_merge(characters, german_chars)
table_merge(characters, cyrillic_chars)
table_merge(characters, greek_chars)

table_merge(characters_sticker, characters)
table_merge(characters_sticker, additional_chars)
table.insert(characters_sticker, " ")


-- Helper function to detect multi-byte characters.
local function is_multibyte(ch)
	local byte = ch:byte()
	--return (195 == byte) or (208 == byte) or (209 == byte)
	if not byte then
		return false
	else
		return byte > 191
	end
end


-- For backward compatability with [abjphabet].
-- Used by generate() function.
local create_alias = true
-- Helper function to register blocks and stickers.
local function generate(chars, add_to_guides)
	for _, name in ipairs(chars) do
		local byte = name:byte()
		local file, key

		-- Adjust for multi-byte characters.
		local mb = is_multibyte(name)
		if mb then
			mb = byte
			byte = name:byte(2)
			key = "ehlphabet:" .. mb .. byte
			file = ("%03d_%03d"):format(mb, byte)
		else
			key = "ehlphabet:" .. byte
			file = ("%03d"):format(byte)
		end

		-- Register the block node.
		core.register_node(key, {
			description = S('Ehlphabet Block "@1"', name),
			tiles = { "ehlphabet_" .. file .. ".png" },
			paramtype2 = "facedir",
			on_rotate = screwdriver.rotate_simple,
			is_ground_content = false,
			groups = {
				cracky = 3,
				not_in_creative_inventory = add_to_guides and 0 or 1,
				not_in_crafting_guide = add_to_guides and 0 or 1,
				ehlphabet_block = 1,
			},
		})

		-- Backward compat for base latin characters.
		if create_alias then
			core.register_alias("abjphabet:" .. name, key)
		end
		-- Deactivate alias creation on last latin character.
		-- [abjphabet] didn't have more characters.
		if name == "Z" then
			create_alias = false
		end

		-- Register the sticker node.
		core.register_node(key .. "_sticker", {
			description = S('Ehlphabet Sticker "@1"', name),
			tiles = { "ehlphabet_" .. file .. ".png" },
			paramtype = "light",
			paramtype2 = "wallmounted", -- "colorwallmounted",
			on_rotate = screwdriver.rotate_simple,
			drawtype = "nodebox",
			node_box = {
				type = "wallmounted",
				wall_bottom = { -0.5, -0.5, -0.5, 0.5, -0.49, 0.5 },
				wall_top = { -0.5, 0.49, -0.5, 0.5, 0.5, 0.5 },
				wall_side = { -0.5, -0.5, -0.5, -0.49, 0.5, 0.5 },
			},
			is_ground_content = false,
			groups = {
				attached_node = 1,
				dig_immediate = 2,
				not_in_creative_inventory = add_to_guides and 0 or 1,
				not_in_crafting_guide = add_to_guides and 0 or 1,
				not_blocking_trains = 1,
				ehlphabet_sticker = 1,
			},
		})

		-- Register both with [unified_inventory] when available.
		if ehlphabet.has_unified_inventory then
			unified_inventory.register_craft({
				type = "ehlphabet",
				items = { "ehlphabet:block" },
				output = key,
			})
			unified_inventory.register_craft({
				type = "ehlphabet",
				items = { "default:paper" },
				output = key .. "_sticker",
			})
		end
	end
end

-- Register all available blocks and stickers.
generate(characters, ehlphabet.has_unified_inventory)
generate(additional_chars, true)

-- Register blank node.
core.register_node("ehlphabet:block", {
	description = S("Ehlphabet Block (blank)"),
	tiles = { "ehlphabet_000.png" },
	is_ground_content = false,
	groups = { cracky = 3 },
})

-- Register blank sticker.
core.register_node("ehlphabet:32_sticker", {
	description = S("Ehlphabet Sticker (blank)"),
	tiles = { "ehlphabet_000.png" },
	paramtype = "light",
	paramtype2 = "wallmounted", -- "colorwallmounted",
	on_rotate = screwdriver.rotate_simple,
	drawtype = "nodebox",
	node_box = {
		type = "wallmounted",
		wall_bottom = { -0.5, -0.5, -0.5, 0.5, -0.49, 0.5 },
		wall_top = { -0.5, 0.49, -0.5, 0.5, 0.5, 0.5 },
		wall_side = { -0.5, -0.5, -0.5, -0.49, 0.5, 0.5 },
	},
	is_ground_content = false,
	groups = {
		attached_node = 1,
		dig_immediate = 2,
		not_in_creative_inventory = ehlphabet.has_unified_inventory and 0 or 1,
		not_blocking_trains = ehlphabet.has_unified_inventory and 0 or 1,
		ehlphabet_sticker = 1,
	},
})


-- Register printer.
core.register_node("ehlphabet:machine", {
	description = S("Letter Machine"),
	tiles = {
		"ehlphabet_machine_top.png",
		"ehlphabet_machine_bottom.png",
		"ehlphabet_machine_side.png",
		"ehlphabet_machine_side.png",
		"ehlphabet_machine_back.png",
		"ehlphabet_machine_front.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = { cracky = 2 },

	-- "Can you dig it?" -Cyrus
	can_dig = function(pos)
		local meta = core.get_meta(pos)
		local inv = meta:get_inventory()
		if not inv:is_empty("input") or not inv:is_empty("output") then
			return false
		end
		return true
	end,

	on_construct = function(pos)
		local meta = core.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("input", 1)
		inv:set_size("output", 1)
		meta:set_string("formspec",
			"size[8,6]" ..
			"field[3.8,.5;1,1;lettername;" .. S("Letter") .. ";]" ..
			"list[context;input;2.5,0.2;1,1;]" ..
			"list[context;output;4.5,0.2;1,1;]" ..
			"list[current_player;main;0,2;8,4;]" ..
			"listring[current_player;main]" ..
			"listring[context;input]" ..
			"listring[current_player;main]" ..
			"listring[context;output]" ..
			"button[2.54,-0.25;3,4;name;" .. S("Blank -> Letter") .. "]"
		)
	end,

	on_receive_fields = function(pos, _, fields)
		local ch = fields.lettername
		if not ch or ch == "" then
			return
		end

		local meta = core.get_meta(pos)
		local inv = meta:get_inventory()
		local inputstack = inv:get_stack("input", 1)
		local outputstack = inv:get_stack("output", 1)
		local input_stack_name = inputstack:get_name()
		local input_is_block = input_stack_name == "ehlphabet:block"
		local input_is_paper = input_stack_name == "default:paper"
		if not (input_is_block or input_is_paper) then
			return
		end

		local key = ch:byte()
		if is_multibyte(ch) then
			key = ch:byte(1) .. ch:byte(2)
		end
		if input_is_paper then
			key = key .. "_sticker"
		end
		local out_stack_name = outputstack:get_name()
		if out_stack_name ~= "" and out_stack_name ~= "ehlphabet:" .. key then
			-- Output inventory is not empty or contains other type
			-- than what is being printed -> abort.
			return
		end

		local clist = input_is_paper and characters_sticker or characters
		for _, v in ipairs(clist) do
			if v == ch then
				-- Input char is a valid match.
				inv:add_item("output", "ehlphabet:" .. key)
				inputstack:take_item()
				inv:set_stack("input", 1, inputstack)
				break
			end
		end
	end,
})

--  Alias  (Och_Noe 20180124)
core.register_alias("abjphabet:machine", "ehlphabet:machine")
--

--print("[ehlphabet] loaded")

