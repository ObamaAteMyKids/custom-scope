
ref = gui.Reference("Visuals","Overlay", "Weapon");

custom_scope = gui.Checkbox(ref, "custom_scope", "Custom Scope", false)
custom_scope_color = gui.ColorPicker(ref, "custom_scope_color", "Scope Color", 255, 255, 255, 255)
alternative_scope = gui.Checkbox(ref, "custom_scope_alt", "Alternative Scope", false)
alternative_hashtag = gui.Checkbox(ref, "custom_scope_alt_hashtag", "Alternative Hashtag", false)
fast_mode = gui.Checkbox(ref, "fast_mode", "Fast Animation Mode", false)

local function rect(x, y, w, h, col)
    draw.Color(col[1], col[2], col[3], col[4]);
    draw.FilledRect(x, y, x + w, y + h);
end

local function gradientH(x1, y1, x2, y2, col1, left)
    local w = x2 - x1
    local h = y2 - y1
 
    for i = 0, w do
        local a = (i / w) * col1[4]
        local r, g, b = col1[1], col1[2], col1[3];
        draw.Color(r, g, b, a)
        if left then
            draw.FilledRect(x1 + i, y1, x1 + i + 1, y1 + h)
        else
            draw.FilledRect(x1 + w - i, y1, x1 + w - i + 1, y1 + h)
        end
    end
end

local function gradientV( x, y, w, h, col1,down )

    local r, g, b ,a= col1[1], col1[2], col1[3], col1[4];
    for i = 1, h do
        local a = i / h * col1[4];
        if down then
            rect(x, y + i,w, 1, { r, g, b, a });
        else
            rect(x, y - i,w, 1, { r, g, b, a });
        end
    end
end

local function draw_GradientRect(x, y, w, h, dir, col1, col2)

    local r, g, b, a= col1[1], col1[2], col1[3], col1[4]; 
    local r2, g2, b2, a2= col2[1], col2[2], col2[3], col2[4]; 
    if dir == 0  then   
    gradientV(x, y, w, h, {r2, g2, b2, a2} , true)
    gradientV(x, y + h, w, h, {r, g, b, a} , false)
    elseif dir == 1  then
    gradientH(x, y, w + x, h + y, {r, g, b ,a} , true)
    gradientH(x, y, w + x, h + y, {r2, g2, b2 ,a2} , false)
    elseif dir ~= 1 or 0 then
        print("GradientRect:Unexpected characters '"..dir.."' (Please use it 0 or 1)")
    end

end

local alpha = 0

callbacks.Register("Draw", function()

    if not custom_scope:GetValue() then 
        return 
    end

    gui.SetValue('esp.other.noscope', true)
    gui.SetValue('esp.other.noscopeoverlay', false)
    gui.SetValue('esp.other.noscopedirt', true)

    local localplayer = entities.GetLocalPlayer()
    local is_scoped = localplayer:GetPropBool("m_bIsScoped")
    local factor = 0

    if fast_mode:GetValue() then
        factor = 5 * globals.FrameTime()
    else
        factor = 2.5 * globals.FrameTime()
    end

    if is_scoped then
        if alpha < 1.0 then
            alpha = alpha + factor
        end
    else
        if alpha > 0.0 then
           alpha = alpha - factor
        end
    end

    if alpha >= 1.0 then
        alpha = 1
    end
     
    if alpha <= 0.0 then
        alpha = 0
        return 
    end

    local width, height = draw.GetScreenSize()

    local center_x, center_y = width / 2, height / 2

	local r,g,b,a = custom_scope_color:GetValue()

    client.SetConVar("r_drawvgui", 0, true);

    if is_scoped then

        if alternative_scope:GetValue() and alternative_hashtag:GetValue() then
        --top--        
        draw_GradientRect(center_x + 45, center_y - 159, 1, 150 * alpha, 0, {0, 0, 0, 0}, {r, g, b, a * alpha})
        draw_GradientRect(center_x - 45, center_y - 159, 1, 150 * alpha, 0, {0, 0, 0, 0}, {r, g, b, a * alpha})

        --bottom--
        draw_GradientRect(center_x + 45, center_y + (150 * (1.0 - alpha)) + 10 , 1, 150 - (150 * (1.0 - alpha)) , 0, {r, g, b, a * alpha}, {0, 0, 0, 0})
        draw_GradientRect(center_x - 45, center_y + (150 * (1.0 - alpha)) + 10 , 1, 150 - (150 * (1.0 - alpha)) , 0, {r, g, b, a * alpha}, {0, 0, 0 ,0})
        
        --left--
        draw_GradientRect(center_x - 159, center_y + 45, 150 * alpha, 1, 1, {r, g, b, a * alpha}, {0, 0, 0, 0})
        draw_GradientRect(center_x - 159, center_y - 45, 150 * alpha, 1, 1, {r, g, b, a * alpha}, {0, 0, 0, 0})
        
        --right--
        draw_GradientRect(center_x + 10 + (150 * (1.0 - alpha)), center_y + 45,  150 - (150 * (1.0 - alpha)), 1, 1, {0, 0 ,0, 0}, {r, g, b, a * alpha})
        draw_GradientRect(center_x + 10 + (150 * (1.0 - alpha)), center_y - 45,  150 - (150 * (1.0 - alpha)), 1, 1, {0, 0, 0, 0}, {r, g, b, a * alpha})
        elseif alternative_scope:GetValue() and not alternative_hashtag:GetValue() then
        --top--        
        draw_GradientRect(center_x, center_y - 159, 1, 150 * alpha, 0, {0, 0, 0, 0}, {r, g, b, a * alpha})

        --bottom--
        draw_GradientRect(center_x, center_y + (150 * (1.0 - alpha)) + 10 , 1, 150 - (150 * (1.0 - alpha)) , 0, {r, g, b, a * alpha}, {0, 0, 0, 0})

        --left--
        draw_GradientRect(center_x - 159, center_y, 150 * alpha, 1, 1, {r, g, b, a * alpha}, {0, 0, 0, 0})

        --right--
        draw_GradientRect(center_x + 10 + (150 * (1.0 - alpha)), center_y,  150 - (150 * (1.0 - alpha)), 1, 1, {0, 0 ,0, 0}, {r, g, b, a * alpha})

        else 
        --top left--
        draw.Color(r, g, b, a * alpha)
        draw.Line(center_x - 5, center_y - 5, center_x - 5 - (105 * alpha), center_y - 5 - (105 * alpha))
        draw.Line(center_x - 4, center_y - 5, center_x - 4 - (105 * alpha), center_y - 5 - (105 * alpha))

        --top right--
        draw.Line(center_x + 5, center_y - 5, center_x + 5 + (105 * alpha), center_y - 5 - (105 * alpha))
        draw.Line(center_x + 4, center_y - 5, center_x + 4 + (105 * alpha), center_y - 5 - (105 * alpha))

        --bottom left--
        draw.Line(center_x - 5, center_y + 5, center_x - 5 - (105 * alpha), center_y + 5 + (105 * alpha))
        draw.Line(center_x - 4, center_y + 5, center_x - 4 - (105 * alpha), center_y + 5 + (105 * alpha))

        --bottom right--
        draw.Line(center_x + 5, center_y + 5, center_x + 5 + (105 * alpha), center_y + 5 + (105 * alpha))
        draw.Line(center_x + 4, center_y + 5, center_x + 4 + (105 * alpha), center_y + 5 + (105 * alpha))
        end
    end
end)