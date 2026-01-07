#include "Geometry.h"

Point Geometry::centroid(const VertexVector & vertices, const Face & face) {
	int n = face.numVertices();
	Point point = Point(0, 0, 0);

	for (int i = 0; i < n; i++) {
		point += vertices[face.vertexIndex(i)].coord();
	}
	
	return point / n;
}

Vector Geometry::surfaceNormal(const VertexVector & vertices,
		const Face & face) {
	const Point & p0 = vertices[face.vertexIndex(0)].coord();
	const Point & p1 = vertices[face.vertexIndex(1)].coord();
	const Point & p2 = vertices[face.vertexIndex(2)].coord();
	return Vector::crossProduct(p1 - p0, p2 - p0).normalized();
}

FaceVector Geometry::frontFaces(const Object & object, const Point & point) {
	FaceVector faces;

	for (const Face & face : object.faces()) {
		const Vector & normal = face.normal();
		const Point & center = centroid(object.vertices(), face);
		const Vector & direction = point - center;
		float product = Vector::dotProduct(normal, direction);
		if (product > 0) faces.push_back(face);
	}
	
	return faces;
}

// FIXME Si les cares no reutilitzen vèrtexs cap aresta és repetida:
// cal comprovar que les coordenades siguin iguals.
EdgeVector Geometry::silhouette(const FaceVector & faces) {
	typedef pair <bool, Edge> Value;
	map <Edge, Value> repeated;
	EdgeVector edges;
	
	for (const Face & face : faces) {
		int n = face.numVertices();
		for (int index = 0; index < n; index++) {
			Index i = face.vertexIndex(index);
			Index j = face.vertexIndex((index + 1) % n);
			const Edge key = Edge(min(i, j), max(i, j));
			bool found = repeated.find(key) != repeated.end();
			if (found) repeated[key].first = true;
			else repeated[key] = Value(false, Edge(i, j));
		}
	}
	
	for (const pair <Edge, Value> & item : repeated)
		if (! item.second.first)
			edges.push_back(item.second.second);
	
	return edges;
}

Volume Geometry::shadowVolume(const Object & object, const Point & light,
		float distance) {
	const VertexVector & objectVertices = object.vertices();
	const FaceVector & objectFaces = Geometry::frontFaces(object, light);
	map <Index, Index> objectIndices, shadowIndices;
	VertexVector shadowVertices;
	FaceVector shadowFaces;

	// Vèrtexs i cares perpendiculars.
	for (const Face & face : objectFaces) {
		for (int i = 0; i < face.numVertices(); i++) {
			Index index = face.vertexIndex(i);
			if (objectIndices.find(index) == objectIndices.end()) {
				Point p = objectVertices[index].coord();
				Point q = p + (p - light).normalized() * distance;
				objectIndices[index] = shadowVertices.size();
				shadowVertices.push_back(Vertex(p));
				shadowIndices[index] = shadowVertices.size();
				shadowVertices.push_back(Vertex(q));
			}
		}
		
		shadowFaces.push_back(Face(
			objectIndices[face.vertexIndex(0)],
			objectIndices[face.vertexIndex(1)],
			objectIndices[face.vertexIndex(2)]));
		shadowFaces.push_back(Face(
			shadowIndices[face.vertexIndex(0)],
			shadowIndices[face.vertexIndex(2)],
			shadowIndices[face.vertexIndex(1)]));
	}
	
	// Cares paral·leles.
	for (const Edge & edge : Geometry::silhouette(objectFaces)) {
		shadowFaces.push_back(Face(
			shadowIndices[edge.second],
			objectIndices[edge.second],
			shadowIndices[edge.first]));
		shadowFaces.push_back(Face(
			objectIndices[edge.second],
			objectIndices[edge.first],
			shadowIndices[edge.first]));
	}

	return Volume(shadowVertices, shadowFaces);
}
