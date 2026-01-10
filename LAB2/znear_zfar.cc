#include <iostream>
#include <cmath>   // For std::abs, std::round
#include <limits>  // For std::numeric_limits

// --- HELPER: Round to nearest 0.05 ---
double roundTo05(double val) {
    if (val == INFINITY) return INFINITY;
    // Divide by 0.05, round to nearest integer, then multiply back
    return std::round(val / 0.05) * 0.05;
}

// --- FUNCTION 1: Solve using Standard Projection Matrix (Row 3) ---
void solveStandardMatrix() {
    double A, B;

    std::cout << "\n=== OPTION 1: STANDARD PROJECTION MATRIX ===\n";
    std::cout << "Focus on the 3rd ROW of your matrix:\n\n";
    std::cout << "    |  x    0    0    0  |\n";
    std::cout << "    |  0    y    0    0  |\n";
    std::cout << "    |  0    0    A    B  |  <--- Enter these values\n";
    std::cout << "    |  0    0   -1    0  |\n\n";

    std::cout << "Enter value for A (3rd value, row 3): ";
    std::cin >> A;
    std::cout << "Enter value for B (4th value, row 3): ";
    std::cin >> B;

    // Calculations
    double absA = std::abs(A);
    double absB = std::abs(B);
    
    double znear = absB / (absA + 1.0);
    double zfar = 0.0;

    if (std::abs(absA - 1.0) < 0.00001) {
        zfar = INFINITY; 
    } else {
        zfar = znear * (absA + 1.0) / (absA - 1.0);
    }

    // --- ROUNDING ---
    znear = roundTo05(znear);
    if (zfar != INFINITY) {
        zfar = roundTo05(zfar);
    }

    std::cout << "\n--- RESULTS (Standard) ---\n";
    std::cout << "[v] Z-Near: " << znear << "\n";
    if (zfar == INFINITY) std::cout << "[v] Z-Far:  INFINITY\n";
    else                  std::cout << "[v] Z-Far:  " << zfar << "\n";
    std::cout << "--------------------------\n";
}

// --- FUNCTION 2: Solve using Inverse Projection Matrix (Row 4) ---
void solveInverseMatrix() {
    double C, D;

    std::cout << "\n=== OPTION 2: INVERSE PROJECTION MATRIX ===\n";
    std::cout << "Focus on the BOTTOM ROW (Row 4) of your matrix:\n\n";
    std::cout << "    | ...  ...   ...    ... |\n";
    std::cout << "    | ...  ...   ...    ... |\n";
    std::cout << "    | ...  ...   ...    ... |\n";
    std::cout << "    |  0    0     C      D  |  <--- Enter these values\n\n";

    std::cout << "Enter value for C (3rd value, bottom row): ";
    std::cin >> C;
    std::cout << "Enter value for D (4th value, bottom row): ";
    std::cin >> D;

    // Calculations
    double absC = std::abs(C);
    double absD = std::abs(D);

    double znear = 1.0 / (absD + absC);
    double zfar = 0.0;

    if (std::abs(absD - absC) < 0.00001) {
        zfar = INFINITY;
    } else {
        zfar = 1.0 / std::abs(absD - absC);
    }

    // --- ROUNDING ---
    znear = roundTo05(znear);
    if (zfar != INFINITY) {
        zfar = roundTo05(zfar);
    }

    std::cout << "\n--- RESULTS (Inverse) ---\n";
    std::cout << "[v] Z-Near: " << znear << "\n";
    if (zfar == INFINITY) std::cout << "[v] Z-Far:  INFINITY\n";
    else                  std::cout << "[v] Z-Far:  " << zfar << "\n";
    std::cout << "-------------------------\n";
}

// --- MAIN MENU ---
int main() {
    int choice;

    std::cout << "========================================\n";
    std::cout << "    OPENGL CLIPPING PLANE CALCULATOR    \n";
    std::cout << "========================================\n\n";
    
    std::cout << "Which matrix do you have?\n";
    std::cout << "1. Standard Projection Matrix (I have values A and B)\n";
    std::cout << "2. Inverse Projection Matrix  (I have values C and D)\n";
    std::cout << "0. Exit\n";
    
    std::cout << "\nSelect option (1 or 2): ";
    std::cin >> choice;

    switch(choice) {
        case 1:
            solveStandardMatrix();
            break;
        case 2:
            solveInverseMatrix();
            break;
        case 0:
            std::cout << "Exiting...\n";
            break;
        default:
            std::cout << "Invalid selection.\n";
            break;
    }

    return 0;
}