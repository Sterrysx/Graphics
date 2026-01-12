#include <iostream>
#include <cmath>
#include <iomanip> // Per limitar decimals

using namespace std;

int main() {
    double theta, psi;

    // 1. Input dels valors
    cout << "Introdueix THETA (Longitud) en radians: ";
    cin >> theta;
    cout << "Introdueix PSI (Latitud) en radians: ";
    cin >> psi;

    // 2. Els Càlculs (Fórmules Oficials)
    // Assumim radi = 1
    double y = sin(psi);
    double r = cos(psi); // Radi projectat al pla XZ
    
    double x = r * sin(theta);
    double z = r * cos(theta);

    // 3. Output bonic (2 decimals com a l'examen)
    cout << fixed << setprecision(2);
    cout << "\nRESULTAT:" << endl;
    cout << "-----------------------" << endl;
    cout << "(" << x << ", " << y << ", " << z << ")" << endl;
    cout << "-----------------------" << endl;

    return 0;
}