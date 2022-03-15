--[[----------------------------------------------------------------------------
This file is part of Friday Night Funkin' Rewritten

Copyright (C) 2021  HTV04

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
------------------------------------------------------------------------------]]

local leftFunc, rightFunc, confirmFunc, backFunc, drawFunc

local menuState

local weekNum = 2
local songNum, songAppend
local songDifficulty = 2

local titleBG = graphics.newImage(love.graphics.newImage(graphics.imagePath("menu/menuBG")))

local options = love.filesystem.load("sprites/menu/menuButtons.lua")()
local story = love.filesystem.load("sprites/menu/menuButtons.lua")()
local freeplay = love.filesystem.load("sprites/menu/menuButtons.lua")()

local menuButton

local selectSound = love.audio.newSource("sounds/menu/select.ogg", "static")
local confirmSound = love.audio.newSource("sounds/menu/confirm.ogg", "static")

local difficultyStrs = { 
	"-easy",
	"",
	"-hard"
}


local function switchMenu(menu)
	menuState = 1
end

story.x = -350
freeplay.x = -350
story.y = -200
freeplay.y = 0
options.y = 200


return {
	enter = function(self, previous)
		menuButton = 1
		songNum = 0
        story:animate("story hover", true)
        freeplay:animate("freeplay", true)
        options:animate("options", true)

		cam.sizeX, cam.sizeY = 0.9, 0.9
		camScale.x, camScale.y = 0.9, 0.9

		switchMenu(1)

		graphics.setFade(0)
		graphics.fadeIn(0.5)

        if useDiscordRPC then
            presence = {
                state = "Choosing a mode",
                details = "In the Gamemode Select Menu",
                largeImageKey = "logo",
                startTimestamp = now,
            }
            nextPresenceUpdate = 0
        end

	end,

	update = function(self, dt)
        options:update(dt)
        story:update(dt)
        freeplay:update(dt)

		if not graphics.isFading() then
			if input:pressed("up") then
				audio.playSound(selectSound)

                if menuButton ~= 1 then
                    menuButton = menuButton - 1
                else
                    menuButton = 2
                end -- change 3 to the amount of options there are.

                if menuButton == 1 then
                    story:animate("story hover", true)
                    freeplay:animate("freeplay", true)
                    options:animate("options", true)
                elseif menuButton == 2 then
                    story:animate("story", true)
                    freeplay:animate("freeplay hover", true)
                    options:animate("options", true)
                elseif menuButton == 3 then
                    story:animate("story", true)
                    freeplay:animate("freeplay", true)
                    options:animate("options hover", true)
                end

			elseif input:pressed("down") then
				audio.playSound(selectSound)

                if menuButton ~= 2 then
                    menuButton = menuButton + 1
                else
                    menuButton = 1
                end

                if menuButton == 1 then
                    story:animate("story hover", true)
                    freeplay:animate("freeplay", true)
                    options:animate("options", true)
                elseif menuButton == 2 then
                    story:animate("story", true)
                    freeplay:animate("freeplay hover", true)
                    options:animate("options", true)
                elseif menuButton == 3 then
                    story:animate("story", true)
                    freeplay:animate("freeplay", true)
                    options:animate("options hover", true)
                end

			elseif input:pressed("confirm") then
				audio.playSound(confirmSound)

				--confirmFunc()
                if menuButton == 1 then
                    menu:musicStop()
                    songNum = 1
        
                    status.setLoading(true)
        
                    graphics.fadeOut(
                        0.5,
                        function()
                            if useDiscordRPC then
                                presence = {
                                    state = "Selected a week",
                                    details = "Playing a week",
                                    largeImageKey = "logo",
                                    startTimestamp = now,
                                }
                                nextPresenceUpdate = 0
                            end
                            
                            songAppend = difficultyStrs[songDifficulty]
        
                            storyMode = true
        
                            Gamestate.switch(weekData[weekNum], songNum, songAppend)
        
                            status.setLoading(false)
                        end
                    )
                elseif menuButton == 2 then
                    status.setLoading(true)
                    Gamestate.switch(menuSettings)
                    status.setLoading(false)
                elseif menuButton == 3 then
                    status.setLoading(true)
                    Gamestate.switch(menuSettings)
                    status.setLoading(false)
                end
			elseif input:pressed("back") then
				audio.playSound(selectSound)

				Gamestate.switch(menu)
			end
		end
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)

			titleBG:draw()

            story:draw()
            freeplay:draw()

			love.graphics.push()
				love.graphics.scale(cam.sizeX, cam.sizeY)
                love.graphics.printf("Funkin' Vasion: v1.2.0\nFNFR: v1.1.0-beta2", -708, 340, 833, "left", nil, 1, 1)
			love.graphics.pop()
		love.graphics.pop()
	end,

	leave = function(self)

		Timer.clear()
	end
}
