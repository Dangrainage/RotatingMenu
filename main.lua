local inventory = {
    {name = "Pistol", sprite = "sprites/pistol.png", descip = "Long range enchanced pacifier!"},
    {name = "Knife", sprite = "sprites/knife.png", descip = "For cutting that bread"},
    {name = "Fiber Wire", sprite = "sprites/fiberwire.png", descip = "Enhanced pacifier"},
    {name = "Syringe", sprite = "sprites/syringe.png", descip = "Poisoned syringe, hell yeah!"},
    {name = "Explosive", sprite = "sprites/explosive.png", descip = "Goes boom boom and boom!"}
}

local currentIndex = 1
local rotateAngle = 0
local targetAngle = 0
local rotationSpeed = math.pi / 2
local centerX, centerY
local radius = 150
local sprites = {}

function love.load()
    love.graphics.setFont(love.graphics.newFont(24))
    centerX = love.graphics.getWidth() / 2
    centerY = love.graphics.getHeight() / 2

    for _, item in ipairs(inventory) do
        sprites[item.name] = love.graphics.newImage(item.sprite)
    end
end

function smoothRotation(dt) 
    if math.abs(targetAngle - rotateAngle) > 0.01 then
        local delta = targetAngle - rotateAngle
        rotateAngle = rotateAngle + math.min(math.abs(delta), rotationSpeed * dt) * math.sign(delta)
    else
        rotateAngle = targetAngle
    end
end
-- thank fuck for chatGPT being a thing for these formulas otherwise I'd never have figured It out
-- I'll leave It on github..

function love.update(dt)
    smoothRotation(dt)
end

function love.keypressed(key)
    if key == "right" then
        currentIndex = (currentIndex % #inventory) + 1
        targetAngle = targetAngle - (2 * math.pi / #inventory)
    elseif key == "left" then
        currentIndex = (currentIndex - 2) % #inventory + 1
        targetAngle = targetAngle + (2 * math.pi / #inventory)
    end
end

function love.draw()
    love.graphics.print("Current Item: " .. inventory[currentIndex].name, centerX - 100, centerY + 200)
    love.graphics.print(inventory[currentIndex].descip, centerX - 150, centerY + 250)

    for i, item in ipairs(inventory) do
        local angle = (i - 1) * (2 * math.pi / #inventory) + rotateAngle
        local x = centerX + math.cos(angle) * radius
        local y = centerY + math.sin(angle) * radius
        local sprite = sprites[item.name]

        if i == currentIndex then
            love.graphics.setColor(1, 0.5, 0)
            love.graphics.draw(sprite, x - sprite:getWidth() / 2, y - sprite:getHeight() / 2, 0, 1.2, 1.2)
        else
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(sprite, x - sprite:getWidth() / 2, y - sprite:getHeight() / 2)
        end
    end
end

function math.sign(x)
    return x > 0 and 1 or x < 0 and -1 or 0
end
