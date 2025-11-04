#version 330 core

// --- INPUT (from the Vertex Shader) ---
in vec2 vtexCoord;
in vec3 v_normal_eye;   // <-- From "Pass Normal"
in vec3 v_position_eye; // <-- From "Pass Eye Position"

// --- UNIFORMS (Add as needed) ---
// Problem-specific uniforms
uniform int n = 4;
const float pi = 3.141592;

// Standard lighting uniforms (from cheatsheet)
uniform vec4 lightDiffuse;
uniform vec4 lightSpecular;
uniform vec4 matDiffuse;
uniform vec4 matSpecular;
uniform float matShininess;

// --- OUTPUT ---
out vec4 fragColor;

void main()
{
    // ==============================================================
    // == STEP 3 (FS) - "Nlights" Logic
    // ==============================================================

    // --- a. Initialize ---
    // Start with black, since there is no ambient term
    vec4 finalColor = vec4(0.0, 0.0, 0.0, 1.0);
    
    // --- b. Get N and V (constants for all lights) ---
    vec3 N = normalize(v_normal_eye);
    vec3 V = normalize(-v_position_eye); // Vector to viewer

    // --- c. Get the formula's divisor ---
    float sqrt_n = sqrt(float(n));

    // --- d. Start the loop ---
    for (int i = 0; i < n; i++)
    {
        // --- e. Calculate this light's position ---
        float angle = 2.0 * pi * float(i) / float(n);
        vec3 lightPos_eye = vec3(10.0 * cos(angle), 10.0 * sin(angle), 0.0);

        // --- f. Calculate L and R for this light ---
        vec3 L = normalize(lightPos_eye - v_position_eye);
        vec3 R = reflect(-L, N);

        // --- g. Calculate Diffuse & Specular (per formula) ---
        float NdotL = max(0.0, dot(N, L));
        
        // Diffuse term (divided by sqrt(n))
        vec4 dif = (matDiffuse * lightDiffuse * NdotL) / sqrt_n;

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