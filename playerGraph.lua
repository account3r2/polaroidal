require "polar"
require "matchGraph"

playerGraph = {}

playerGraph.graph = polar.new(
      love.graphics.getWidth() / 2,
      love.graphics.getHeight() / 2,
      0,
      50,
      0, 3, 1
)

playerGraph.keyMaps = {
   incr_a = "i",
   decr_a = "k",
   incr_b = "l",
   decr_b = "j",
   incr_n = "u",
   decr_n = "o"
}

playerGraph.doIncr = {}

playerGraph.doDecr = {}

playerGraph.speeds = {}

playerGraph.maxSpeeds = {
   a = 6,
   b = 6,
   n = 3
}

playerGraph.accels = {
   a = 10,
   b = 10,
   n = 2
}

playerGraph.fricts = {
   a = -3,
   b = -3,
   n = -1
}

local graph = playerGraph.graph
local km = playerGraph.keyMaps
local doIncr = playerGraph.doIncr
local doDecr = playerGraph.doDecr
local speeds = playerGraph.speeds
local maxSpeeds = playerGraph.maxSpeeds
local accels = playerGraph.accels
local fricts = playerGraph.fricts

function playerGraph.load()
   for _, k in pairs({"a", "b", "n"}) do
      doIncr[k] = false
      doDecr[k] = false
      speeds[k] = 0
   end
end

function playerGraph.update(dt)
   for k, s in pairs(speeds) do
      if s > 0 then
	 speeds[k] = math.max(0, s + fricts[k] * dt)
      elseif s < 0 then
	 speeds[k] = math.min(0, s - fricts[k] * dt)
      end
   end

   if doIncr.a then
      speeds.a = math.min(maxSpeeds.a, speeds.a + accels.a * dt)
   elseif doDecr.a then
      speeds.a = math.max(-maxSpeeds.a, speeds.a - accels.a * dt)
   end

   if doIncr.b then
      speeds.b = math.min(maxSpeeds.b, speeds.b + accels.b * dt)
   elseif doDecr.b then
      speeds.b = math.max(-maxSpeeds.b, speeds.b - accels.b * dt)
   end

   if doIncr.n then
      speeds.n = math.min(maxSpeeds.n, speeds.n + accels.n * dt)
   elseif doDecr.n then
      speeds.n = math.max(-maxSpeeds.n, speeds.n - accels.n * dt)
   end

   graph:set_a(graph:get_a() + speeds.a * dt)
   graph:set_b(graph:get_b() + speeds.b * dt)
   graph:set_n(graph:get_n() + speeds.n * dt)

   graph:calcPoints()
end

function playerGraph.keypressed(key)
   if key == km.incr_a then
      doIncr.a = true
      doDecr.a = false
   elseif key == km.decr_a then
      doDecr.a = true
      doIncr.a = false

   elseif key == km.incr_b then
      doIncr.b = true
      doDecr.b = false
   elseif key == km.decr_b then
      doDecr.b = true
      doIncr.b = false

   elseif key == km.incr_n then
      doIncr.n = true
      doDecr.n = false
   elseif key == km.decr_n then
      doDecr.n = true
      doIncr.n = false
   end
end

function playerGraph.keyreleased(key)
   if key == km.incr_a then
      doIncr.a = false
      if love.keyboard.isDown(km.decr_a) then
	 doDecr.a = true
      else
	 doDecr.a = false
      end
   elseif key == km.decr_a then
      doDecr.a = false
      if love.keyboard.isDown(km.incr_a) then
	 doIncr.a = true
      else
	 doIncr.a = false
      end

   elseif key == km.incr_b then
      doIncr.b = false
      if love.keyboard.isDown(km.decr_b) then
	 doDecr.b = true
      else
	 doDecr.b = false
      end
   elseif key == km.decr_b then
      doDecr.b = false
      if love.keyboard.isDown(km.incr_b) then
	 doIncr.b = true
      else
	 doIncr.b = false
      end

   elseif key == km.incr_n then
      doIncr.n = false
      if love.keyboard.isDown(km.decr_n) then
	 doDecr.n = true
      else
	 doDecr.n = false
      end
   elseif key == km.decr_n then
      doDecr.n = false
      if love.keyboard.isDown(km.incr_n) then
	 doIncr.n = true
      else
	 doIncr.n = false
      end
   end
end

function playerGraph.draw()
   love.graphics.setColor(0, 0, 127, 255)
   graph:draw(5)
   
   --DEBUGGING
   love.graphics.setColor(0, 200, 0, 255)
   love.graphics.print(
      "a:\t" .. graph:get_a()
	 .. "\nb:\t" .. graph:get_b()
	 .. "\nn:\t" .. graph:get_n(),
      5, 5
   )
   --EOF DEBUG
end
