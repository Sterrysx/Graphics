#version 330 core

in vec4 frontColor;
out vec4 fragColor;
uniform sampler2D jungla;
uniform vec2 mousePosition;
uniform vec2 viewport;
uniform float magnific = 3;
in vec2 vertexCord;



vec4 blurImage( in vec2 coords )
{
    float Pi = 6.28318530718; // Pi*2
    float Directions = 16.0; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
    float Quality = 8.0; // BLUR QUALITY (Default 4.0 - More is better but slower)
    float Size = 10.0; // BLUR SIZE (Radius)
   
    vec2 Radius = Size/viewport;

    vec4 Color = texture(jungla, coords);
    for( float d=0.0; d<Pi; d+=Pi/Directions)
    {
        float cd = cos(d);
        float sd = sin(d);
		for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
        {
			Color += texture(jungla, coords+vec2(cd,sd)*Radius*i);		
        }
    }
    
    // Output to screen
    Color /= Quality * Directions - 15.0;
    return  Color;
}



void main()
{
    vec2 screenPos = gl_FragCoord.xy;  // posición del fragmento en píxeles

    vec2 centerLeft= mousePosition - vec2(-80.0,0);
    vec2 centerRight= mousePosition - vec2(80.0,0);
    vec2 binocularsCenter = (centerLeft + centerRight) / 2.0;

    float distL = distance(screenPos, centerLeft);
    float distR = distance(screenPos, centerRight);
    
    float radius = 200.0;
    float border = 5.0;

    // Flags
    bool inLeft  = distL < radius;
    bool inRight = distR < radius;

   bool inBorderLeft  = distL >= radius - border && distL <= radius && !inRight;
bool inBorderRight = distR >= radius - border && distR <= radius && !inLeft;

    vec4 color;

if (inLeft || inRight) {
    vec2 delta = screenPos - binocularsCenter;
    vec2 zoomed = binocularsCenter + delta / magnific;
    vec2 uv = zoomed / viewport;
    color = texture(jungla, uv);
}

else if (inBorderLeft || inBorderRight) {
    // Borde negro, pero solo si NO estamos dentro del otro
    color = vec4(0.0);
}
else {
    // Parte desenfocada
    color = blurImage( vertexCord);
}


    fragColor = color;
}
