#version 330 core

in vec4 frontColor;
in vec2 vtexCoord;
out vec4 fragColor;

uniform sampler2D jungla;
uniform vec2 viewport;
uniform vec2 mousePosition;
uniform float magnific = 3;


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
    vec2 p = vec2(vtexCoord.s*viewport.x,vtexCoord.t*viewport.y);
    vec2 c1 = mousePosition + vec2(80.,0.);
    vec2 c2 = mousePosition + vec2(-80.,0.);

    if(distance(c1,p) > 105 && distance(c2,p) > 105) 
    {
        fragColor = blurImage(vtexCoord);   
    }
    else if(distance(c1,p) > 100 && distance(c2,p) > 100)
    {
        fragColor = vec4(0,0,0,1);
    }
    else 
    {
        vec2 mouse = mousePosition / viewport;     // passem mouse a [0,1]
        vec2 tex = vtexCoord;                      // coordenada actual
        vec2 P = mouse + (tex - mouse) / magnific; // punt magnificat

        fragColor = texture(jungla, P);
    }
}
