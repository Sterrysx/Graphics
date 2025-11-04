#version 330 core

in vec4 frontColor;
out vec4 fragColor;
uniform sampler2D colormap;
in vec2 vtexCoord;

void main()
{
     // Coordenadas del plano: v_uv ∈ [0,1]
    float cols = 13.0;
    float rows = 12.0;


    // Obtener la celda actual (columna y fila)
    float col = floor(vtexCoord.x * cols);
    float row = floor(vtexCoord.y * rows);

    // Coordenadas locales dentro de la celda [0,1]
    vec2 localUV = fract(vtexCoord * vec2(cols, rows));

    // Calcular coordenadas en la textura
    float texCol, texRow;

    if (row == 0.0 && col == 1.0) {
        // Fila 0 → cañón blanco (última columna, fila 0)
        texCol = 7.0;
        texRow = 1.0;
    } else if (row == 1.0 && mod(col,4) == 0) {
        // Fila 1 → escudos (última columna, fila 1)
        texCol = 7.0;
        texRow = 0.0;
    } else if (row > 1.0 && row < 12.0){
        // Filas 2 a 7 → invasores (tipo depende de fila)
       texCol = mod(row - 2.0, 6.0);
       texRow = 3.0 - floor((row - 2.0) / 2.0);
    }
    else{
        fragColor =  vec4(0.0);
        return;
    }
    

    // Coordenadas finales de textura
    vec2 texTileSize = vec2(1.0 / 4.0, 1.0 / 4.0);
    vec2 texUV = vec2(texCol, texRow) * texTileSize + localUV * texTileSize;

    fragColor = texture2D(colormap,texUV);

}



