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
	love.graphics.newImage(graphics.imagePath("mega/ground")),
	-- Automatically generated from ground.xml
	{
		{x = 0, y = 0, width = 1778, height = 363, offsetX = 0, offsetY = 0, offsetWidth = 1829, offsetHeight = 363}, -- 1: norocks0000
		{x = 0, y = 0, width = 1778, height = 363, offsetX = 0, offsetY = 0, offsetWidth = 1829, offsetHeight = 363}, -- 2: norocks0001
		{x = 1778, y = 0, width = 1801, height = 342, offsetX = 0, offsetY = 0, offsetWidth = 1829, offsetHeight = 363}, -- 3: norocks0002
		{x = 1778, y = 0, width = 1801, height = 342, offsetX = 0, offsetY = 0, offsetWidth = 1829, offsetHeight = 363}, -- 4: norocks0003
		{x = 0, y = 363, width = 1776, height = 359, offsetX = 0, offsetY = 0, offsetWidth = 1829, offsetHeight = 363}, -- 5: norocks0004
		{x = 0, y = 363, width = 1776, height = 359, offsetX = 0, offsetY = 0, offsetWidth = 1829, offsetHeight = 363}, -- 6: norocks0005
		{x = 1776, y = 363, width = 1776, height = 342, offsetX = 0, offsetY = 0, offsetWidth = 1829, offsetHeight = 363}, -- 7: norocks0006
		{x = 1776, y = 363, width = 1776, height = 342, offsetX = 0, offsetY = 0, offsetWidth = 1829, offsetHeight = 363}, -- 8: norocks0007
		{x = 0, y = 722, width = 1776, height = 342, offsetX = 0, offsetY = 0, offsetWidth = 1829, offsetHeight = 363}, -- 9: norocks0008
		{x = 1776, y = 722, width = 1829, height = 363, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0}, -- 10: norocks0009
		{x = 1776, y = 722, width = 1829, height = 363, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0} -- 11: norocks0010
	},
	{
		["anim"] = {start = 1, stop = 11, speed = 24, offsetX = 0, offsetY = 0}
	},
	"anim",
	false
)
