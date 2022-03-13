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
	love.graphics.newImage(graphics.imagePath("mega/bikesand")),
	-- Automatically generated from bikesand.xml
	{
		{x = 0, y = 0, width = 240, height = 265, offsetX = -36, offsetY = 0, offsetWidth = 276, offsetHeight = 271}, -- 1: sandbbike0000
		{x = 240, y = 0, width = 233, height = 213, offsetX = -8, offsetY = -58, offsetWidth = 276, offsetHeight = 271}, -- 2: sandbbike0001
		{x = 0, y = 265, width = 239, height = 186, offsetX = 0, offsetY = -85, offsetWidth = 276, offsetHeight = 271} -- 3: sandbbike0002
	},
	{
		["anim"] = {start = 1, stop = 3, speed = 24, offsetX = 0, offsetY = 0}
	},
	"anim",
	false
)
