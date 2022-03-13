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

local sand, mountains

return {
	enter = function(self, from, songNum, songAppend)-- you should totally watch the fucking sonic ova like seriously it goes so hard
		weeks:enter()

		cam.sizeX, cam.sizeY = 1.2, 1.2
		camScale.x, camScale.y = 1.2, 1.2

		song = songNum
		difficulty = songAppend

		healthBarColorEnemy = {0,153,204}

		sky = love.filesystem.load("sprites/mega/sky.lua")()
		mountains = graphics.newImage(love.graphics.newImage(graphics.imagePath("mega/mountains")))
		sand = graphics.newImage(love.graphics.newImage(graphics.imagePath("mega/sand")))
		bikesand = love.filesystem.load("sprites/mega/bikesand.lua")()
		ground = love.filesystem.load("sprites/mega/ground.lua")()
		lazors = love.filesystem.load("sprites/mega/lazors.lua")()


		boyfriend = love.filesystem.load("sprites/mega/green.lua")()
		enemy = love.filesystem.load("sprites/mega/blue.lua")()
		wheeliebiker = love.filesystem.load("sprites/mega/greenw.lua")()

		girlfriend.x, girlfriend.y = 30, -90
		wheeliebiker.x, wheeliebiker.y = 290, 100
		sand.x, sand.y = 700, 170
		sand.sizeX, sand.sizeY = 1.6, 0.8
		sky.sizeX, sky.sizeY = 1.3, 1.3
		ground.sizeX, ground.sizeY = 1.3, 1.3

		ground.y = 400
		mountains.y = -80
		sky.y = 100

		enemyIcon:animate("daddy dearest", false)
		ground:animate("anim", true)

		self:load()
	end,

	load = function(self)
		weeks:load()

		if song == 3 then
			inst = love.audio.newSource("music/week1/dadbattle-inst.ogg", "stream")
			voices = love.audio.newSource("music/week1/dadbattle-voices.ogg", "stream")
		elseif song == 2 then
			inst = love.audio.newSource("music/week1/fresh-inst.ogg", "stream")
			voices = love.audio.newSource("music/week1/fresh-voices.ogg", "stream")
		else
			inst = love.audio.newSource("music/mega/blaster/Inst.ogg", "stream")
			voices = love.audio.newSource("music/mega/blaster/Voices.ogg", "stream")
		end

		self:initUI()

		weeks:setupCountdown()
	end,

	initUI = function(self)
		weeks:initUI()

		if song == 3 then
			weeks:generateNotes(love.filesystem.load("charts/week1/dadbattle" .. difficulty .. ".lua")())
		elseif song == 2 then
			weeks:generateNotes(love.filesystem.load("charts/week1/fresh" .. difficulty .. ".lua")())
		else
			weeks:generateNotes(love.filesystem.load("charts/mega/blaster.lua")())-- easier difficulty is for LOSERS 
		end
	end,

	update = function(self, dt)
		weeks:update(dt)

		sky:update(dt)
		wheeliebiker:update(dt)
		lazors:update(dt)
		ground:update(dt)
		bikesand:update(dt)

		bikesand.x, bikesand.y = boyfriend.x - 350, boyfriend.y + 70


		if musicTime <= 2621 then --opening movement
			enemy.x, enemy.y = -2000, 130
			boyfriend.x, boyfriend.y = -2000, 100
		end

		if musicTime >= 2621 then
			if boyfriend.x == -2000 then
				if enemy.x == -2000 then
					Timer.tween(3.25, enemy, {x = -380, y = enemy.y}, "out-quad")
					Timer.tween(3.25, boyfriend, {x = 290, y = boyfriend.y}, "out-quad")
				end
			end
		end



		if not lazors:isAnimated() then --lazors anim
			lazors:animate("anim", true)
		end

		if not bikesand:isAnimated() then --bike`sand anim
			bikesand:animate("anim", true)
		end

		if not sky:isAnimated() then --shooting star anim
			sky:animate("anim", false)
		end
		if song == 1 and musicThres ~= oldMusicThres and math.fmod(absMusicTime, 60000 * (love.math.random(17) + 7) / bpm) < 100 then

			sky:animate("shootingstar", false)
		end

		enemy.y = enemy.y + 1 --bike go brrrrrrrrrrrrrrrrr
		boyfriend.y = boyfriend.y + 1
		if musicTime <= 95999 then
			wheeliebiker.y = boyfriend.y
		end
		sand.x = sand.x - 0.25 --WOAH im fucking moving

		if musicTime <= 5317 then --cam bullshit
			cam.x, cam.y = 0, 0
		elseif musicTime >= 5317 then
			if cam.sizeX == 1.2 then
				cam.sizeX, cam.sizeY = 1.1, 1.1
				camScale.x, camScale.y = 1.1, 1.1
			end
		end

		if musicTime <= 5317 then --cam bullshit
			if cam.sizeX == 1.1 then
				cam.sizeX, cam.sizeY = 1.2, 1.2
				camScale.x, camScale.y = 1.2, 1.2
			end
		end

		if musicTime >= 64006 then --animate wheelie
			if musicTime <= 64940 then
				if boyfriend:getAnimName() ~= "wheelie" then
					boyfriend:animate("wheelie", false)
				end
			end
		end
		if musicTime >= 64940 then --stop animating wheelie
			if boyfriend:getAnimName() == "wheelie" then
				boyfriend:animate("idle", false)
			end
		end

		if musicTime >= 95999 then--rip green biker dude, you didnt deserve to die multiple times while i playtested you
			wheeliebiker.x = wheeliebiker.x - 2
			boyfriend.x = -2000
		end
		if musicTime >= 95999 then
			if wheeliebiker:getAnimName() ~= "death" then
				wheeliebiker:animate("death", false)
			end
		end

		if musicTime <= 95999 then--wheelie skin
			if boyfriend:getAnimName() == "idle" then
				if wheeliebiker:getAnimName() ~= "idle" then
					wheeliebiker:animate("idle", false)
				end
			elseif boyfriend:getAnimName() == "left" then
				if wheeliebiker:getAnimName() ~= "left" then
					wheeliebiker:animate("left", false)
				end
			elseif boyfriend:getAnimName() == "right" then
				if wheeliebiker:getAnimName() ~= "right" then
					wheeliebiker:animate("right", false)
				end
			elseif boyfriend:getAnimName() == "up" then
				if wheeliebiker:getAnimName() ~= "up" then
					wheeliebiker:animate("up", false)
				end
			elseif boyfriend:getAnimName() == "down" then
				if wheeliebiker:getAnimName() ~= "down" then
					wheeliebiker:animate("down", false)
				end
			end
		end
		
		if health >= 80 then
			if enemyIcon:getAnimName() == "daddy dearest" then
				enemyIcon:animate("daddy dearest losing", false)
			end
		else
			if enemyIcon:getAnimName() == "daddy dearest losing" then
				enemyIcon:animate("daddy dearest", false)
			end
		end

		if enemy.y == 140 then
			enemy.y = 130
		end

		if boyfriend.y == 110 then
			boyfriend.y = 100
		end

		if not (countingDown or graphics.isFading()) and not (inst:isPlaying() and voices:isPlaying()) then
			if storyMode and song < 1 then
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
				love.graphics.translate(cam.x * 0.9, cam.y * 0.9)

				sky:draw()
				mountains:draw()
				sand:draw()
				ground:draw()

			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x, cam.y)

				if musicTime <= 95999 then
					bikesand:draw()
				end

				if musicTime <= 64940 then -- self explanitory. strange, isnt it??
					boyfriend:draw()
				elseif musicTime >= 64940 then
					wheeliebiker:draw()
				end
				enemy:draw()
				lazors:draw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 1.1, cam.y * 1.1)

			love.graphics.pop()
			weeks:drawRating(0.9)
		love.graphics.pop()

		if musicTime >= 5317 then
			weeks:drawUI()
			weeks:drawHealthBar()
		end
	end,

	leave = function(self)
		sand = nil
		mountains = nil

		weeks:leave()
	end
}
