#version 330 core

in vec4 gfrontColor;
out vec4 fragColor;
in vec3 color;
in vec2 texCoord;
void main()
{
    if (texCoord == vec2 (-1.0)){
         fragColor = gfrontColor;
         return;
    }

    // Lògica de la "F"
    float x = texCoord.x;
    float y = texCoord.y;
    
    bool isBlack = (x >= 2.0 && x < 3.0 &&  y >= 1.0 && y <= 6.0 ||
                    x >= 3.0 && x < 4.0 &&  y >= 3.0 && y < 4.0 ||
                    x >= 2.0 && x <= 4.0 &&  y >= 5.0 && y < 6.0 );

    if (isBlack)
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
    else
        fragColor = vec4(color, 1.0); // groc
}

