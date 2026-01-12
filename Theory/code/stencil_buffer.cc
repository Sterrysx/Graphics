#include <iostream>
#include <string>
#include <vector>

// --- ENUMS FOR READABILITY ---
enum StencilOp {
    OP_KEEP = 0,    // GL_KEEP
    OP_ZERO = 1,    // GL_ZERO
    OP_REPLACE = 2, // GL_REPLACE
    OP_INCR = 3,    // GL_INCR
    OP_DECR = 4,    // GL_DECR
    OP_INVERT = 5   // GL_INVERT
};

enum StencilFunc {
    FUNC_NEVER = 0,
    FUNC_LESS = 1,
    FUNC_LEQUAL = 2,
    FUNC_GREATER = 3,
    FUNC_GEQUAL = 4,
    FUNC_EQUAL = 5,
    FUNC_NOTEQUAL = 6,
    FUNC_ALWAYS = 7
};

// --- HELPER FUNCTIONS ---

std::string getOpName(int op) {
    std::vector<std::string> names = {"GL_KEEP", "GL_ZERO", "GL_REPLACE", "GL_INCR", "GL_DECR", "GL_INVERT"};
    if(op >= 0 && op < names.size()) return names[op];
    return "UNKNOWN";
}

// Perform the Stencil Test Comparison
// Formula: ( ref & mask ) FUNC ( storedVal & mask )
bool checkStencil(int func, int ref, int storedVal, int mask) {
    int maskedRef = ref & mask;
    int maskedVal = storedVal & mask;

    switch (func) {
        case FUNC_NEVER:    return false;
        case FUNC_LESS:     return maskedRef < maskedVal;
        case FUNC_LEQUAL:   return maskedRef <= maskedVal;
        case FUNC_GREATER:  return maskedRef > maskedVal;
        case FUNC_GEQUAL:   return maskedRef >= maskedVal;
        case FUNC_EQUAL:    return maskedRef == maskedVal;
        case FUNC_NOTEQUAL: return maskedRef != maskedVal;
        case FUNC_ALWAYS:   return true;
        default:            return false;
    }
}

// Apply the Operation (Update the buffer value)
int applyStencilOp(int opCode, int currentStencil, int refValue) {
    switch (opCode) {
        case OP_KEEP:    return currentStencil;
        case OP_ZERO:    return 0;
        case OP_REPLACE: return refValue;
        // Note: Real OpenGL clamps these values (e.g., at 255), we keep it simple here
        case OP_INCR:    return currentStencil + 1; 
        case OP_DECR:    return currentStencil - 1;
        case OP_INVERT:  return ~currentStencil;
        default: return currentStencil;
    }
}

int main() {
    // --- VARIABLES ---
    double depthBufferVal, newFragmentZ;
    int stencilBufferVal, stencilRef, stencilMask;
    int funcCode; // GL_ALWAYS, GL_EQUAL etc.
    int opSfail, opDpfail, opDppass;

    std::cout << "--- Advanced Stencil/Depth Simulator (With Mask) ---\n\n";

    // 1. BUFFER STATES
    std::cout << "Enter current Depth Buffer value (e.g., 0.5): ";
    std::cin >> depthBufferVal;
    std::cout << "Enter current Stencil Buffer value (e.g., 4): ";
    std::cin >> stencilBufferVal;
    std::cout << "Enter New Fragment Z (e.g., 0.6): ";
    std::cin >> newFragmentZ;

    // 2. STENCIL CONFIG
    std::cout << "\n--- Stencil Configuration (glSencilTest)---\n";
    std::cout << "Comparison Function (0=NEVER, 1=LESS, 5=EQUAL, 7=ALWAYS): ";
    std::cin >> funcCode;

    std::cout << "Reference Value (ref): ";
    std::cin >> stencilRef;

    std::cout << "Mask Value (mask) [Enter 255 for standard/no-filter]: ";
    std::cin >> stencilMask;

    // 3. OPERATIONS
    // UPDATED LINE BELOW
    std::cout << "\n--- Stencil Operations (glStencilOp) (0=KEEP, 1=ZERO, 2=REPLACE, 3=INCR, 4=DECR, 5=INVERT) ---\n";
    
    std::cout << "sfail (Stencil Fail): ";  std::cin >> opSfail;
    std::cout << "dpfail (Depth Fail): ";   std::cin >> opDpfail;
    std::cout << "dppass (Depth Pass): ";   std::cin >> opDppass;

    // --- LOGIC TRACE ---
    std::cout << "\n---------------- EXECUTION ----------------\n";

    // STEP A: Stencil Test
    // We apply the mask here before checking
    bool stencilPass = checkStencil(funcCode, stencilRef, stencilBufferVal, stencilMask);

    std::cout << "1. Stencil Test: ( " << stencilRef << " & " << stencilMask << " ) vs ( " 
              << stencilBufferVal << " & " << stencilMask << " )\n";
    std::cout << "   -> Masked Values: " << (stencilRef & stencilMask) << " vs " << (stencilBufferVal & stencilMask) << "\n";
    std::cout << "   -> Result: " << (stencilPass ? "PASS" : "FAIL") << "\n";

    if (!stencilPass) {
        // Stencil Failed
        std::cout << "   -> Action: Executing sfail (" << getOpName(opSfail) << ")\n";
        stencilBufferVal = applyStencilOp(opSfail, stencilBufferVal, stencilRef);
    } else {
        // STEP B: Depth Test
        bool depthPass = (newFragmentZ < depthBufferVal); // Default GL_LESS behavior
        std::cout << "2. Depth Test (" << newFragmentZ << " < " << depthBufferVal << "): " 
                  << (depthPass ? "PASS" : "FAIL") << "\n";

        if (depthPass) {
            // Both Passed
            std::cout << "   -> Action: Executing dppass (" << getOpName(opDppass) << ")\n";
            stencilBufferVal = applyStencilOp(opDppass, stencilBufferVal, stencilRef);
        } else {
            // Stencil Passed, Depth Failed
            std::cout << "   -> Action: Executing dpfail (" << getOpName(opDpfail) << ")\n";
            stencilBufferVal = applyStencilOp(opDpfail, stencilBufferVal, stencilRef);
        }
    }

    // --- RESULT ---
    std::cout << "\n---------------- RESULT ----------------\n";
    std::cout << "FINAL STENCIL VALUE: " << stencilBufferVal << "\n";
    std::cout << "----------------------------------------\n";

    return 0;
}
