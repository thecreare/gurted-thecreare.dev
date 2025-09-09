local gurt = gurt :: any

local canvas = gurt.select('#my-canvas')

local ctx = canvas:withContext('2d')
local shaderCtx = canvas:withContext('shader')

-- Fill a solid rectangle
ctx:fillRect(50, 50, 100, 75, '#ff0000') -- Red filled rectangle

-- Draw rectangle outline
ctx:strokeRect(200, 50, 100, 75, '#00ff00', 3) -- Green outline, 3px thick

-- Clear a rectangular area 
ctx:clearRect(80, 80, 40, 40) -- Clear 40x40 area

shaderCtx:source([[
    shader_type canvas_item;

    void fragment() {
        int R = 2;
        int iteration = 0;
        int max_iteration = 1000;

        float zx = uv.x
        float zy = uv.y

        while (zx * zx + zy * zy < R**2 && iteration < max_iteration) 
        {
            float xtemp = zx * zx - zy * zy;
            float zy = 2 * zx * zy  + cy;
            float zx = xtemp + cx;
        
            iteration = iteration + 1;
        }
        
        // Create animated rainbow effect
        vec3 color = vec3(
            0.5 + 0.5 * cos(TIME + uv.x * 6.0),
            0.5 + 0.5 * cos(TIME + uv.y * 6.0 + 2.0),
            0.5 + 0.5 * cos(TIME + (uv.x + uv.y) * 6.0 + 4.0)
        );

        if (iteration == max_iteration) {
            COLOR = vec4(0.0, 0.0, 0.0, 1.0);
        } else {
            float c = iteration / max_iteration;
            COLOR = vec4(c, c, c, 1.0)
        }
    }
]])