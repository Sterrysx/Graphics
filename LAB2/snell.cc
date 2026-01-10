#include <iostream>
#include <cmath>
#include <iomanip>

// --- VECTOR STRUCTURE ---
struct Vec3 {
    double x, y, z;
    double length() const { return std::sqrt(x*x + y*y + z*z); }
    
    Vec3 normalize() const {
        double len = length();
        if (len == 0) return {0,0,0};
        return {x/len, y/len, z/len};
    }

    double dot(Vec3 v) const { return x*v.x + y*v.y + z*v.z; }
    Vec3 operator*(double s) const { return {x*s, y*s, z*s}; }
    Vec3 operator+(Vec3 v) const { return {x+v.x, y+v.y, z+v.z}; }
};

// --- SOLVER FUNCTION ---
void solveRefraction(Vec3 L_raw, Vec3 N, double n1, double n2, std::string label) {
    // 1. Setup Vectors
    // The Light vector L points TO the light.
    // The Incident vector I points INTO the surface (Opposite to L).
    Vec3 I = L_raw.normalize() * -1.0; 

    double eta = n1 / n2;
    double N_dot_I = N.dot(I); 
    double k = 1.0 - eta * eta * (1.0 - N_dot_I * N_dot_I);

    std::cout << "\n--- Calculation Mode: " << label << " ---\n";
    std::cout << "Using L = (" << L_raw.x << ", " << L_raw.y << ")\n";
    
    if (k < 0.0) {
        std::cout << "[!] Result: Total Internal Reflection (No transmission)\n";
    } else {
        // T = eta * I + (eta * cosTheta - sqrt(k)) * N
        // Since N=(0,1,0), the X component of T is simply: T.x = eta * I.x
        Vec3 T = I * eta + N * (eta * -N_dot_I - std::sqrt(k));
        
        std::cout << std::fixed << std::setprecision(6);
        std::cout << ">>> T.x (Result): " << T.x << "\n";
    }
}

int main() {
    Vec3 L_input;
    double n1, n2;

    std::cout << "=== REFRACTION SOLVER (PRECISION FIX) ===\n";
    std::cout << "Enter Light Vector L (x y): "; 
    std::cin >> L_input.x >> L_input.y;
    L_input.z = 0; // Assume 2D problem in 3D space

    std::cout << "Enter n1 (Current Medium): "; std::cin >> n1;
    std::cout << "Enter n2 (Target Medium):  "; std::cin >> n2;

    Vec3 N = {0, 1, 0}; // Standard normal

    // --- STRATEGY 1: Standard (Normalize Input) ---
    // This assumes the inputs 0.44 and 0.90 are just raw direction ratios.
    solveRefraction(L_input, N, n1, n2, "Standard (Normalized Input)");

    // --- STRATEGY 2: Fix based on Y (Common Exam Trick) ---
    // This assumes Y=0.90 is EXACT, and X was rounded.
    // We recalculate X = sqrt(1 - y^2)
    if (std::abs(L_input.y) <= 1.0) {
        double exactX = std::sqrt(1.0 - L_input.y * L_input.y);
        // Match the sign of the original input
        if (L_input.x < 0) exactX = -exactX;
        
        Vec3 L_fixedY = {exactX, L_input.y, 0};
        solveRefraction(L_fixedY, N, n1, n2, "Exam Logic (Trust Y, Recalc X)");
    }

    std::cout << "\n-------------------------------------------------\n";
    std::cout << "NOTE: If the results differ, 'Exam Logic' is usually\n";
    std::cout << "the correct one for UPC/Atenea/Moodle quizzes.\n";
    std::cout << "-------------------------------------------------\n";

    return 0;
}