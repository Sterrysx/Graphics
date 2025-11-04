#version 330 core

// --- INPUTS (del modelo 3D) ---
layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

// --- OUTPUTS (al Fragment Shader) ---
out vec4 frontColor; // El color final calculado
out vec2 vtexCoord;  // La coordenada de textura

// --- UNIFORMS (del viewer) ---
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

// --- UNIFORMS (Añadido para "Spring") ---
uniform float time; // Necesario para la animación

void main()
{
    // Variables de deformación
    float scale_factor = 0.0;
    vec3 vertex_objectspace = vertex;
    vec3 normal_objectspace = normal;

    // ==============================================================
    // == STEP 3 (VS) - LÓGICA DE ANIMACIÓN "Spring"
    // ==============================================================
    
    // 1. Encontrar el tiempo actual dentro del ciclo de 3.5s
    float t_period = mod(time, 3.5);

    // 2. Comprobar en qué fase estamos
    if (t_period < 0.5)
    {
        // FASE 1: EXPANSIÓN (0.0s a 0.5s)
        
        // 2a. Calcular 't' de interpolación (0.0 a 1.0)
        // El enunciado pide (t/0.5)^3
        float t_exp = t_period / 0.5;
        scale_factor = t_exp * t_exp * t_exp;
    }
    else
    {
        // FASE 2: COMPRESIÓN (0.5s a 3.5s)
        
        // 2b. Calcular 't' de interpolación (0.0 a 1.0)
        // Mapeamos linealmente el rango [0.5, 3.5] al rango [0.0, 1.0]
        float t_comp = (t_period - 0.5) / 3.0;
        
        // Como estamos comprimiendo (original -> origen),
        // el factor de escala va de 1.0 (al inicio) a 0.0 (al final).
        scale_factor = 1.0 - t_comp;
    }

    // 3. Aplicar la deformación (escalado uniforme desde el origen)
    vertex_objectspace = vertex * scale_factor;
    
    // 4. Deformar la normal (con la inversa del factor de escala)
    // Añadimos 0.0001 para evitar dividir por cero
    normal_objectspace = normal / (scale_factor + 0.0001);

    // ==============================================================

    // Calcular la normal en Eye Space (con la normal deformada)
    vec3 N = normalize(normalMatrix * normal_objectspace);

    // Calcular el color:
    // El enunciado pide "gris con componentes Z de la normal"
    // Esto MODIFICA la línea de color por defecto de tu esqueleto.
    frontColor = vec4(N.z, N.z, N.z, 1.0);

    // Pasar la coordenada de textura
    vtexCoord = texCoord;

    // Calcular la posición final (con el vértice deformado)
    gl_Position = modelViewProjectionMatrix * vec4(vertex_objectspace, 1.0);
}