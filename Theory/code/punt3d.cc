#include <iostream>

int main() {
    int tipus;
    float a,b,c,d;
    float x,y,z,w;
    
    std::cout << "Selecciona el tipus de matriu: " << std::endl;
    std::cout << "Tipus 1: \n a 0 0 0\n 0 b 0 0\n 0 0 c 0\n 0 0 0 d\n Tipus 2: \n 1 0 0 a\n 0 1 0 b\n 0 0 1 c\n 0 0 0 d\n Tipus:";
    std::cin >> tipus;
    
    std::cout << "Valors: ";
    std::cin >> a >> b >> c >> d;
    
    std::cout << "Introdueix valors del punt (x,y,z,w): \n";
    std::cin >> x >> y >> z >> w;

    if(tipus == 1){
        x = x*a;
        y = y*b;
        z = z*c;
        w = w*d;
    
        x /= w;
        y /= w;
        z /= w;
    }
    else {
        x = x*1.0 + w*a;
        y = y*1.0 + w*b;
        z = z*1.0 + w*c;
        w = w*d;
        
        x /= w;
        y /= w;
        z /= w;
    }
    
    std::cout << "Punt resultant: " << x << " , " << y << " , " << z << std::endl;

    return 0;
}