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

local animList = {
	"left",
	"down",
	"up",
	"right"
}
local inputList = {
	"gameLeft",
	"gameDown",
	"gameUp",
	"gameRight"
}

local missCounter = 0
local noteCounter = 0
local altScore = 0

local ratingTimers = {}

local useAltAnims
local notMissed = {}

return {
	enter = function(self)
		sounds = {
			countdown = {
				three = love.audio.newSource("sounds/countdown-3.ogg", "static"),
				two = love.audio.newSource("sounds/countdown-2.ogg", "static"),
				one = love.audio.newSource("sounds/countdown-1.ogg", "static"),
				go = love.audio.newSource("sounds/countdown-go.ogg", "static")
			},
			miss = {
				love.audio.newSource("sounds/miss1.ogg", "static"),
				love.audio.newSource("sounds/miss2.ogg", "static"),
				love.audio.newSource("sounds/miss3.ogg", "static")
			},
			death = love.audio.newSource("sounds/death.ogg", "static")
		}

		images = {
			icons = love.graphics.newImage(graphics.imagePath("icons")),
			notes = love.graphics.newImage(graphics.imagePath("notes")),
			notesplashes = love.graphics.newImage(graphics.imagePath("noteSplashes")),
			numbers = love.graphics.newImage(graphics.imagePath("numbers"))
		}

		sprites = {
			icons = love.filesystem.load("sprites/icons.lua"),
			numbers = love.filesystem.load("sprites/numbers.lua")
		}

		girlfriend = love.filesystem.load("sprites/girlfriend.lua")()
		boyfriend = love.filesystem.load("sprites/boyfriend.lua")()


		rating = love.filesystem.load("sprites/rating.lua")()

		rating.sizeX, rating.sizeY = 0.75, 0.75
		numbers = {}
		for i = 1, 3 do
			numbers[i] = sprites.numbers()

			numbers[i].sizeX, numbers[i].sizeY = 0.5, 0.5
		end

		enemyIcon = sprites.icons()
		boyfriendIcon = sprites.icons()

		if settings.downscroll then
			enemyIcon.y = -400
			boyfriendIcon.y = -400
		else
			enemyIcon.y = 350
			boyfriendIcon.y = 350
		end
		enemyIcon.sizeX, enemyIcon.sizeY = 1.5, 1.5
		boyfriendIcon.sizeX, boyfriendIcon.sizeY = -1.5, 1.5
		healthBarColorPlayer = {102,204,51}
		

		countdownFade = {}
		countdown = love.filesystem.load("sprites/countdown.lua")()

		
	end,

	week6Upscale = function()
		enemy.sizeX, enemy.sizeY = 7, 7
		boyfriend.sizeX, boyfriend.sizeY = 7, 7
		girlfriend.sizeX, girlfriend.sizeY = 7, 7
		countdown.sizeX, countdown.sizeY = 7, 7
		rating.sizeX, rating.sizeY = 7, 7
		for i = 1, 3 do
			numbers[i].sizeX, numbers[i].sizeY = 6.5, 6.5
		end
	end,

	week6Downscale = function()
		enemy.sizeX, enemy.sizeY = 1, 1
		boyfriend.sizeX, boyfriend.sizeY = 1, 1
		girlfriend.sizeX, girlfriend.sizeY = 1, 1
		countdown.sizeX, countdown.sizeY = 1, 1
		rating.sizeX, rating.sizeY = 1, 1
		for i = 1, 3 do
			numbers[i].sizeX, numbers[i].sizeY = 0.5, 0.5
		end
	end,

	load = function(self)
		missCounter = 0
		noteCounter = 0
		altScore = 0
		doingAnim = false -- for week 4 stuff
		hitSick = false
		
		for i = 1, 4 do
			notMissed[i] = true
		end
		useAltAnims = false

		cam.x, cam.y = -boyfriend.x + 300, -boyfriend.y + 75

		rating.x = girlfriend.x
		if not pixel then
			for i = 1, 3 do
				numbers[i].x = girlfriend.x - 100 + 50 * i
			end
		else
			for i = 1, 3 do
				numbers[i].x = girlfriend.x - 100 + 58 * i
			end
		end

		ratingVisibility = {0}
		combo = 0

		enemy:animate("idle")
		boyfriend:animate("idle")

		graphics.fadeIn(0.5)
	end,

	pixelInitUI = function(self)
		events = {}
		enemyNotes = {}
		boyfriendNotes = {}
		health = 50
		score = 0
		missCounter = 0
		altScore = 0
		sicks = 0
		goods = 0
		bads = 0
		shits = 0

		local curInput = inputList[i]

		sprites.leftArrow = love.filesystem.load("sprites/pixel/notes/left-arrow.lua")
		sprites.downArrow = love.filesystem.load("sprites/pixel/notes/down-arrow.lua")
		sprites.upArrow = love.filesystem.load("sprites/pixel/notes/up-arrow.lua")
		sprites.rightArrow = love.filesystem.load("sprites/pixel/notes/right-arrow.lua")

		leftArrowSplash = love.filesystem.load("sprites/pixel/notes/pixelSplashes.lua")()
		downArrowSplash = love.filesystem.load("sprites/pixel/notes/pixelSplashes.lua")()
		upArrowSplash = love.filesystem.load("sprites/pixel/notes/pixelSplashes.lua")()
		rightArrowSplash = love.filesystem.load("sprites/pixel/notes/pixelSplashes.lua")()

		enemyArrows = {
			sprites.leftArrow(),
			sprites.downArrow(),
			sprites.upArrow(),
			sprites.rightArrow()
		}
		boyfriendArrows = {
			sprites.leftArrow(),
			sprites.downArrow(),
			sprites.upArrow(),
			sprites.rightArrow()
		}

		leftArrowSplash.sizeX, leftArrowSplash.sizeY = 7, 7
		rightArrowSplash.sizeX, rightArrowSplash.sizeY = 7, 7
		upArrowSplash.sizeX, upArrowSplash.sizeY = 7, 7
		downArrowSplash.sizeX, downArrowSplash.sizeY = 7, 7

		for i = 1, 4 do
			enemyArrows[i].x = -925 + 165 * i 
			boyfriendArrows[i].x = 100 + 165 * i 
			leftArrowSplash.x = 100 + 165 * 1 - 15
			downArrowSplash.x = 100 + 165 * 2 - 15
			upArrowSplash.x =  100 + 165 * 3 - 15
			rightArrowSplash.x = 100 + 165 * 4 - 15
			if settings.downscroll then
				enemyArrows[i].y = 400
				boyfriendArrows[i].y = 400
				leftArrowSplash.y = 400
				downArrowSplash.y = 400
				upArrowSplash.y = 400
				rightArrowSplash.y = 400
			else
				enemyArrows[i].y = -400
				boyfriendArrows[i].y = -400
				leftArrowSplash.y = -400
				downArrowSplash.y = -400
				upArrowSplash.y = -400
				rightArrowSplash.y = -400
			end

			enemyArrows[i].sizeX, enemyArrows[i].sizeY = 7, 7
			boyfriendArrows[i].sizeX, boyfriendArrows[i].sizeY = 7, 7

			enemyNotes[i] = {}
			boyfriendNotes[i] = {}
		end
	end,

	initUI = function(self)
		events = {}
		enemyNotes = {}
		boyfriendNotes = {}
		health = 50
		score = 0
		missCounter = 0
		altScore = 0
		sicks = 0
		goods = 0
		bads = 0
		shits = 0

		local curInput = inputList[i]

		sprites.leftArrow = love.filesystem.load("sprites/notes/left-arrow.lua")
		sprites.downArrow = love.filesystem.load("sprites/notes/down-arrow.lua")
		sprites.upArrow = love.filesystem.load("sprites/notes/up-arrow.lua")
		sprites.rightArrow = love.filesystem.load("sprites/notes/right-arrow.lua")

		leftArrowSplash = love.filesystem.load("sprites/notes/noteSplashes.lua")()
		downArrowSplash = love.filesystem.load("sprites/notes/noteSplashes.lua")()
		upArrowSplash = love.filesystem.load("sprites/notes/noteSplashes.lua")()
		rightArrowSplash = love.filesystem.load("sprites/notes/noteSplashes.lua")()

		enemyArrows = {
			sprites.leftArrow(),
			sprites.downArrow(),
			sprites.upArrow(),
			sprites.rightArrow()
		}
		boyfriendArrows = {
			sprites.leftArrow(),
			sprites.downArrow(),
			sprites.upArrow(),
			sprites.rightArrow()
		}

		for i = 1, 4 do
			enemyArrows[i].x = -925 + 165 * i 
			boyfriendArrows[i].x = 100 + 165 * i 
			leftArrowSplash.x = 100 + 165 * 1 - 15
			downArrowSplash.x = 100 + 165 * 2 - 15
			upArrowSplash.x =  100 + 165 * 3 - 15
			rightArrowSplash.x = 100 + 165 * 4 - 15
			if settings.downscroll then
				enemyArrows[i].y = 400
				boyfriendArrows[i].y = 400
				leftArrowSplash.y = 400
				downArrowSplash.y = 400
				upArrowSplash.y = 400
				rightArrowSplash.y = 400
			else
				enemyArrows[i].y = -400
				boyfriendArrows[i].y = -400
				leftArrowSplash.y = -400
				downArrowSplash.y = -400
				upArrowSplash.y = -400
				rightArrowSplash.y = -400
			end

			enemyNotes[i] = {}
			boyfriendNotes[i] = {}
		end
	end,

	generateNotes = function(self, chart)
		local eventBpm

		for i = 1, #chart do
			bpm = chart[i].bpm

			if bpm then
				break
			end
		end
		if not bpm then
			bpm = 100
		end

		speed = chart.speed

		for i = 1, #chart do
			eventBpm = chart[i].bpm

			for j = 1, #chart[i].sectionNotes do
				local sprite

				local mustHitSection = chart[i].mustHitSection
				local altAnim = chart[i].altAnim
				local noteType = chart[i].sectionNotes[j].noteType
				local noteTime = chart[i].sectionNotes[j].noteTime

				if j == 1 then
					table.insert(events, {eventTime = chart[i].sectionNotes[1].noteTime, mustHitSection = mustHitSection, bpm = eventBpm, altAnim = altAnim})
				end

				if noteType == 0 or noteType == 4 then
					sprite = sprites.leftArrow
				elseif noteType == 1 or noteType == 5 then
					sprite = sprites.downArrow
				elseif noteType == 2 or noteType == 6 then
					sprite = sprites.upArrow
				elseif noteType == 3 or noteType == 7 then
					sprite = sprites.rightArrow
				end

				if settings.downscroll then
					if mustHitSection then
						if noteType >= 4 then
							local id = noteType - 3
							local c = #enemyNotes[id] + 1
							local x = enemyArrows[id].x

							table.insert(enemyNotes[id], sprite())
							enemyNotes[id][c].x = x
							enemyNotes[id][c].y = 400 - noteTime * 0.6 * speed

							enemyNotes[id][c]:animate("on", false)

							if chart[i].sectionNotes[j].noteLength > 0 then
								local c

								for k = 71 / speed, chart[i].sectionNotes[j].noteLength, 71 / speed do
									local c = #enemyNotes[id] + 1

									table.insert(enemyNotes[id], sprite())
									enemyNotes[id][c].x = x
									enemyNotes[id][c].y = 400 - (noteTime + k) * 0.6 * speed

									enemyNotes[id][c]:animate("hold", false)
								end

								c = #enemyNotes[id]
								if pixel then
									enemyNotes[id][c].offsetY = -1
								else
									enemyNotes[id][c].offsetY = -10
								end
								enemyNotes[id][c].sizeY = -1

								enemyNotes[id][c]:animate("end", false)
							end
						else
							local id = noteType + 1
							local c = #boyfriendNotes[id] + 1
							local x = boyfriendArrows[id].x

							table.insert(boyfriendNotes[id], sprite())
							boyfriendNotes[id][c].x = x
							boyfriendNotes[id][c].y = 400 - noteTime * 0.6 * speed

							boyfriendNotes[id][c]:animate("on", false)

							if chart[i].sectionNotes[j].noteLength > 0 then
								local c

								for k = 71 / speed, chart[i].sectionNotes[j].noteLength, 71 / speed do
									local c = #boyfriendNotes[id] + 1

									table.insert(boyfriendNotes[id], sprite())
									boyfriendNotes[id][c].x = x
									boyfriendNotes[id][c].y = 400 - (noteTime + k) * 0.6 * speed

									boyfriendNotes[id][c]:animate("hold", false)
								end

								c = #boyfriendNotes[id]

								if pixel then
									boyfriendNotes[id][c].offsetY = -1
								else
									boyfriendNotes[id][c].offsetY = -10
								end
								boyfriendNotes[id][c].sizeY = -1

								boyfriendNotes[id][c]:animate("end", false)
							end
						end
					else
						if noteType >= 4 then
							local id = noteType - 3
							local c = #boyfriendNotes[id] + 1
							local x = boyfriendArrows[id].x

							table.insert(boyfriendNotes[id], sprite())
							boyfriendNotes[id][c].x = x
							boyfriendNotes[id][c].y = 400 - noteTime * 0.6 * speed

							boyfriendNotes[id][c]:animate("on", false)

							if chart[i].sectionNotes[j].noteLength > 0 then
								local c

								for k = 71 / speed, chart[i].sectionNotes[j].noteLength, 71 / speed do
									local c = #boyfriendNotes[id] + 1

									table.insert(boyfriendNotes[id], sprite())
									boyfriendNotes[id][c].x = x
									boyfriendNotes[id][c].y = 400 - (noteTime + k) * 0.6 * speed

									boyfriendNotes[id][c]:animate("hold", false)
								end

								c = #boyfriendNotes[id]

								if pixel then
									boyfriendNotes[id][c].offsetY = -1
								else
									boyfriendNotes[id][c].offsetY = -10
								end
								boyfriendNotes[id][c].sizeY = -1

								boyfriendNotes[id][c]:animate("end", false)
							end
						else
							local id = noteType + 1
							local c = #enemyNotes[id] + 1
							local x = enemyArrows[id].x

							table.insert(enemyNotes[id], sprite())
							enemyNotes[id][c].x = x
							enemyNotes[id][c].y = 400 - noteTime * 0.6 * speed

							enemyNotes[id][c]:animate("on", false)

							if chart[i].sectionNotes[j].noteLength > 0 then
								local c

								for k = 71 / speed, chart[i].sectionNotes[j].noteLength, 71 / speed do
									local c = #enemyNotes[id] + 1

									table.insert(enemyNotes[id], sprite())
									enemyNotes[id][c].x = x
									enemyNotes[id][c].y = 400 - (noteTime + k) * 0.6 * speed

									enemyNotes[id][c]:animate("hold", false)
								end

								c = #enemyNotes[id]

								if pixel then
									enemyNotes[id][c].offsetY = -1
								else
									enemyNotes[id][c].offsetY = -10
								end
								enemyNotes[id][c].sizeY = -1

								enemyNotes[id][c]:animate("end", false)
							end
						end
					end
				else
					if mustHitSection then
						if noteType >= 4 then
							local id = noteType - 3
							local c = #enemyNotes[id] + 1
							local x = enemyArrows[id].x

							table.insert(enemyNotes[id], sprite())
							enemyNotes[id][c].x = x
							enemyNotes[id][c].y = -400 + noteTime * 0.6 * speed

							enemyNotes[id][c]:animate("on", false)

							if chart[i].sectionNotes[j].noteLength > 0 then
								local c

								for k = 71 / speed, chart[i].sectionNotes[j].noteLength, 71 / speed do
									local c = #enemyNotes[id] + 1

									table.insert(enemyNotes[id], sprite())
									enemyNotes[id][c].x = x
									enemyNotes[id][c].y = -400 + (noteTime + k) * 0.6 * speed

									enemyNotes[id][c]:animate("hold", false)
								end

								c = #enemyNotes[id]

								if pixel then
									enemyNotes[id][c].offsetY = -1
								else
									enemyNotes[id][c].offsetY = -10
								end

								enemyNotes[id][c]:animate("end", false)
							end
						else
							local id = noteType + 1
							local c = #boyfriendNotes[id] + 1
							local x = boyfriendArrows[id].x

							table.insert(boyfriendNotes[id], sprite())
							boyfriendNotes[id][c].x = x
							boyfriendNotes[id][c].y = -400 + noteTime * 0.6 * speed

							boyfriendNotes[id][c]:animate("on", false)

							if chart[i].sectionNotes[j].noteLength > 0 then
								local c

								for k = 71 / speed, chart[i].sectionNotes[j].noteLength, 71 / speed do
									local c = #boyfriendNotes[id] + 1

									table.insert(boyfriendNotes[id], sprite())
									boyfriendNotes[id][c].x = x
									boyfriendNotes[id][c].y = -400 + (noteTime + k) * 0.6 * speed

									boyfriendNotes[id][c]:animate("hold", false)
								end

								c = #boyfriendNotes[id]

								if pixel then
									boyfriendNotes[id][c].offsetY = -1
								else
									boyfriendNotes[id][c].offsetY = -10
								end

								boyfriendNotes[id][c]:animate("end", false)
							end
						end
					else
						if noteType >= 4 then
							local id = noteType - 3
							local c = #boyfriendNotes[id] + 1
							local x = boyfriendArrows[id].x

							table.insert(boyfriendNotes[id], sprite())
							boyfriendNotes[id][c].x = x
							boyfriendNotes[id][c].y = -400 + noteTime * 0.6 * speed

							boyfriendNotes[id][c]:animate("on", false)

							if chart[i].sectionNotes[j].noteLength > 0 then
								local c

								for k = 71 / speed, chart[i].sectionNotes[j].noteLength, 71 / speed do
									local c = #boyfriendNotes[id] + 1

									table.insert(boyfriendNotes[id], sprite())
									boyfriendNotes[id][c].x = x
									boyfriendNotes[id][c].y = -400 + (noteTime + k) * 0.6 * speed

									boyfriendNotes[id][c]:animate("hold", false)
								end

								c = #boyfriendNotes[id]

								if pixel then
									boyfriendNotes[id][c].offsetY = -1
								else
									boyfriendNotes[id][c].offsetY = -10
								end

								boyfriendNotes[id][c]:animate("end", false)
							end
						else
							local id = noteType + 1
							local c = #enemyNotes[id] + 1
							local x = enemyArrows[id].x

							table.insert(enemyNotes[id], sprite())
							enemyNotes[id][c].x = x
							enemyNotes[id][c].y = -400 + noteTime * 0.6 * speed

							enemyNotes[id][c]:animate("on", false)

							if chart[i].sectionNotes[j].noteLength > 0 then
								local c

								for k = 71 / speed, chart[i].sectionNotes[j].noteLength, 71 / speed do
									local c = #enemyNotes[id] + 1

									table.insert(enemyNotes[id], sprite())
									enemyNotes[id][c].x = x
									enemyNotes[id][c].y = -400 + (noteTime + k) * 0.6 * speed
									if k > chart[i].sectionNotes[j].noteLength - 71 / speed then
										if pixel then
											enemyNotes[id][c].offsetY = -1
										else
											enemyNotes[id][c].offsetY = -10
										end

										enemyNotes[id][c]:animate("end", false)
									else
										enemyNotes[id][c]:animate("hold", false)
									end
								end

								c = #enemyNotes[id]

								if pixel then
									enemyNotes[id][c].offsetY = -1
								else
									enemyNotes[id][c].offsetY = -10
								end

								enemyNotes[id][c]:animate("end", false)
							end
						end
					end
				end
			end
		end

		if settings.downscroll then
			for i = 1, 4 do
				table.sort(enemyNotes[i], function(a, b) return a.y > b.y end)
				table.sort(boyfriendNotes[i], function(a, b) return a.y > b.y end)
			end
		else
			for i = 1, 4 do
				table.sort(enemyNotes[i], function(a, b) return a.y < b.y end)
				table.sort(boyfriendNotes[i], function(a, b) return a.y < b.y end)
			end
		end

		-- Workarounds for bad charts that have multiple notes around the same place
		for i = 1, 4 do
			local offset = 0

			for j = 2, #enemyNotes[i] do
				local index = j - offset

				if enemyNotes[i][index]:getAnimName() == "on" and enemyNotes[i][index - 1]:getAnimName() == "on" and ((not settings.downscroll and enemyNotes[i][index].y - enemyNotes[i][index - 1].y <= 10) or (settings.downscroll and enemyNotes[i][index].y - enemyNotes[i][index - 1].y >= -10)) then
					table.remove(enemyNotes[i], index)

					offset = offset + 1
				end
			end
		end
		for i = 1, 4 do
			local offset = 0

			for j = 2, #boyfriendNotes[i] do
				local index = j - offset

				if boyfriendNotes[i][index]:getAnimName() == "on" and boyfriendNotes[i][index - 1]:getAnimName() == "on" and ((not settings.downscroll and boyfriendNotes[i][index].y - boyfriendNotes[i][index - 1].y <= 10) or (settings.downscroll and boyfriendNotes[i][index].y - boyfriendNotes[i][index - 1].y >= -10)) then
					table.remove(boyfriendNotes[i], index)

					offset = offset + 1
				end
			end
		end
	end,

	-- Gross countdown script
	setupCountdown = function(self)
		lastReportedPlaytime = 0
		musicTime = (240 / bpm) * -1000

		musicThres = 0
		musicPos = 0

		countingDown = true
		countdownFade[1] = 0
		audio.playSound(sounds.countdown.three)
		Timer.after(
			(60 / bpm),
			function()
				countdown:animate("ready")
				countdownFade[1] = 1
				audio.playSound(sounds.countdown.two)
				Timer.tween(
					(60 / bpm),
					countdownFade,
					{0},
					"linear",
					function()
						countdown:animate("set")
						countdownFade[1] = 1
						audio.playSound(sounds.countdown.one)
						Timer.tween(
							(60 / bpm),
							countdownFade,
							{0},
							"linear",
							function()
								if not pixel then
									countdown:animate("go")
								else
									countdown:animate("date")
								end
								countdownFade[1] = 1
								audio.playSound(sounds.countdown.go)
								Timer.tween(
									(60 / bpm),
									countdownFade,
									{0},
									"linear",
									function()
										countingDown = false

										previousFrameTime = love.timer.getTime() * 1000
										musicTime = 0

										if inst then inst:play() end
										voices:play()
									end
								)
							end
						)
					end
				)
			end
		)
	end,

	safeAnimate = function(self, sprite, animName, loopAnim, timerID)
		sprite:animate(animName, loopAnim)

		spriteTimers[timerID] = 12
	end,

	update = function(self, dt)
		if not doingDialogue then
			oldMusicThres = musicThres
			if countingDown or love.system.getOS() == "Web" then -- Source:tell() can't be trusted on love.js!
				musicTime = musicTime + 1000 * dt
			else
				if not graphics.isFading() then
					local time = love.timer.getTime()
					local seconds = voices:tell("seconds")

					musicTime = musicTime + (time * 1000) - previousFrameTime
					previousFrameTime = time * 1000

					if lastReportedPlaytime ~= seconds * 1000 then
						lastReportedPlaytime = seconds * 1000
						musicTime = (musicTime + lastReportedPlaytime) / 2
					end
				end
			end
			
			absMusicTime = math.abs(musicTime)
			musicThres = math.floor(absMusicTime / 100) -- Since "musicTime" isn't precise, this is needed

			for i = 1, #events do
				if events[i].eventTime <= absMusicTime then
					local oldBpm = bpm

					if events[i].bpm then
						bpm = events[i].bpm
						if not bpm then bpm = oldBpm end
					end

					if camTimer then
						Timer.cancel(camTimer)
					end
					if events[i].mustHitSection then
						camTimer = Timer.tween(1.25, cam, {x = -boyfriend.x + 300, y = -boyfriend.y + 25}, "out-quad")
					else
						camTimer = Timer.tween(1.25, cam, {x = -enemy.x - 250, y = -enemy.y + 75}, "out-quad")
					end

					if events[i].altAnim then
						useAltAnims = true
					else
						useAltAnims = false
					end

					table.remove(events, i)

					break
				end
			end

			if musicThres ~= oldMusicThres and math.fmod(absMusicTime, 240000 / bpm) < 100 then
				if camScaleTimer then Timer.cancel(camScaleTimer) end

				camScaleTimer = Timer.tween((60 / bpm) / 16, cam, {sizeX = camScale.x * 1.05, sizeY = camScale.y * 1.05}, "out-quad", function() camScaleTimer = Timer.tween((60 / bpm), cam, {sizeX = camScale.x, sizeY = camScale.y}, "out-quad") end)
			end

			girlfriend:update(dt)
			enemy:update(dt)
			boyfriend:update(dt)
			leftArrowSplash:update(dt)
			rightArrowSplash:update(dt)
			upArrowSplash:update(dt)
			downArrowSplash:update(dt)

			if musicThres ~= oldMusicThres and math.fmod(absMusicTime, 120000 / bpm) < 100 then
				if spriteTimers[1] == 0 then
					girlfriend:animate("idle", false)
	
					girlfriend:setAnimSpeed(14.4 / (60 / bpm))
				end
				if spriteTimers[2] == 0 then
					if enemy:getAnimName() ~= "down alt" then
						self:safeAnimate(enemy, "idle", false, 2)
					end
				end
				if spriteTimers[3] == 0 then
					if boyfriend:getAnimName() ~= "wheelie" then
						if wheeliebiker:getAnimName() ~= "death" then
							self:safeAnimate(boyfriend, "idle", false, 3)
							self:safeAnimate(wheeliebiker, "idle", false, 3)
						end
					end
				end
			end

			for i = 1, 3 do
				local spriteTimer = spriteTimers[i]

				if spriteTimer > 0 then
					spriteTimers[i] = spriteTimer - 1
				end
			end
		end
	end,

	updateUI = function(self, dt)
		if not doingDialogue then
			if settings.downscroll then
				musicPos = -musicTime * 0.6 * speed
			else
				musicPos = musicTime * 0.6 * speed
			end

			for i = 1, 4 do
				local enemyArrow = enemyArrows[i]
				local boyfriendArrow = boyfriendArrows[i]
				local enemyNote = enemyNotes[i]
				local boyfriendNote = boyfriendNotes[i]
				local curAnim = animList[i]
				local curInput = inputList[i]

				local noteNum = i

				enemyArrow:update(dt)
				boyfriendArrow:update(dt)

				if not enemyArrow:isAnimated() then
					enemyArrow:animate("off", false)
				end
				if not boyfriendArrow:isAnimated() then
					boyfriendArrow:animate("off", false)
				end

				if #enemyNote > 0 then
					if (not settings.downscroll and enemyNote[1].y - musicPos <= -400) or (settings.downscroll and enemyNote[1].y - musicPos >= 400) then
						voices:setVolume(1)

						enemyArrow:animate("confirm", false)

						if enemyNote[1]:getAnimName() == "hold" or enemyNote[1]:getAnimName() == "end" then
							if useAltAnims then
								if (not enemy:isAnimated()) or enemy:getAnimName() == "idle" then self:safeAnimate(enemy, curAnim .. " alt", true, 2) end
							else
								if (not enemy:isAnimated()) or enemy:getAnimName() == "idle" then self:safeAnimate(enemy, curAnim, true, 2) end
							end
						else
							if useAltAnims then
								self:safeAnimate(enemy, curAnim .. " alt", false, 2)
							else
								self:safeAnimate(enemy, curAnim, false, 2)
							end
						end

						table.remove(enemyNote, 1)
					end
				end

				if #boyfriendNote > 0 then
					if not countingDown then
						if (not settings.downscroll and boyfriendNote[1].y - musicPos < -500) or (settings.downscroll and boyfriendNote[1].y - musicPos > 500) then
							if not settings.botPlay then
								if inst then voices:setVolume(0) end

								notMissed[noteNum] = false

								table.remove(boyfriendNote, 1)

								if not pixel or doingWeek4 then
									if combo >= 5 then self:safeAnimate(girlfriend, "sad", true, 1) end
								end

								hitSick = false

								combo = 0
								
								health = health - 2
								missCounter = missCounter + 1
							end
						end
					end
				end

				if not settings.botPlay then
					if input:down(curInput) then
						holdingInput = true
					else
						holdingInput = false
					end

					if input:pressed(curInput) then
						local success = false

						if settings.ghostTapping then
							success = true
							hitSick = false
						end

						boyfriendArrow:animate("press", false)

						if #boyfriendNote > 0 then
							for i = 1, #boyfriendNote do
								if boyfriendNote[i] and boyfriendNote[i]:getAnimName() == "on" then
									if (not settings.downscroll and boyfriendNote[i].y - musicPos <= -280) or (settings.downscroll and boyfriendNote[i].y - musicPos >= 280) then
										local notePos
										local ratingAnim

										notMissed[noteNum] = true

										if settings.downscroll then
											notePos = math.abs(400 - (boyfriendNote[i].y - musicPos))
										else
											notePos = math.abs(-400 - (boyfriendNote[i].y - musicPos))
										end

										voices:setVolume(1)

										if notePos <= 55 then -- "Sick"
											score = score + 350
											ratingAnim = "sick"
											altScore = altScore + 100.00
											sicks = sicks + 1
											hitSick = true
										elseif notePos <= 95 then -- "Good"
											score = score + 200
											ratingAnim = "good"
											altScore = altScore + 66.66
											goods = goods + 1
											hitSick = false
										elseif notePos <= 115 then -- "Bad"
											score = score + 100
											ratingAnim = "bad"
											altScore = altScore + 33.33
											bads = bads + 1
											hitSick = false
										else -- "Shit"
											if settings.ghostTapping then
												success = false
											else
												score = score + 50
											end
											altScore = altScore + 1.11
											ratingAnim = "shit"
											shits = shits + 1
											hitSick = false
										end

										combo = combo + 1

										rating:animate(ratingAnim, false)
										numbers[1]:animate(tostring(math.floor(combo / 100 % 10), false))
										numbers[2]:animate(tostring(math.floor(combo / 10 % 10), false))
										numbers[3]:animate(tostring(math.floor(combo % 10), false))

										for i = 1, 5 do
											if ratingTimers[i] then Timer.cancel(ratingTimers[i]) end
										end

										ratingVisibility[1] = 1
										rating.y = girlfriend.y - 50
										for i = 1, 3 do
											numbers[i].y = girlfriend.y + 50
										end

										ratingTimers[1] = Timer.tween(2, ratingVisibility, {0})
										ratingTimers[2] = Timer.tween(2, rating, {y = girlfriend.y - 100}, "out-elastic")
										ratingTimers[3] = Timer.tween(2, numbers[1], {y = girlfriend.y + love.math.random(-10, 10)}, "out-elastic")
										ratingTimers[4] = Timer.tween(2, numbers[2], {y = girlfriend.y + love.math.random(-10, 10)}, "out-elastic")
										ratingTimers[5] = Timer.tween(2, numbers[3], {y = girlfriend.y + love.math.random(-10, 10)}, "out-elastic")

										table.remove(boyfriendNote, i)

										if not settings.ghostTapping or success then
											boyfriendArrow:animate("confirm", false)

											self:safeAnimate(boyfriend, curAnim, false, 3)
											doingAnim = false

											health = health + 1
											noteCounter = noteCounter + 1

											success = true
										end
									else
										break
									end
								end
							end
						end

						if not success then
							if not countingDown then
								if not settings.botPlay then
									audio.playSound(sounds.miss[love.math.random(3)])

									notMissed[noteNum] = false

									if not pixel or doingWeek4 then
										if combo >= 5 then self:safeAnimate(girlfriend, "sad", true, 1) end
									end

									self:safeAnimate(boyfriend, "miss " .. curAnim, false, 3)

									hitSick = false

									score = score - 10
									combo = 0
									health = health - 2
									missCounter = missCounter + 1
								end
							end
						end
					end
				end

				if not settings.botPlay then
					if notMissed[noteNum] and #boyfriendNote > 0 and input:down(curInput) and ((not settings.downscroll and boyfriendNote[1].y - musicPos <= -400) or (settings.downscroll and boyfriendNote[1].y - musicPos >= 400)) and (boyfriendNote[1]:getAnimName() == "hold" or boyfriendNote[1]:getAnimName() == "end") then
						voices:setVolume(1)

						table.remove(boyfriendNote, 1)

						boyfriendArrow:animate("confirm", false)

						if (not boyfriend:isAnimated()) or boyfriend:getAnimName() == "idle" then self:safeAnimate(boyfriend, curAnim, true, 3) end

						health = health + 1
					end

					if input:released(curInput) then
						boyfriendArrow:animate("off", false)
					end
				else
					if #boyfriendNote > 0 and ((not settings.downscroll and boyfriendNote[1].y - musicPos <= -400) or (settings.downscroll and boyfriendNote[1].y - musicPos >= 400)) then
						voices:setVolume(1)

						boyfriendArrow:animate("confirm", false)

						if boyfriendNote[1]:getAnimName() == "hold" or boyfriendNote[1]:getAnimName() == "end" then
							if (not boyfriend:isAnimated()) or boyfriend:getAnimName() == "idle" then self:safeAnimate(boyfriend, curAnim, true, 2) end
						else
							self:safeAnimate(boyfriend, curAnim, false, 2)
						end

						table.remove(boyfriendNote, 1)
					end
				end
			end

			if health > 100 then
				health = 100
			elseif health > 20 and boyfriendIcon:getAnimName() == "boyfriend losing" then
				boyfriendIcon:animate("boyfriend", false)
			elseif health <= 0 then -- Game over
				Gamestate.push(gameOver)
			elseif health <= 20 and boyfriendIcon:getAnimName() == "boyfriend" then
				boyfriendIcon:animate("boyfriend losing", false)
			end

			enemyIcon.x = 425 - health * 10
			boyfriendIcon.x = 585 - health * 10

			if not countingDown then
				if musicThres ~= oldMusicThres and math.fmod(absMusicTime, 60000 / bpm) < 100 then
					if enemyIconTimer then Timer.cancel(enemyIconTimer) end
					if boyfriendIconTimer then Timer.cancel(boyfriendIconTimer) end

					enemyIconTimer = Timer.tween((60 / bpm) / 16, enemyIcon, {sizeX = 1.75, sizeY = 1.75}, "out-quad", function() enemyIconTimer = Timer.tween((60 / bpm), enemyIcon, {sizeX = 1.5, sizeY = 1.5}, "out-quad") end)
					boyfriendIconTimer = Timer.tween((60 / bpm) / 16, boyfriendIcon, {sizeX = -1.75, sizeY = 1.75}, "out-quad", function() boyfriendIconTimer = Timer.tween((60 / bpm), boyfriendIcon, {sizeX = -1.5, sizeY = 1.5}, "out-quad") end)
				end
			end

			if not countingDown and input:pressed("gameBack") then
				if inst then inst:stop() end
				voices:stop()

				storyMode = false
			end
		end
	end,

	drawRating = function(self, multiplier)
		love.graphics.push()
			if multiplier then
				love.graphics.translate(cam.x * multiplier, cam.y * multiplier)
			else
				love.graphics.translate(cam.x, cam.y)
			end

			graphics.setColor(1, 1, 1, ratingVisibility[1])
			rating:draw()
			for i = 1, 3 do
				numbers[i]:draw()
			end
			graphics.setColor(1, 1, 1)
		love.graphics.pop()
	end,

	drawUI = function(self)
		love.graphics.push()
			love.graphics.translate(lovesize.getWidth() / 2, lovesize.getHeight() / 2)
			love.graphics.scale(0.7, 0.7)

			for i = 1, 4 do
				if enemyArrows[i]:getAnimName() == "off" then
					graphics.setColor(0.6, 0.6, 0.6)
				end
				enemyArrows[i]:draw()
				graphics.setColor(1, 1, 1)
				boyfriendArrows[i]:draw()
				if hitSick then
					if not botPlay then
						if input:pressed("gameLeft") then
							leftArrowSplash:animate("left")
						elseif input:pressed("gameRight") then
							rightArrowSplash:animate("right")
						elseif input:pressed("gameUp") then
							upArrowSplash:animate("up")
						elseif input:pressed("gameDown") then
							downArrowSplash:animate("down")
						end
					else
						if boyfriendArrows[1]:getAnimName() == "confirm" then
							leftArrowSplash:animate("left")
						elseif boyfriendArrows[2]:getAnimName() == "confirm" then
							downArrowSplash:animate("down")
						elseif boyfriendArrows[3]:getAnimName() == "confirm" then
							upArrowSplash:animate("up")
						elseif boyfriendArrows[4]:getAnimName() == "confirm" then
							downArrowSplash:animate("down")
						end
					end
				end
				if leftArrowSplash:isAnimated() then
					leftArrowSplash:draw()
				elseif rightArrowSplash:isAnimated() then
					rightArrowSplash:draw()
				elseif upArrowSplash:isAnimated() then
					upArrowSplash:draw()
				elseif downArrowSplash:isAnimated() then
					downArrowSplash:draw()
				end
				

				love.graphics.push()
					love.graphics.translate(0, -musicPos)

					for j = #enemyNotes[i], 1, -1 do
						if (not settings.downscroll and enemyNotes[i][j].y - musicPos <= 560) or (settings.downscroll and enemyNotes[i][j].y - musicPos >= -560) then
							local animName = enemyNotes[i][j]:getAnimName()

							if animName == "hold" or animName == "end" then
								graphics.setColor(1, 1, 1, 0.5)
							end
							if pixel then
								enemyNotes[i][j].sizeX, enemyNotes[i][j].sizeY = 7, 7
							end
							enemyNotes[i][j]:draw()
							graphics.setColor(1, 1, 1)
						end
					end
					for j = #boyfriendNotes[i], 1, -1 do
						if (not settings.downscroll and boyfriendNotes[i][j].y - musicPos <= 560) or (settings.downscroll and boyfriendNotes[i][j].y - musicPos >= -560) then
							local animName = boyfriendNotes[i][j]:getAnimName()

							if settings.downscroll then
								if animName == "hold" or animName == "end" then
									graphics.setColor(1, 1, 1, math.min(0.5, (500 - (boyfriendNotes[i][j].y - musicPos)) / 150))
								else
									graphics.setColor(1, 1, 1, math.min(1, (500 - (boyfriendNotes[i][j].y - musicPos)) / 75))
								end
							else
								if animName == "hold" or animName == "end" then
									graphics.setColor(1, 1, 1, math.min(0.5, (500 + (boyfriendNotes[i][j].y - musicPos)) / 150))
								else
									graphics.setColor(1, 1, 1, math.min(1, (500 + (boyfriendNotes[i][j].y - musicPos)) / 75))
								end
							end
							if pixel then
								boyfriendNotes[i][j].sizeX, boyfriendNotes[i][j].sizeY = 7, 7
							end
							boyfriendNotes[i][j]:draw()
						end
					end
					graphics.setColor(1, 1, 1)
				love.graphics.pop()
			end
			graphics.setColor(1, 1, 1, countdownFade[1])
			countdown:draw()
			graphics.setColor(1, 1, 1)
		love.graphics.pop()
	end,
	drawHealthBar = function()
		love.graphics.push()
			if not week5Playing then
				love.graphics.translate(lovesize.getWidth() / 2, lovesize.getHeight() / 2)
				love.graphics.scale(0.7, 0.7)
			end
			if settings.downscroll then
				graphics.setColor(healthBarColorEnemy[1]/255, healthBarColorEnemy[2]/255, healthBarColorEnemy[3]/255)
				love.graphics.rectangle("fill", -500, -400, 1000, 25)
				graphics.setColor(healthBarColorPlayer[1]/255, healthBarColorPlayer[2]/255, healthBarColorPlayer[3]/255) -- add /255 after each one if you use 255 RGB values
				love.graphics.rectangle("fill", 500, -400, -health * 10, 25)
				graphics.setColor(0, 0, 0)
				love.graphics.setLineWidth(10)
				love.graphics.rectangle("line", -500, -400, 1000, 25)
				love.graphics.setLineWidth(1)
				graphics.setColor(1, 1, 1)
			else
				graphics.setColor(healthBarColorEnemy[1]/255, healthBarColorEnemy[2]/255, healthBarColorEnemy[3]/255)
				love.graphics.rectangle("fill", -500, 350, 1000, 25)
				graphics.setColor(healthBarColorPlayer[1]/255, healthBarColorPlayer[2]/255, healthBarColorPlayer[3]/255) -- add /255 after each one if you use 255 RGB values
				love.graphics.rectangle("fill", 500, 350, -health * 10, 25)
				graphics.setColor(0, 0, 0)
				love.graphics.setLineWidth(10)
				love.graphics.rectangle("line", -500, 350, 1000, 25)
				love.graphics.setLineWidth(1)
				graphics.setColor(1, 1, 1)
			end

			boyfriendIcon:draw()
			enemyIcon:draw()
			love.graphics.setColor(uiTextColour[1],uiTextColour[2],uiTextColour[3])
			accForRatingText = (altScore / (noteCounter + missCounter))
			if accForRatingText >= 100 then
				ratingText = "PERFECT!!!"
			elseif accForRatingText >= 90 then
				ratingText = "Great!"
			elseif accForRatingText >= 70 then
				ratingText = "Good!"
			elseif accForRatingText >= 69 then
				ratingText = "Nice!"
			elseif accForRatingText >= 60 then
				ratingText = "Okay"
			elseif accForRatingText >= 50 then
				ratingText = "Meh..."
			elseif accForRatingText >= 40 then
				ratingText = "Could be better..."
			elseif accForRatingText >= 30 then
				ratingText = "It's an issue of skill."
			elseif accForRatingText >= 20 then
				ratingText = "Bad."
			elseif accForRatingText >= 10 then
				ratingText = "How."
			elseif accForRatingText >= 0 then
				ratingText = "Bruh."
			end
			if not pixel then
				if not settings.botPlay then
					if settings.downscroll then
						local convertedAcc = string.format(
							"%.2f%%",
							(altScore / (noteCounter + missCounter))
						)
						if noteCounter + missCounter <= 0 then
							if (math.floor((altScore / (noteCounter + missCounter)) / 3.5)) >= 100 then
								love.graphics.printf("Score: " .. score .. " | Misses: " .. missCounter .. " | Accuracy: 0% | ???", -385, -350, 800, "center")
							else
								love.graphics.printf("Score: " .. score .. " | Misses: " .. missCounter .. " | Accuracy: 0% | ???", -385, -350, 800, "center")
							end
						else
							if (math.floor((altScore / (noteCounter + missCounter)) / 3.5)) >= 100 then
								love.graphics.printf("Score: " .. score .. " | Misses: " .. missCounter .. " | Accuracy: 100% | PERFECT!!!", -385, -350, 800, "center")
							else
								love.graphics.printf("Score: " .. score .. " | Misses: " .. missCounter .. " | Accuracy: " .. convertedAcc .. " | " .. ratingText, -385, -350, 800, "center")
							end
						end
					else
						local convertedAcc = string.format(
							"%.2f%%",
							(altScore / (noteCounter + missCounter))
						)
						if noteCounter + missCounter <= 0 then
							if (math.floor((altScore / (noteCounter + missCounter)) / 3.5)) >= 100 then
								love.graphics.printf("Score: " .. score .. " | Misses: " .. missCounter .. " | Accuracy: 0% | ???", -385, 400, 800, "center")
							else
								love.graphics.printf("Score: " .. score .. " | Misses: " .. missCounter .. " | Accuracy: 0% | ???", -385, 400, 800, "center")
							end
						else
							if (math.floor((altScore / (noteCounter + missCounter)) / 3.5)) >= 100 then
								love.graphics.printf("Score: " .. score .. " | Misses: " .. missCounter .. " | Accuracy: 100% | PERFECT!!!", -385, 400, 800, "center")
							else
								love.graphics.printf("Score: " .. score .. " | Misses: " .. missCounter .. " | Accuracy: " .. convertedAcc .. " | " .. ratingText, -385, 400, 800, "center")
							end
						end
					end

					if settings.sideJudgements then
						love.graphics.printf(
							"Sicks: " .. sicks ..
							"\n\nGoods: " .. goods ..
							"\n\nBads: " .. bads ..
							"\n\nShits: " .. shits,
							-900,
							0, 
							750, -- annoying limit and i don't want to test if it works with nil 
							"left"
						)
					end
				end
			else -- Due to resizing the pixel text, I need to reposition it all
				if not settings.botPlay then
					if settings.downscroll then
						local convertedAcc = string.format(
							"%.2f%%",
							(altScore / (noteCounter + missCounter))
						)
						if noteCounter + missCounter <= 0 then
							if (math.floor((altScore / (noteCounter + missCounter)) / 3.5)) >= 100 then
								love.graphics.printf("Score: " .. score .. " | Misses: " .. missCounter .. " | Accuracy: 0% | ???", -1750, -350, 1000, "center", nil, 3.5, 3.5)
							else
								love.graphics.printf("Score: " .. score .. " | Misses: " .. missCounter .. " | Accuracy: 0% | ???", -1750, -350, 1000, "center", nil, 3.5, 3.5)
							end
						else
							if (math.floor((altScore / (noteCounter + missCounter)) / 3.5)) >= 100 then
								love.graphics.printf("Score: " .. score .. " | Misses: " .. missCounter .. " | Accuracy: 100% | PERFECT!!!", -1750, -350, 1000, "center", nil, 3.5, 3.5)
							else
								love.graphics.printf("Score: " .. score .. " | Misses: " .. missCounter .. " | Accuracy: " .. convertedAcc .. " | " .. ratingText, -1750, -350, 1000, "center", nil, 3.5, 3.5)
							end
						end
					else
						local convertedAcc = string.format(
							"%.2f%%",
							(altScore / (noteCounter + missCounter))
						)
						if noteCounter + missCounter <= 0 then
							if (math.floor((altScore / (noteCounter + missCounter)) / 3.5)) >= 100 then
								love.graphics.printf("Score: " .. score .. " | Misses: " .. missCounter .. " | Accuracy: 0% | ???", -1750, 400, 1000, "center", 0, 3.5, 3.5)
							else
								love.graphics.printf("Score: " .. score .. " | Misses: " .. missCounter .. " | Accuracy: 0% | ???", -1750, 400, 1000, "center", 0, 3.5, 3.5)
							end
						else
							if (math.floor((altScore / (noteCounter + missCounter)) / 3.5)) >= 100 then
								love.graphics.printf("Score: " .. score .. " Misses: " .. missCounter .. " | Accuracy: 100% | PERFECT!!!", -1750, 400, 1000, "center", 0, 3.5, 3.5)
							else
								love.graphics.printf("Score: " .. score .. " Misses: " .. missCounter .. " | Accuracy: " .. convertedAcc .. " | " .. ratingText, -1750, 400, 1000, "center", 0, 3.5, 3.5)
							end
						end
					end

					if settings.sideJudgements then
						love.graphics.printf(
							"Sicks: " .. sicks ..
							"\n\nGoods: " .. goods ..
							"\n\nBads: " .. bads ..
							"\n\nShits: " .. shits,
							-900,
							0, 
							750, -- annoying limit and i don't want to test if it works with nil 
							"left",
							0,
							3.5,
							3.5
						)
					end
				end
			end
		love.graphics.pop()
	end,

	leave = function(self)
		if inst then inst:stop() end
		voices:stop()
		uiTextColour = {1,1,1}

		Timer.clear()

		fakeBoyfriend = nil
	end
}
