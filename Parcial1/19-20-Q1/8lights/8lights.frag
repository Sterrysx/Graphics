#version 330 core

// --- INPUT (from the Vertex Shader) ---
in vec2 vtexCoord;
in vec3 v_normal_eye;   // Added from cheatsheet
in vec3 v_position_eye; // Added from cheatsheet

// --- OUTPUT ---
out vec4 fragColor;

// --- UNIFORMS (Added for "8lights") ---
// Standard lighting uniforms (from cheatsheet)
uniform vec4 lightDiffuse;
uniform vec4 lightSpecular;
uniform vec4 matDiffuse;
uniform vec4 matSpecular;
uniform float matShininess;

// Uniforms to get light positions
uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;
uniform mat4 viewMatrix; // To convert lights from World to Eye space

void main()
{
    // ==============================================================
    // == STEP 3 (FS) - "8lights" Logic
    // ==============================================================

    // --- a. Initialize ---
    // Start with black, as the formula ignores ambient
    vec4 finalColor = vec4(0.0, 0.0, 0.0, 1.0);

    // --- b. Define the 8 light positions in World Space ---
    // (We get these from the bounding box corners)
    vec3 lightPos_world[8];
    lightPos_world[0] = vec3(boundingBoxMin.x, boundingBoxMin.y, boundingBoxMin.z); // 0
    lightPos_world[1] = vec3(boundingBoxMax.x, boundingBoxMin.y, boundingBoxMin.z); // 1
    lightPos_world[2] = vec3(boundingBoxMin.x, boundingBoxMax.y, boundingBoxMin.z); // 2
    lightPos_world[3] = vec3(boundingBoxMax.x, boundingBoxMax.y, boundingBoxMin.z); // 3
    lightPos_world[4] = vec3(boundingBoxMin.x, boundingBoxMin.y, boundingBoxMax.z); // 4
    lightPos_world[5] = vec3(boundingBoxMax.x, boundingBoxMin.y, boundingBoxMax.z); // 5
    lightPos_world[6] = vec3(boundingBoxMin.x, boundingBoxMax.y, boundingBoxMax.z); // 6
    lightPos_world[7] = vec3(boundingBoxMax.x, boundingBoxMax.y, boundingBoxMax.z); // 7

    // --- c. Get N and V (constants for all lights) ---
    vec3 N = normalize(v_normal_eye);
    vec3 V = normalize(-v_position_eye); // Vector to viewer

    // --- d. Start the loop ---
    for (int i = 0; i < 8; i++)
    {
        // --- e. Transform this light's pos to Eye Space ---
        vec3 lightPos_eye = vec3(viewMatrix * vec4(lightPos_world[i], 1.0));

        // --- f. Calculate L and R for this light ---
        vec3 L = normalize(lightPos_eye - v_position_eye);
        vec3 R = reflect(-L, N);

        // --- g. Calculate Diffuse & Specular (per formula) ---
        float NdotL = max(0.0, dot(N, L));
        
        // Diffuse term (divided by 2)
        vec4 dif = (matDiffuse * lightDiffuse * NdotL) / 2.0;

        // Specular term
        vec4 spec = vec4(0.0);
        if (NdotL > 0.0) // only add specular if light hits
        {
            float RdotV = pow(max(0.0, dot(R, V)), matShininess);
            spec = matSpecular * lightSpecular * RdotV;
        }

        // --- h. Accumulate ---
        finalColor += dif + spec;
    }
    
    finalColor.a = 1.0; // Ensure alpha is 1

    // ==============================================================


    // --- Final Assignment ---
    fragColor = finalColor;
}