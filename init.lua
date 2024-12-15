
ehlphabet = {}
ehlphabet.path = core.get_modpath(core.get_current_modname())

-- TODO: use core translation system
-- Intllib
local S = dofile(ehlphabet.path .. "/intllib.lua")
ehlphabet.intllib = S

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
	-- return (195 == byte) or (208 == byte) or (209 == byte)
	if not byte then
		return false
	else
		return byte > 191
	end
end


		description = "Printing",
		icon = 'ehlphabet_machine_front.png',
		width = 1,
		height = 1,
	})
end

local function generate(characters, craftable)
    for _, name in ipairs(characters) do
-- For backward compatability with [abjphabet].
-- Used by generate() function.
local create_alias = true
		local desc = S("Ehlphabet Block '@1'", name)
-- Helper function to generate blocks and stickers.
		local byte = name:byte()
		local mb = is_multibyte(name)
		local file, key

		-- Adjust for multi-byte characters.
		if mb then
			mb = byte
			byte = name:byte(2)
			key = "ehlphabet:" .. mb .. byte
			file = ("%03d_%03d"):format(mb, byte)
		else
			key = "ehlphabet:" .. byte
			file = ("%03d"):format(byte)
		end

        minetest.register_node(
            key,
            {
            }
        )
		-- Register the block node.
			description = desc,
			tiles = { "ehlphabet_" .. file .. ".png" },
			paramtype2 = "facedir",
			on_rotate = screwdriver.rotate_simple ,
			is_ground_content = false,
			groups = {
				cracky = 3,
				not_in_creative_inventory = craftable and 0 or 1,
				not_in_crafting_guide = craftable and 0 or 1,
				ehlphabet_block = 1,
			},
		--core.register_craft({ type = "shapeless", output = "ehlphabet:block", recipe = { key } })

		-- Backward compat for base latin characters.
		if create_alias then
			core.register_alias("abjphabet:" .. name, key)
		end
		-- Deactivate alias creation on last latin character.
		if name == "Z" then
			create_alias = false
		end

        minetest.register_node(
            key.."_sticker",
            {
                description = desc.."Sticker",
                tiles = {"ehlphabet_" .. file .. ".png"},
                paramtype = "light",
                paramtype2 = "wallmounted", -- "colorwallmounted",
                on_rotate = screwdriver.rotate_simple ,
                drawtype = "nodebox",
                is_ground_content = false,
                drop = "",  -- new
            node_box = {
                type = "wallmounted",
                wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.49, 0.5},
                wall_top = {-0.5, 0.49, -0.5, 0.5, 0.5, 0.5},
                wall_side = {-0.5, -0.5, -0.5, -0.49, 0.5, 0.5},
                    },
                groups = {
                    attached_node = 1,
                    dig_immediate = 2,
                    not_in_creative_inventory = craftable and 0 or 1,
                    not_in_crafting_guide = craftable and 0 or 1,
                    not_blocking_trains = 1,
                },
            }
        )
		-- Register the sticker node.

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

-- Generate all available blocks and stickers.
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
	tiles = { "ehlphabet_000.png" },
	paramtype = "light",
	paramtype2 = "wallmounted", -- "colorwallmounted",
	on_rotate = screwdriver.rotate_simple,
	drawtype = "nodebox",
	is_ground_content = false,
	drop = "",
	node_box = {
		type = "wallmounted",
		wall_bottom = { -0.5, -0.5, -0.5, 0.5, -0.49, 0.5 },
		wall_top = { -0.5, 0.49, -0.5, 0.5, 0.5, 0.5 },
		wall_side = { -0.5, -0.5, -0.5, -0.49, 0.5, 0.5 },
	},
	groups = {
		attached_node = 1,
		dig_immediate = 2,
		not_in_creative_inventory = ehlphabet.has_unified_inventory and 0 or 1,
		not_blocking_trains = ehlphabet.has_unified_inventory and 0 or 1,
	},
})

local key = "ehlphabet:32"
local file = ("%03d"):format(32)
local desc = S("Ehlphabet Block '@1'", name)

minetest.register_node(
 key.."_sticker",
 {
    description = desc.."Sticker",

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
	groups = { cracky = 2 },
	is_ground_content = false,




        can_dig = function(pos, player)
            local meta = minetest.env:get_meta(pos)
            local inv = meta:get_inventory()
            if not inv:is_empty("input") or not inv:is_empty("output") then
                if player then
                    minetest.chat_send_player(
                        player:get_player_name(),
                        S("You cannot dig the @1 with blocks inside", S("Letter Machine"))
                    )
                end -- end if player
                return false
            end -- end if not empty
            return true
        end, -- end can_dig function

        after_place_node = function(pos, placer)
            local meta = minetest.env:get_meta(pos)
        end,

        on_construct = function(pos)
            local meta = minetest.env:get_meta(pos)
            meta:set_string(
                "formspec",
                "invsize[8,6;]" ..
                "field[3.8,.5;1,1;lettername;" .. S("Letter") .. ";]" ..
                "list[current_name;input;2.5,0.2;1,1;]" ..
                "list[current_name;output;4.5,0.2;1,1;]" ..
                "list[current_player;main;0,2;8,4;]" ..
                "button[2.54,-0.25;3,4;name;" .. S("Blank -> Letter") .. "]"
            )
            local inv = meta:get_inventory()
            inv:set_size("input", 1)
            inv:set_size("output", 1)
        end,

        on_receive_fields = function(pos, formname, fields, sender)
            local meta = minetest.env:get_meta(pos)
            local inv = meta:get_inventory()
            local inputstack = inv:get_stack("input", 1)
            local outputstack = inv:get_stack("output", 1)
            local ch = fields.lettername

            if ch ~= nil and ch ~= "" then
                if  inputstack:get_name() == "ehlphabet:block"
                 or inputstack:get_name() == "default:paper" then
                    local ost = outputstack:get_name()
                    local mb = is_multibyte(ch)
                    local key = mb and (ch:byte(1) .. ch:byte(2)) or ch:byte()
                    key = key .. (inputstack:get_name() == "default:paper" and "_sticker" or "")
                    if ost ~= "" and
                       ost ~= "ehlphabet:"..key then
                        --  other type in output slot -> abort
                        return
                    end
                    local clist = characters
                    if inputstack:get_name() == "default:paper" then
		       clist = characters_sticker
		    end
                    for _, v in pairs(clist) do
                    end
                end
            end
        end
    }
)
	-- "Can you dig it?" -Cyrus
			if v == ch then
				inv:add_item("output", "ehlphabet:" .. key_new)
				inputstack:take_item()
				inv:set_stack("input", 1, inputstack)
				break
			end

--  Alias  (Och_Noe 20180124)
core.register_alias("abjphabet:machine", "ehlphabet:machine")
--



print("[ehlphabet] loaded")

