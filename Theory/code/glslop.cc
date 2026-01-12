#include <iostream>
#include <cmath>    // For std::floor, std::sqrt

// --- VECTOR STRUCTURE FOR CROSS PRODUCT ---
struct Vec3 {
    double x, y, z;

    // Cross Product Formula:
    // Rx = Ay*Bz - Az*By
    // Ry = Az*Bx - Ax*Bz
    // Rz = Ax*By - Ay*Bx
    Vec3 cross(const Vec3& v) const {
        return {
            y * v.z - z * v.y,
            z * v.x - x * v.z,
            x * v.y - y * v.x
        };
    }
};

// --- GLSL FUNCTION: MIX ---
// Formula: x * (1 - a) + y * a
double glsl_mix(double x, double y, double a) {
    return x * (1.0 - a) + y * a;
}

// --- GLSL FUNCTION: MOD ---
// Formula: x - y * floor(x / y)
double glsl_mod(double x, double y) {
    return x - y * std::floor(x / y);
}

int main() {
    int choice;

    std::cout << "=== GLSL & VECTOR SOLVER ===\n";
    std::cout << "1. mix(x, y, a)\n";
    std::cout << "2. mod(x, y)\n";
    std::cout << "3. cross(A, B)\n";
    std::cout << "Select option (1-3): ";
    std::cin >> choice;

    if (choice == 1) {
        // --- MIX ---
        double x, y, a;
        std::cout << "\n--- MIX Solver ---\n";
        std::cout << "Enter x (start value): "; std::cin >> x;
        std::cout << "Enter y (end value):   "; std::cin >> y;
        std::cout << "Enter a (alpha 0..1):  "; std::cin >> a;

        double result = glsl_mix(x, y, a);
        std::cout << "----------------------\n";
        std::cout << "Result: " << result << "\n";
        std::cout << "----------------------\n";
    } 
    else if (choice == 2) {
        // --- MOD ---
        double x, y;
        std::cout << "\n--- MOD Solver ---\n";
        std::cout << "Enter x (numerator):   "; std::cin >> x;
        std::cout << "Enter y (denominator): "; std::cin >> y;

        double result = glsl_mod(x, y);
        std::cout << "----------------------\n";
        std::cout << "Result: " << result << "\n";
        std::cout << "----------------------\n";
    } 
    else if (choice == 3) {
        // --- CROSS PRODUCT ---
        Vec3 A, B;
        std::cout << "\n--- CROSS PRODUCT Solver ---\n";
        std::cout << "Enter Vector A (x y z): "; 
        std::cin >> A.x >> A.y >> A.z;
        
        std::cout << "Enter Vector B (x y z): "; 
        std::cin >> B.x >> B.y >> B.z;

        Vec3 res = A.cross(B);

        std::cout << "----------------------\n";
        std::cout << "Result: (" << res.x << ", " << res.y << ", " << res.z << ")\n";
        std::cout << "----------------------\n";
    }
    else {
        std::cout << "Invalid selection.\n";
    }

    return 0;
}