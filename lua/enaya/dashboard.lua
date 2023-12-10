local kind = require("enaya.kind")

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "custom"

local header = {
  type = "text",
  val = require("enaya.banners").dashboard(),
  opts = {
    position = "center",
    hl = "Comment",
  },
}

local function getGreeting(name)
  local tableTime = os.date("*t")
  local datetime = os.date(" %d-%m-%Y   %H:%M")
  local hour = tableTime.hour
  local greetingsTable = {
    [1] = "  Sleep well",
    [2] = "  Good morning",
    [3] = "  Good afternoon",
    [4] = "  Good evening",
    [5] = " 󰖔 Good night",
  }
  local greetingIndex = 0
  if hour == 23 or hour < 7 then
    greetingIndex = 1
  elseif hour < 12 then
    greetingIndex = 2
  elseif hour >= 12 and hour < 18 then
    greetingIndex = 3
  elseif hour >= 18 and hour < 21 then
    greetingIndex = 4
  elseif hour >= 21 then
    greetingIndex = 5
  end
  return datetime .. " " .. greetingsTable[greetingIndex] .. ", " .. name
end

local userName = "enaya"
local greeting = getGreeting(userName)

local heading = {
  type = "text",
  val = greeting,
  opts = {
    position = "center",
    hl = "Keyword",
    -- width = 45,
  },
}

local fortune = require("alpha.fortune")()
-- fortune = fortune:gsub("^%s+", ""):gsub("%s+$", "")
local footer = {
  type = "text",
  val = fortune,
  opts = {
    position = "center",
    hl = "Comment",
    hl_shortcut = "Comment",
  },
}

local function button(sc, txt, keybind)
  local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

  local opts = {
    position = "center",
    text = txt,
    shortcut = sc,
    cursor = 5,
    width = 38,
    align_shortcut = "right",
    hl_shortcut = "Number",
    hl = "Function",
  }
  if keybind then
    opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
  end

  return {
    type = "button",
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
      vim.api.nvim_feedkeys(key, "normal", false)
    end,
    opts = opts,
  }
end

local buttons = {
  type = "group",
  val = {
    button("f", " " .. kind.cmp_kind.Folder .. " Find file", ":Telescope find_files<CR>"),
    button("e", " " .. kind.icons.dart .. " Explore", "<CMD>ene!<CR>"),
    button("t", " " .. kind.icons.magic .. " Find text", "<CMD>Telescope live_grep<CR>"),
    button(
      " gg",
      " " .. kind.icons.git .. "  Lazygit",
      ":lua require('lvim.core.terminal')._exec_toggle({cmd = 'lazygit', count = 1, direction = 'float'})<CR>"
    ),
    button("r", " " .. kind.icons.clock .. " Recents", ":Telescope oldfiles<CR>"),
    button("q", " " .. kind.icons.exit .. " Quit", ":q<CR>"),
  },
  opts = {
    spacing = 1,
  },
}

local section = {
  header = header,
  buttons = buttons,
  -- plugin_count = plugin_count,
  heading = heading,
  footer = footer,
}

lvim.builtin.alpha.custom = {
  config = {
    layout = {
      { type = "padding", val = 2 },
      section.header,
      { type = "padding", val = 2 },
      section.heading,
      -- section.plugin_count,
      { type = "padding", val = 1 },
      section.buttons,
      section.footer,
    },
    opts = {
      margin = 5,
    },
  },
}
