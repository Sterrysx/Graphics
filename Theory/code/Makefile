# Variables del compilador
CXX = g++
CXXFLAGS = -Wall -std=c++11

# Noms dels executables finals
PROG1 = parametritzacio_equirectangular
PROG2 = lumens
PROG3 = stencil_buffer
PROG4 = shadow_rays
PROG5 = projectors
PROG6 = znear_zfar
PROG7 = punt3d
PROG8 = snell
PROG9 = glslop

# La regla "all" compila tots els programes
all: $(PROG1) $(PROG2) $(PROG3) $(PROG4) $(PROG5) $(PROG6) $(PROG7) $(PROG8) $(PROG9)

# Regla 1
$(PROG1): parametritzacio_equirectangular.cc
	$(CXX) $(CXXFLAGS) -o $(PROG1) parametritzacio_equirectangular.cc

# Regla 2
$(PROG2): lumens.cc
	$(CXX) $(CXXFLAGS) -o $(PROG2) lumens.cc

# Regla 3
$(PROG3): stencil_buffer.cc
	$(CXX) $(CXXFLAGS) -o $(PROG3) stencil_buffer.cc

# Regla 4
$(PROG4): shadow_rays.cc
	$(CXX) $(CXXFLAGS) -o $(PROG4) shadow_rays.cc

# Regla 5
$(PROG5): projectors.cc
	$(CXX) $(CXXFLAGS) -o $(PROG5) projectors.cc

# Regla 6
$(PROG6): znear_zfar.cc
	$(CXX) $(CXXFLAGS) -o $(PROG6) znear_zfar.cc

# Regla 7 (NOU: Punt 3D)
$(PROG7): punt3d.cc
	$(CXX) $(CXXFLAGS) -o $(PROG7) punt3d.cc

# Regla 8 (NOU: Llei de Snell)
$(PROG8): snell.cc
	$(CXX) $(CXXFLAGS) -o $(PROG8) snell.cc

# Regla 9 (NOU: Operacions GLSL)
$(PROG9): glslop.cc
	$(CXX) $(CXXFLAGS) -o $(PROG9) glslop.cc

# Neteja: esborra tots els executables
clean:
	rm -f $(PROG1) $(PROG2) $(PROG3) $(PROG4) $(PROG5) $(PROG6) $(PROG7) $(PROG8) $(PROG9)