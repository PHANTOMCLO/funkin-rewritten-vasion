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
	love.graphics.newImage(graphics.imagePath("mega/lazors")),
	-- Automatically generated from lazors.xml
	{
		{x = 0, y = 0, width = 1445, height = 929, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 1: .lazors0000
		{x = 1445, y = 0, width = 1445, height = 929, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 2: .lazors0001
		{x = 0, y = 929, width = 1445, height = 929, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 3: .lazors0002
		{x = 1445, y = 929, width = 1445, height = 929, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 4: .lazors0003
		{x = 0, y = 1858, width = 1445, height = 929, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 5: .lazors0004
		{x = 1445, y = 1858, width = 1445, height = 929, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 6: .lazors0005
		{x = 0, y = 2787, width = 1445, height = 929, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 7: .lazors0006
		{x = 1445, y = 2787, width = 1445, height = 929, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0} -- 8: .lazors0007
	},
	{
		["anim"] = {start = 1, stop = 8, speed = 24, offsetX = 0, offsetY = 0}
	},
	"anim",
	true
)
