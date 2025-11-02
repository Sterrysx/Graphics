#ifndef _SHADOWVOLUME_H
#define _SHADOWVOLUME_H

#include "plugin.h" 
#include "glwidget.h"
#include "Geometry.h"
#include "Utility.h"
#include <QOpenGLShaderProgram>

typedef vector <Index> IndexVector;

class ShadowVolume: public QObject, public Plugin {
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "Plugin") 
	Q_INTERFACES(Plugin)

	public:
		void onPluginLoad();
		void onObjectAdd();
		bool paintGL();
		void keyPressEvent(QKeyEvent *);

	private:
		Point lightPosition;
		bool showShadowVolume;
		float distance, maxDistance;
		QOpenGLShaderProgram * program;
		vector <float> shadowVertices;
		IndexVector shadowIndices;
		GLuint shadowVertexArray, shadowPositionBuffer, shadowIndexBuffer;
		void computeShadowVolume();
};

#endif
