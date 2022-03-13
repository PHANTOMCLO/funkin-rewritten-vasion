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

local song, difficulty

local tankSky, tankGround, tankMountains, tankRuins, tankClouds

local tank0, tank1, tank2, tank3, tank4, tank5

return {
	enter = function(self, from, songNum, songAppend)
		weeks:enter()

		cam.sizeX, cam.sizeY = 0.9, 0.9
		camScale.x, camScale.y = 0.9, 0.9

		song = songNum
		difficulty = songAppend

		healthBarColorEnemy = {0,0,0}

		tankSky = graphics.newImage(love.graphics.newImage(graphics.imagePath("week7/tankSky")))
		tankMountains = graphics.newImage(love.graphics.newImage(graphics.imagePath("week7/tankMountains")))
		tankRuins = graphics.newImage(love.graphics.newImage(graphics.imagePath("week7/tankRuins")))
		tankClouds = graphics.newImage(love.graphics.newImage(graphics.imagePath("week7/tankClouds")))
		tankGround = graphics.newImage(love.graphics.newImage(graphics.imagePath("week7/tankGround")))

		tankGround.sizeX, tankGround.sizeY = 1.1, 1.1
		tankMountains.sizeX, tankMountains.sizeY = 1.5, 1.5
		tankRuins.sizeX, tankRuins.sizeY = 1.1, 1.1

		tankGround.y = 0
		tankClouds.y = -200
		tankMountains.y = 100
		tankRuins.y = 0

		tankWatchtower = love.filesystem.load("sprites/week7/tankWatchtower.lua")()
		smokeLeft = love.filesystem.load("sprites/week7/smokeLeft.lua")()
		smokeRight = love.filesystem.load("sprites/week7/smokeRight.lua")()
		girlfriend = love.filesystem.load("sprites/week7/gfTankmen.lua")()
		enemy = love.filesystem.load("sprites/week7/tankman.lua")()
		tank0 = love.filesystem.load("sprites/week7/tank0.lua")()
		tank1 = love.filesystem.load("sprites/week7/tank1.lua")()
		tank2 = love.filesystem.load("sprites/week7/tank2.lua")()
		tank3 = love.filesystem.load("sprites/week7/tank3.lua")()
		tank4 = love.filesystem.load("sprites/week7/tank4.lua")()
		tank5 = love.filesystem.load("sprites/week7/tank5.lua")()

		girlfriend.x, girlfriend.y = 30, -90
		enemy.x, enemy.y = -440, 130
		boyfriend.x, boyfriend.y = 360, 160
		tank0.x, tank0.y = -1050, 330
		tank1.x, tank1.y = -700, 470
		tank2.x, tank2.y = -200, 520
		tank3.x, tank3.y = 300, 470
		tank4.x, tank4.y = 700, 4700
		tank5.x, tank5.y = 1050, 330
		tankWatchtower.x, tankWatchtower.y = -680, 0
		smokeLeft.x, smokeLeft.y = -880, 0
		smokeRight.x, smokeRight.y = 880, 0



		enemy.sizeX = -1
		tankSky.sizeX, tankSky.sizeY = 1.3, 1.3

		enemyIcon:animate("tankman", false)

		tank0:animate("anim", true)
		tank1:animate("anim", true)
		tank2:animate("anim", true)
		tank3:animate("anim", true)
		tank4:animate("anim", true)
		tank5:animate("anim", true)
		tankWatchtower:animate("anim", true)
		smokeLeft:animate("anim", true)
		smokeRight:animate("anim", true)

		self:load()
	end,

	load = function(self)
		weeks:load()

		if song == 3 then

			boyfriend = love.filesystem.load("sprites/week7/bfAndGF.lua")()
			boyfriend.x, boyfriend.y = 360, 160
			girlfriend = love.filesystem.load("sprites/week7/picoSpeaker.lua")()
			girlfriend.x, girlfriend.y = 180, -120

			inst = love.audio.newSource("music/week7/stress-inst.ogg", "stream")
			voices = love.audio.newSource("music/week7/stress-voices.ogg", "stream")
		elseif song == 2 then
			inst = love.audio.newSource("music/week7/guns-inst.ogg", "stream")
			voices = love.audio.newSource("music/week7/guns-voices.ogg", "stream")
		else
			inst = love.audio.newSource("music/week7/ugh-inst.ogg", "stream")
			voices = love.audio.newSource("music/week7/ugh-voices.ogg", "stream")
		end

		self:initUI()

		weeks:setupCountdown()
	end,

	initUI = function(self)
		weeks:initUI()

		if song == 3 then
			weeks:generateNotes(love.filesystem.load("charts/week7/stress" .. difficulty .. ".lua")())
		elseif song == 2 then
			weeks:generateNotes(love.filesystem.load("charts/week7/guns" .. difficulty .. ".lua")())
		else
			weeks:generateNotes(love.filesystem.load("charts/week7/ugh" .. difficulty .. ".lua")())
		end
	end,

	update = function(self, dt)
		weeks:update(dt)

		if song == 3 then
			tank0:update(dt)
			tank1:update(dt)
			tank2:update(dt)
			tank3:update(dt)
			tank4:update(dt)
			tank5:update(dt)
			tankWatchtower:update(dt)
			smokeLeft:update(dt)
			smokeRight:update(dt)
		end

		if song == 2 then
			tank0:update(dt)
			tank1:update(dt)
			tank2:update(dt)
			tank3:update(dt)
			tank4:update(dt)
			tank5:update(dt)
			tankWatchtower:update(dt)
			smokeLeft:update(dt)
			smokeRight:update(dt)
		end

		if song == 1 then
			if musicTime >= 5550 then
				if musicTime <= 6160 then
					if enemy:getAnimName() == "up" then
						enemy:animate("ugh", false)
					end
				end
			end
			if musicTime >= 41602 then
				if musicTime <= 42198 then
					if enemy:getAnimName() == "up" then
						enemy:animate("ugh", false)
					end
				end
			end
			if musicTime >= 49108 then
				if musicTime <= 49546 then
					if enemy:getAnimName() == "up" then
						enemy:animate("ugh", false)
					end
				end
			end
			if musicTime >= 50591 then
				if musicTime <= 50885 then
					if enemy:getAnimName() == "up" then
						enemy:animate("ugh", false)
					end
				end
			end
			if musicTime >= 77604 then
				if musicTime <= 78053 then
					if enemy:getAnimName() == "up" then
						enemy:animate("ugh", false)
					end
				end
			end
			tank0:update(dt)
			tank1:update(dt)
			tank2:update(dt)
			tank3:update(dt)
			tank4:update(dt)
			tank5:update(dt)
			tankWatchtower:update(dt)
			smokeLeft:update(dt)
			smokeRight:update(dt)
		end

		if health >= 80 then
			if enemyIcon:getAnimName() == "tankman" then
				enemyIcon:animate("tankman losing", false)
			end
		else
			if enemyIcon:getAnimName() == "tankman losing" then
				enemyIcon:animate("tankman", false)
			end
		end

		if not (countingDown or graphics.isFading()) and not (inst:isPlaying() and voices:isPlaying()) then
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

		weeks:updateUI(dt)
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
			love.graphics.scale(cam.sizeX, cam.sizeY)

			love.graphics.push()
				love.graphics.translate(cam.x * 0.5, cam.y * 0.5)
				tankSky:draw()
				tankClouds:draw()
				tankMountains:draw()

			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 0.7, cam.y * 0.7)
				tankRuins:draw()

			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 0.8, cam.y * 0.8)

				tankWatchtower:draw()

				smokeLeft:draw()
				smokeRight:draw()

			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 0.9, cam.y * 0.9)
				tankGround:draw()

				girlfriend:draw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x, cam.y)

				enemy:draw()
				boyfriend:draw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 1.1, cam.y * 1.1)


			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 1.3, cam.y * 1.3)

				tank0:draw()
				tank2:draw()
				tank5:draw()
				tank4:draw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 1.5, cam.y * 1.5)

				tank1:draw()
				tank3:draw()
			love.graphics.pop()
			weeks:drawRating(0.9)
		love.graphics.pop()

		weeks:drawUI()
		weeks:drawHealthBar()
	end,

	leave = function(self)
		tankSky = nil
		tankMountains = nil
		tankRuins = nil
		tankClouds = nil
		tankGround = nil

		weeks:leave()
	end
}
