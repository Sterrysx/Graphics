#include <iostream>
#include <iomanip> // Used for setprecision to format the output

/**
 * Solves the projector irradiance/flux problem.
 * * Physics Principles:
 * 1. Radiant Flux (Flux Radiant): Total power emitted. Constant if the projector doesn't change.
 * 2. Irradiance (Irradiància): Power per unit area. Inversely proportional to Area.
 * Formula: E = Flux / Area
 */
void solveProjectorProblem(double widthA, double heightA, double widthB, double heightB) {
    std::cout << "\n--- STEP 1: CALCULATE AREAS ---\n";
    
    double areaA = widthA * heightA;
    double areaB = widthB * heightB;

    std::cout << "Screen A: " << widthA << "m x " << heightA << "m = " << areaA << " m^2\n";
    std::cout << "Screen B: " << widthB << "m x " << heightB << "m = " << areaB << " m^2\n\n";

    std::cout << "--- STEP 2: ANALYZE RADIANT FLUX ---\n";
    std::cout << "Concept: The same projector is used.\n";
    std::cout << "Result: Radiant Flux is CONSTANT (Flux A == Flux B).\n\n";

    std::cout << "--- STEP 3: ANALYZE IRRADIANCE ---\n";
    // Since Flux is constant, Irradiance is inversely proportional to Area.
    // E_new = E_old * (Area_old / Area_new)
    
    if (areaB == 0) {
        std::cerr << "Error: Area of Screen B is 0. Cannot divide by zero.\n";
        return;
    }

    double ratio = areaA / areaB;
    double percentage = ratio * 100.0;

    std::cout << "Formula: Ratio = Area_A / Area_B\n";
    std::cout << "Calculation: " << areaA << " / " << areaB << " = " << ratio << "\n";
    
    std::cout << std::fixed << std::setprecision(0); // Remove decimal places for clean %
    std::cout << "Result: Irradiance on Screen B is " << percentage << "% of Irradiance on Screen A.\n\n";

    std::cout << "--- VERIFYING OPTIONS ---\n";
    if (areaA != areaB) {
        std::cout << "[x] Irradiance is NOT the same (Areas are different).\n";
    }
    std::cout << "[v] Irradiance on B is " << percentage << "% of Irradiance on A.\n";
}

int main() {
    double x1, y1, x2, y2;

    std::cout << "--- Projector Physics Calculator ---\n";
    
    // Input for Screen A
    std::cout << "Enter width of Screen A (x1): ";
    std::cin >> x1;
    std::cout << "Enter height of Screen A (y1): ";
    std::cin >> y1;

    // Input for Screen B
    std::cout << "Enter width of Screen B (x2): ";
    std::cin >> x2;
    std::cout << "Enter height of Screen B (y2): ";
    std::cin >> y2;

    // Run calculation
    solveProjectorProblem(x1, y1, x2, y2);

    return 0;
}