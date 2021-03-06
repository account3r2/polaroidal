local alpha
local isFading
local backFade
local fadeFinal = 100
local fadeTime = 0.25
local fadeDelta = fadeFinal / fadeTime

states.game = {}

function states.game.reload()
   score.reload()
end

function states.game.update(dt)
   timers.update(dt)

   if not pause then
      playerGraph.update(dt)
      matchGraph.update(dt)
      score.update(dt)
   end

   if isFading then
      if backFade then
         alpha = alpha - fadeDelta*dt
      else
         alpha = alpha + fadeDelta*dt
      end
   end
end

function states.game.keypressed(key)
   if pause then

      if key == "escape" then
         isFading = true
         backFade = true
         alpha = fadeFinal
         timers.new(
            fadeTime,
            function()
               alpha = 0
               isFading = false
               backFade = false
            end
         )
         pause = false
      end

   elseif key == "escape" then
      pause = true

      isFading = true
      alpha = 0
      timers.new(
	 fadeTime,
	 function()
	    alpha = fadeFinal
	    isFading = false
	 end
      )
   else
      playerGraph.keypressed(key)
   end
end

function states.game.keyreleased(key)
   if pause then

   else
      playerGraph.keyreleased(key)
   end
end

function states.game.draw()
   matchGraph.draw()
   playerGraph.draw()
   score.draw()

   if pause or isFading then
      -- Draw haze over screen
      love.graphics.setColor(0, 0, 0, alpha)
      love.graphics.rectangle(
	 "fill",
	 0, 0,
	 love.graphics.getWidth(),
	 love.graphics.getHeight()
      )
      -- Draw pause text
      if not isFading then
         love.graphics.setColor(0, 0, 255, 255)
         love.graphics.print("- PAUSED -", math.floor(love.graphics.getWidth() / 2) - 215, math.floor(love.graphics.getHeight() / 2) - 35)
      end
   end
end
