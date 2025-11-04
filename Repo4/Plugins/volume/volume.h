#ifndef _VOLUME_H
#define _VOLUME_H

#include "plugin.h" 

class Volume: public QObject, public Plugin
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "Plugin") 
	Q_INTERFACES(Plugin)

	public:
		void onPluginLoad();
		void preFrame();
		void postFrame();
		void onObjectAdd();
		bool drawScene();
		bool drawObject(int);
		bool paintGL();
		void keyPressEvent(QKeyEvent *);
		void mouseMoveEvent(QMouseEvent *);
	
	private:
		Point faceCentroid(const Object & object, const Face & face);
		float faceArea(const Object & object, const Face & face);
		float objectVolume(const Object & object);
};

#endif
