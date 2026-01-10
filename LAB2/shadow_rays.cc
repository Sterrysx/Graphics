#include <iostream>

int main() {
    int width, height;
    int numLights;

    std::cout << "Mida imatge (VALOR x VALOR)\n";
    std::cin >> width >> height;


    std::cout << "Nombre de llums puntuals: \n";
    std::cin >> numLights;

    // Nombre de pixels
    int pixels = width * height;

    // Shadow rays en Ray Tracing classic
    int shadowRays = pixels * numLights;

    std::cout << "Nombre de shadow rays: " << shadowRays << std::endl;

    return 0;
}