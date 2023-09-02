local dia = require("./deps/discordia")
local tools = require("./deps/discordia-slash").util.tools()
local CLIENT = dia.Client():useApplicationCommands()
local config = require("./config.lua")

CLIENT:on("ready", function()
  -- you'll have to load application commands into discord first in order to use them.
  -- however, after loading once, you don't have to load them everytime your bot loads.

  -- gets a list of registered application commands from discord bot
  local commands = CLIENT:getGlobalApplicationCommands()
  -- deletes any existing application command from the bot's commands list
  for commandId in pairs(commands) do
    CLIENT:deleteGlobalApplicationCommand(commandId)
  end

  local slashCommand = {}
  local option = {}

  -- creates a slash command constructor
  slashCommand = tools.slashCommand("blep", "Send a random adorable animal photo")
  -- creates a string option constructor
  option = tools.string("animal", "The type of the animal")
  -- adds three choices into the option
  option = option:addChoice(tools.choice("Dog", "animal_dog"))
  option = option:addChoice(tools.choice("Cat", "animal_cat"))
  option = option:addChoice(tools.choice("Penguin", "animal_penguin"))
  -- and sets as a required option
  option = option:setRequired(true)
  -- adds option into slash command "blep"
  slashCommand = slashCommand:addOption(option)

  -- creates another string option constructior
  option = tools.string("only_smol", "Whether to show only baby animals")
  -- adds another option into slash command "blep"
  slashCommand = slashCommand:addOption(option)

  -- creates user command and message command
  local userCommand = tools.userCommand("Get avatar")
  local messageCommand = tools.messageCommand("Look message")

  -- register application commands into the bot's commands
  CLIENT:createGlobalApplicationCommand(slashCommand)
  CLIENT:createGlobalApplicationCommand(userCommand)
  CLIENT:createGlobalApplicationCommand(messageCommand)

  CLIENT:info("Ready!");
end)

CLIENT:on("slashCommand", function(interaction, command, args)
  if command.name == "blep" then

    if args.animal == "animal_dog" then
      interaction:reply("You chose a dog!") -- pass a true value to set the reply ephemeral
    elseif args.animal == "animal_cat" then
      interaction:reply(interaction.user.name .. " chose a cat!")
    elseif args.animal == "animal_penguin" then
      interaction:reply("You chose a penguin!")
    end

  end
end)

CLIENT:on("messageCommand", function(interaction, command, message)
  if command.name == "Look message" then
    interaction:reply(message.content .. "\nhmm yes, this message is made out of message.", true)
  end
end)

CLIENT:on("userCommand", function(interaction, command, member)
  if command.name == "Get avatar" then
    interaction:reply(member:getAvatarURL(1024), true)
  end
end)

CLIENT:run('Bot '..config.token)