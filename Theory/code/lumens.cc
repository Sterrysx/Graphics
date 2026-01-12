#include <iostream>
#include <cmath>
#include <iomanip>   

int main() {
    const double PI = acos(-1.0); 

    // Dades del problema
    double flux_luminos;
    double radi;

    std::cout << "flux luminos (LUMENS):\n";
    std::cin >> flux_luminos;

    std::cout << "radi (R):\n";
    std::cin >> radi;

    int n;
    std::cout << "Area: (1-> Esfera || 2-> SemiEsfera || 3-> Casquet esfèric)\n";
    std::cin >> n;

    double area = 0.0;

    switch(n) {
        case 1:
            area = 4.0 * PI * radi * radi;
            break;

        case 2:
            area = 2.0 * PI * radi * radi;
            break;

        case 3:
            double h;
            std::cout << "Altura h:\n";
            std::cin >> h;
            area = 2.0 * PI * radi * h;
            break;

        default:
            std::cout << "Opcio incorrecta\n";
            return 1;
    }

    // Il·luminància
    double illuminancia = flux_luminos / area;

    // Sortida amb 10 decimals
    std::cout << std::fixed << std::setprecision(10);
    std::cout << "Il·luminancia resultant: " << illuminancia << std::endl;

    return 0;
}