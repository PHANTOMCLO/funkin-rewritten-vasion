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

local upFunc, downFunc, confirmFunc, backFunc, drawFunc, menuFunc, menuDesc, trackNames

local menuState

local menuNum = 1

local weekNum = 1
local songNum, songAppend
local songDifficulty = 2

local titleBG = graphics.newImage(love.graphics.newImage(graphics.imagePath("menu/storymenu/weekMenu")))

local enemyDanceLines = love.filesystem.load("sprites/menu/storymenu/idlelines.lua")()

local tanklines = love.filesystem.load("sprites/menu/storymenu/tankmenu.lua")()

local difficultyAnim = love.filesystem.load("sprites/menu/storymenu/difficulty.lua")()

local bfDanceLines = love.filesystem.load("sprites/menu/storymenu/idlelines.lua")()

local gfDanceLines = love.filesystem.load("sprites/menu/storymenu/idlelines.lua")()

local tutorial, week1, week2, week3, week4, week5, week6, week7

local weekDesc = { -- Add your week description here
	"LEARN TO FUNK",
	"DADDY DEAREST",
	"SPOOKY MONTH",
	"PICO",
	"MOMMY MUST MURDER",
	"RED SNOW",
	"HATING SIMULATOR FT. MOAWLING",
	"TANKMAN"
}
local difficultyStrs = { 
	"-easy",
	"",
	"-hard"
}

trackNames = { -- add your songs here
	{
		"\nTutorial"
	},
	{
		"\nBopeebo",
		"\nFresh",
		"\nDad-Battle"
	},
	{
		"\nSpookeez",
		"\nSouth",
		"\nMonster"
	},
	{
		"\nPico",
		"\nPhilly",
		"\nBlammed"
	},
	{
		"\nSatin-Panties",
		"\nHigh",
		"\nM.I.L.F"
	},
	{
		"\nCocoa",
		"\nEggnog",
		"\nWinter-Horrorland"
	},
	{
		"\nSenpai",
		"\nRoses",
		"\nThorns"
	},
	{
		"\nUgh",
		"\nGuns",
		"\nStress"
	}
}

-- Week Images
-- Just add a new images here
tutorial = graphics.newImage(love.graphics.newImage(graphics.imagePath("menu/storymenu/week0")))
week1 = graphics.newImage(love.graphics.newImage(graphics.imagePath("menu/storymenu/week1")))
week2 = graphics.newImage(love.graphics.newImage(graphics.imagePath("menu/storymenu/week2")))
week3 = graphics.newImage(love.graphics.newImage(graphics.imagePath("menu/storymenu/week3")))
week4 = graphics.newImage(love.graphics.newImage(graphics.imagePath("menu/storymenu/week4")))
week5 = graphics.newImage(love.graphics.newImage(graphics.imagePath("menu/storymenu/week5")))
week6 = graphics.newImage(love.graphics.newImage(graphics.imagePath("menu/storymenu/week6")))
week7 = graphics.newImage(love.graphics.newImage(graphics.imagePath("menu/storymenu/week7")))

enemyDanceLines.sizeX, enemyDanceLines.sizeY = 0.5, 0.5

local selectSound = love.audio.newSource("sounds/menu/select.ogg", "static")
local confirmSound = love.audio.newSource("sounds/menu/confirm.ogg", "static")

local function switchMenu(menu)

end

enemyDanceLines.x, enemyDanceLines.y = -375, -170
tanklines.x, tanklines.y = -375, -170

bfDanceLines.sizeX, bfDanceLines.sizeY = 0.7, 0.7
gfDanceLines.sizeX, gfDanceLines.sizeY = 0.5, 0.5

bfDanceLines.x, bfDanceLines.y = 0, -150
gfDanceLines.x, gfDanceLines.y = 375, -170

difficultyAnim.x, difficultyAnim.y = 400, 220

return {
	enter = function(self, previous)
        bfDanceLines:animate("boyfriend", true)
		gfDanceLines:animate("girlfriend", true)
		enemyDanceLines:animate("week1", true)
		tanklines:animate("anim", true)
		songNum = 0
		weekNum = 1	

		cam.sizeX, cam.sizeY = 0.9, 0.9
		camScale.x, camScale.y = 0.9, 0.9

		if useDiscordRPC then -- Set a custom RPC here
			presence = {
				state = "Choosing A Week",
				details = "In the Week Select Menu",
				largeImageKey = "logo",
				startTimestamp = now,
			}
			nextPresenceUpdate = 0
		end

		weekImages = { -- Images are preloaded
			tutorial,
			week1,
			week2,
			week3,
			week4,
			week5,
			week6,
			week7
		}

		if weekNum ~= 1 then
			weekBefore = weekImages[weekNum - 1]
			weekBefore.y = 130
		end
		weekImages[weekNum].y = 220
		if weekNum ~= 8 then
			weekAfter = weekImages[weekNum + 1]
			weekAfter.y = 320
		end

		switchMenu(1)

		graphics.setFade(0)
		graphics.fadeIn(0.5)

		function confirmFunc()
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

					if weekNum == 6 then
						week5Playing = true
					else
						week5Playing = false
					end
					if weekNum == 5 then
						doingWeek4 = true
					else
						doingWeek4 = false
					end
					
					songAppend = difficultyStrs[songDifficulty]

					storyMode = true

					Gamestate.switch(weekData[weekNum], songNum, songAppend)

					status.setLoading(false)
				end
			)
		end
		
	end,

	update = function(self, dt)


		function menuFunc()
			if weekNum ~= 7 then -- Due to senpais idlelines being smaller than the rest, we resize it
				enemyDanceLines.sizeX, enemyDanceLines.sizeY = 0.5, 0.5
			elseif weekNum == 7 then
				enemyDanceLines.sizeX, enemyDanceLines.sizeY = 1, 1
			end

			weekBefore = weekImages[weekNum - 1]
			weekAfter = weekImages[weekNum + 1]

			if weekNum ~= 1 then
				weekBefore.y = 130
			end
			weekImages[weekNum].y = 220
			if weekNum ~= 8 then
				weekAfter.y = 320
			end

			enemyDanceLines:animate("week" .. weekNum, true)
			tanklines:animate("anim", true)
		end
		
		enemyDanceLines:update(dt)
		tanklines:update(dt)
		bfDanceLines:update(dt)
		gfDanceLines:update(dt)

		if songDifficulty == 1 then
			difficultyAnim:animate("easy", true)
		elseif songDifficulty == 2 then
			difficultyAnim:animate("normal", true)
		elseif songDifficulty == 3 then
			difficultyAnim:animate("hard", true)
		end

		difficultyAnim:update(dt)

		if not graphics.isFading() then
			if input:pressed("down") then
				audio.playSound(selectSound)

				if weekNum ~= 8 then -- change 7 to the ammount of weeks there is (tutorial-6)
					weekNum = weekNum + 1
				else
					weekNum = 1
				end
				menuFunc()

			elseif input:pressed("up") then
				audio.playSound(selectSound)

				if weekNum ~= 1 then
					weekNum = weekNum - 1
				else
					weekNum = 8
				end
				menuFunc()

			elseif input:pressed("left") then
				audio.playSound(selectSound)

				if songDifficulty ~= 1 then
					songDifficulty = songDifficulty - 1
				else
					songDifficulty = 3 
				end

			elseif input:pressed("right") then
				audio.playSound(selectSound)

				if songDifficulty ~= 3 then
					songDifficulty = songDifficulty + 1
				else
					songDifficulty = 1
				end

			elseif input:pressed("confirm") then
				audio.playSound(confirmSound)
                bfDanceLines:animate("boyfriend confirm", false)

				confirmFunc()
			elseif input:pressed("back") then
				audio.playSound(selectSound)

				Gamestate.switch(menuSelect)
			end
		end
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)

			titleBG:draw()

			love.graphics.push()
				love.graphics.scale(cam.sizeX, cam.sizeY)

				difficultyAnim:draw()
				if weekNum ~= 1 then
					enemyDanceLines:draw()
				end
				if weekNum == 8 then
					tanklines:draw()
				end
				bfDanceLines:draw()
				gfDanceLines:draw()
				if weekNum ~= 1 then
					weekBefore:draw()
				end
				weekImages[weekNum]:draw()
				if weekNum ~= 8 then
					weekAfter:draw()
				end

				love.graphics.printf(weekDesc[weekNum], -585, -395, 853, "right", nil, 1.5, 1.5)
				graphics.setColor(255 / 255, 117 / 255, 172 / 255)
				if weekNum ~= 1 then
					love.graphics.printf("TRACKS" .. trackNames[weekNum][1] .. trackNames[weekNum][2] .. trackNames[weekNum][3], -1050, 140, 853, "center", nil, 1.5, 1.5)
				else
					love.graphics.printf("TRACKS" .. trackNames[weekNum][1], -1050, 140, 853, "center", nil, 1.5, 1.5)
				end
				graphics.setColor(1,1,1)

			love.graphics.pop()
		love.graphics.pop()
	end,

	leave = function(self)

		Timer.clear()
	end
}
