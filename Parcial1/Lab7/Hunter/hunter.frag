#version 330 core

// --- INPUT (del Vertex Shader) ---
in vec2 vtexCoord; // Rango [0, 1]

// --- OUTPUT ---
out vec4 fragColor;

// --- UNIFORMS (Añadidos para "hunter") ---
uniform vec2 mousePosition;
uniform vec2 viewport;    // <-- 'blur.glsl' también necesita esto
uniform sampler2D jungla;   // <-- 'blur.glsl' también necesita esto
uniform float magnific = 3.0;

// ==============================================================
// == CÓDIGO PEGADO DE blur.glsl [INICIO] ==
// ==============================================================
// adaptat de https://www.shadertoy.com/view/Xltfzj. 
// no és realment Gaussià
// **requereix** que hi hagi declarat un sampler2D jungla!
// retorna el color corresponent a les coordenades de textura coords.
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
// ==============================================================
// == CÓDIGO PEGADO DE blur.glsl [FIN] ==
// ==============================================================


void main()
{
    // ==============================================================
    // == LÓGICA DE "hunter" VA AQUÍ ==
    // ==============================================================

    // 1. Color por defecto: la jungla desenfocada
    // Ahora el linker PUEDE encontrar esta función
    vec4 finalColor = blurImage(vtexCoord);

    // 2. Convertir coordenadas a píxeles
    vec2 pixelCoord = vtexCoord * viewport;

    // 3. Definir los centros de los binoculares
    vec2 centerL = mousePosition + vec2(-80.0, 0.0);
    vec2 centerR = mousePosition + vec2( 80.0, 0.0);

    // 4. Calcular distancias (en píxeles)
    float distL = distance(pixelCoord, centerL);
    float distR = distance(pixelCoord, centerR);

    // 5. Comprobar si estamos en la VORERA NEGRA (radio 100 a 105)
    if ( (distL > 100.0 && distL < 105.0) || 
         (distR > 100.0 && distR < 105.0) )
    {
        finalColor = vec4(0.0, 0.0, 0.0, 1.0); // Negro
    }
    // 6. Comprobar si estamos en la LENTE (radio < 100)
    else if (distL < 100.0 || distR < 100.0)
    {
        // --- Lógica de Magnificación ---
        vec2 M_tex = mousePosition / viewport;
        vec2 P_tex = M_tex + (vtexCoord - M_tex) / magnific;
        
        // Muestreamos la textura *original* (nítida) en el punto P
        finalColor = texture(jungla, P_tex);
    }
    
    // ==============================================================

    // --- Asignación Final ---
    fragColor = finalColor;
}