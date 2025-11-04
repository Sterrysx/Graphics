#include "plugin.h"
#include <utility>
#include <vector>
#include <map>

using namespace std;

typedef int Index;
typedef pair <Index, Index> Edge;
typedef vector <Edge> EdgeVector;
typedef vector <Face> FaceVector;
typedef vector <Vertex> VertexVector;
typedef pair <VertexVector, FaceVector> Volume;

class Geometry {
	public:
		// Retorna el centroide d'una cara.
		static Point centroid(const VertexVector & vertices,
			const Face & face);

		// Retorna el vector normal a una cara.
		static Vector surfaceNormal(const VertexVector & vertices,
			const Face & face);

		// Retorna el vector de cares visibles d'un objecte des d'un punt.
		static FaceVector frontFaces(const Object & object, const Point & point);

		// Retorna el vector d'arestes que només apareixen una vegada
		// en un vector de cares. Preserva l'ordre dels vèrtexs de les arestes.
		static EdgeVector silhouette(const FaceVector & faces);
		
		// Retorna el volum de l'ombra, limitada a una distància,
		// projectada per un objecte respecte d'una llum.
		static Volume shadowVolume(const Object & object, const Point & light,
			float distance);
};
