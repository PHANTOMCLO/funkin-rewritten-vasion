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

--[[


I AM SO SORRY MODDERS FOR MY SHIT CODE

:(

I made this code at like 1am lmfao

]]

--[[

	THIS WEEKS FILE USES FNFR's ORIGINAL WAY OF HANDELING PIXEL WEEKS

]]--

local canvas, font

local song, difficulty

local sky, school, street, treesBack

local petals, trees, freaks

return {
	enter = function(self, from, songNum, songAppend)
		love.graphics.setDefaultFilter("nearest")

		status.setNoResize(true)

		canvas = love.graphics.newCanvas(256, 144)
		font = love.graphics.newFont("fonts/pixel_small.fnt")

		weeksPixel:enter()

		song = songNum
		difficulty = songAppend

		if storyMode then
			doingDialogue = true
			dialogueBox = love.filesystem.load("sprites/week6/dialogueBox.lua")()
			senpaiPortrait = love.filesystem.load("sprites/week6/senpaiPortrait.lua")()
			bfPortrait = love.filesystem.load("sprites/week6/bfPortrait.lua")()

			dialogueBox:animate("anim", false)
			bfPortrait:animate("anim", false)
			senpaiPortrait:animate("anim", false)

			dialogueBox.x, dialogueBox.y = 125, 90
			bfPortrait.x, bfPortrait.y = 125, 90
			senpaiPortrait.x, senpaiPortrait.y = 125, 90
			if song ~= 3 then
				dialogueMusic = love.audio.newSource("music/pixel/Lunchbox.ogg", "static")
				dialogueMusic:setLooping(true)

				dialogueMusic:play()
			else
				dialogueMusic = love.audio.newSource("music/pixel/LunchboxScary.ogg", "static")
				dialogueMusic:setLooping(true)
				dialogueMusic:play()
			end
		end

		cam.sizeX, cam.sizeY = 1, 1
		camScale.x, camScale.y = 1, 1

		function setDialogue(strList)
			dialogueList = strList
			curDialogue = 1
			timer = 0
			progress = 1
			output = ""
			isDone = false
		end
		
		function doDialogue(dt)
			local fullDialogue = dialogueList[curDialogue]
			
			timer = timer + dt
			
			if timer >= 0.05 then
				if progress < string.len(fullDialogue) then
					sounds["text"]:play()

					progress = progress + 1

					output = string.sub(fullDialogue, 1, math.floor(progress))

					timer = 0
				else
					timer = 0
				end
			end
		end

		function advanceDialogue()
			local fullDialogue = dialogueList[curDialogue]

			if progress < string.len(fullDialogue) then
				progress = string.len(fullDialogue)
				output = string.sub(fullDialogue, 1, math.floor(progress))
			else
				if curDialogue < #dialogueList then
					sounds["continue"]:play()
					
					curDialogue = curDialogue + 1
					timer = 0
					progress = 1
					output = ""
				else
					sounds["continue"]:play()

					isDone = true
				end
			end
		end

		if song ~= 3 then
			sky = graphics.newImage(love.graphics.newImage(graphics.imagePath("week6/sky")))
			school = graphics.newImage(love.graphics.newImage(graphics.imagePath("week6/school")))
			street = graphics.newImage(love.graphics.newImage(graphics.imagePath("week6/street")))
			treesBack = graphics.newImage(love.graphics.newImage(graphics.imagePath("week6/trees-back")))

			trees = love.filesystem.load("sprites/week6/trees.lua")()
			petals = love.filesystem.load("sprites/week6/petals.lua")()
			freaks = love.filesystem.load("sprites/week6/freaks.lua")()

			sky.y = 1
			school.y = 1

			healthBarColorEnemy = {255,170,111}
		end

		boyfriend.x, boyfriend.y = 50, 30
		fakeBoyfriend.x, fakeBoyfriend.y = 50, 30

		enemyIcon:animate("senpai", false)

		self:load()
	end,

	load = function(self)
		if storyMode then
			doingDialogue = true
		else
			doingDialogue = false
		end
		if song == 3 then
			school = love.filesystem.load("sprites/week6/evil-school.lua")()
			enemy = love.filesystem.load("sprites/week6/spirit.lua")()

			scaryDialogueBox = love.filesystem.load("sprites/week6/scaryDialogueBox.lua")()
			spiritPortait = graphics.newImage(love.graphics.newImage(graphics.imagePath("week6/spiritFaceForward")))
			spiritPortait.x, spiritPortait.y = 70, 50
			scaryDialogueBox.x, scaryDialogueBox.y = 125, 90
			if storyMode then
				dialogueMusic = love.audio.newSource("music/pixel/lunchboxScary.ogg", "static")
				dialogueMusic:setLooping(true)
				dialogueMusic:play()
			end

			setDialogue(
				{
					"Direct contact with real humans, after being trapped in here for so long...",
					"and HER of all people.",
					"I'll make her father pay for what he's done to me and all the others,,,,",
					"I'll beat you and make you take my place.",
					"You don't mind your bodies being borrowed right? It's only fair..."
				}
			)
			enemyIcon:animate("spirit", false)

			healthBarColorEnemy = {255,60,110}
		elseif song == 2 then
			enemy = love.filesystem.load("sprites/week6/senpai-angry.lua")()

			angrySenpaiBox = love.filesystem.load("sprites/week6/angrySenpaiBox.lua")()
			angrySenpaiBox.x, angrySenpaiBox.y = 125, 90

			setDialogue(
				{
					"Not bad for an ugly worm.",
					"But this time I'll rip your nuts off right after your girlfriend finishes gargling mine.",
					"Bop beep be be skdoo bep"
				}
			)
			if storyMode then
				angry_text_box = love.audio.newSource("sounds/pixel/ANGRY_TEXT_BOX.ogg", "static")
				angry_text_box:play()
			end

			freaks:animate("dissuaded", true)
		else
			enemy = love.filesystem.load("sprites/week6/senpai.lua")()
			setDialogue(
				{
					"Ah, a new fair maiden has come in search of true love!",
					"A serenade between gentlemen shall decide where her beautiful heart shall reside.",
					"Beep bo bop"
				}
			)
		end

		weeksPixel:load()

		if song == 3 then
			inst = love.audio.newSource("music/week6/thorns-inst.ogg", "stream")
			voices = love.audio.newSource("music/week6/thorns-voices.ogg", "stream")
		elseif song == 2 then
			inst = love.audio.newSource("music/week6/roses-inst.ogg", "stream")
			voices = love.audio.newSource("music/week6/roses-voices.ogg", "stream")
		else
			inst = love.audio.newSource("music/week6/senpai-inst.ogg", "stream")
			voices = love.audio.newSource("music/week6/senpai-voices.ogg", "stream")
		end
		enemy.x, enemy.y = -50, 0

		if storyMode then
			dialogueMusic:play()
		end
		self:initUI()
		if not storyMode then
			weeksPixel:setupCountdown()
		end
	end,

	initUI = function(self)
		weeksPixel:initUI()

		if song == 3 then
			weeksPixel:generateNotes(love.filesystem.load("charts/week6/thorns" .. difficulty .. ".lua")())
		elseif song == 2 then
			weeksPixel:generateNotes(love.filesystem.load("charts/week6/roses" .. difficulty .. ".lua")())
		else
			weeksPixel:generateNotes(love.filesystem.load("charts/week6/senpai" .. difficulty .. ".lua")())
		end
	end,

	update = function(self, dt)
		graphics.screenBase(256, 144)

		weeksPixel:update(dt)

		if song == 3 then
			school:update(dt)
		else
			trees:update(dt)
			petals:update(dt)
			freaks:update(dt)
		end

		if doingDialogue then
			doDialogue(dt)
			if song == 1 then
				senpaiPortrait:update(dt)
			elseif song == 2 then
				angrySenpaiBox:update(dt)
			elseif song == 3 then
				scaryDialogueBox:update(dt)
			end
			bfPortrait:update(dt)
			dialogueBox:update(dt)
			if input:pressed("confirm") then
				if not isDone then
					advanceDialogue()
				end
			end
			if isDone then
				dialogueMusic:stop()
				doingDialogue = false
				weeksPixel:setupCountdown()
			end
		end

		if not doingDialogue and not (countingDown or graphics.isFading()) and not (inst:isPlaying() and voices:isPlaying()) then
			if storyMode and song < 3 then
				song = song + 1

				self:load()
			else
				status.setLoading(true)

				graphics.fadeOut(
					0.5,
					function()
						Gamestate.switch(menu)

						status.setLoading(false)
					end
				)
			end
		end

		weeksPixel:updateUI(dt, canvas)
	end,

	draw = function(self)
		local canvasScale

		love.graphics.setFont(font)
		graphics.screenBase(256, 144)
		love.graphics.setCanvas(canvas)
			love.graphics.clear()

			love.graphics.push()
				love.graphics.translate(128, 72)
				love.graphics.scale(cam.sizeX, cam.sizeY)

				love.graphics.push()
					love.graphics.translate(math.floor(cam.x * 0.9), math.floor(cam.y * 0.9))

					if song ~= 3 then
						sky:draw()
					end

					school:draw()
				love.graphics.pop()
				love.graphics.push()
					love.graphics.translate(math.floor(cam.x), math.floor(cam.y))

					if song ~= 3 then
						street:draw()
						treesBack:draw()

						trees:draw()
						petals:draw()
						freaks:draw()
					end

					girlfriend:draw()
					enemy:draw()
					boyfriend:draw()
				love.graphics.pop()
				weeksPixel:drawRating()
			love.graphics.pop()

			if not doingDialogue then
				weeksPixel:drawUI()
			end
			if doingDialogue then -- Doing this cuz i'm stupid as shit
				if song == 1 then
					dialogueBox:draw()
					if curDialogue ~= 3 then
						senpaiPortrait:draw()
					else
						bfPortrait:draw()
					end
				elseif song == 2 then
					if curDialogue ~= 3 then
						angrySenpaiBox:draw()
					else
						dialogueBox:draw()
						bfPortrait:draw()
					end
				elseif song == 3 then
					scaryDialogueBox:draw()
					spiritPortait:draw()
				end
				love.graphics.printf(output, 35, 95, 182, "left")
			end
		love.graphics.setCanvas()
		graphics.screenBase(love.graphics.getWidth(), love.graphics.getHeight())

		canvasScale = math.min(math.floor(graphics.getWidth() / 256), math.floor(graphics.getHeight() / 144))
		if canvasScale < 1 then canvasScale = math.min(graphics.getWidth() / 256, graphics.getHeight() / 144) end

		love.graphics.draw(canvas, graphics.getWidth() / 2, graphics.getHeight() / 2, nil, canvasScale, canvasScale, 128, 72)
	end,

	leave = function(self)
		canvas = nil
		font = nil

		sky = nil
		school = nil
		street = nil

		weeksPixel:leave()

		status.setNoResize(false)

		love.graphics.setDefaultFilter("linear")
	end
}
