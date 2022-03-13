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

return graphics.newSprite(
	love.graphics.newImage(graphics.imagePath("mega/sky")),
	-- Automatically generated from sky.xml
	{
		{x = 0, y = 0, width = 1679, height = 796, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 1: idlesky0000
		{x = 0, y = 0, width = 1679, height = 796, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 2: shootingsky0000
		{x = 1679, y = 0, width = 1679, height = 796, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 3: shootingsky0001
		{x = 1679, y = 0, width = 1679, height = 796, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 4: shootingsky0002
		{x = 0, y = 796, width = 1679, height = 796, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 5: shootingsky0003
		{x = 0, y = 796, width = 1679, height = 796, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 6: shootingsky0004
		{x = 1679, y = 796, width = 1679, height = 796, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 7: shootingsky0005
		{x = 1679, y = 796, width = 1679, height = 796, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 8: shootingsky0006
		{x = 0, y = 1592, width = 1679, height = 796, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 9: shootingsky0007
		{x = 0, y = 1592, width = 1679, height = 796, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 10: shootingsky0008
		{x = 1679, y = 1592, width = 1679, height = 796, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 11: shootingsky0009
		{x = 1679, y = 1592, width = 1679, height = 796, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 12: shootingsky0010
		{x = 0, y = 2388, width = 1679, height = 796, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 13: shootingsky0011
		{x = 0, y = 2388, width = 1679, height = 796, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0} -- 14: shootingsky0012
	},

	{
		["anim"] = {start = 1, stop = 1, speed = 24, offsetX = 0, offsetY = 0},
		["shootingstar"] = {start = 2, stop = 14, speed = 24, offsetX = 0, offsetY = 0}
	},
	"anim",
	false
)
