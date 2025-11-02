#include "ShadowVolume.h"

void ShadowVolume::computeShadowVolume() {
	GLWidget & widget = *glwidget();
	widget.makeCurrent();
	
	if ( widget.scene()->objects().size() > 0) {
		const Object & object = widget.scene()->objects()[0];
		Volume volume = Geometry::shadowVolume(object, lightPosition, distance);
		cout << "Light position: " << lightPosition
			 << "Shadow volume face count: " << volume.second.size() << endl
			 << "Shadow volume depth: " << distance << endl;
		
		shadowVertices.clear();
		for (const Vertex & vertex : volume.first)
			for (int i = 0; i < 3; i++)
				shadowVertices.push_back(vertex.coord()[i]);
		shadowIndices.clear();
		for (const Face & face : volume.second)
			for (int i = 0; i < 3; i++)
				shadowIndices.push_back(face.vertexIndex(i));
		
		widget.glBindVertexArray(shadowVertexArray);
		widget.glBindBuffer(GL_ARRAY_BUFFER, shadowPositionBuffer);
		widget.glBufferData(GL_ARRAY_BUFFER, sizeof(float) * shadowVertices.size(), &shadowVertices[0], GL_STATIC_DRAW);
		widget.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0); 
		widget.glEnableVertexAttribArray(0);
		widget.glBindBuffer(GL_ARRAY_BUFFER, 0);
		widget.glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, shadowIndexBuffer);
		widget.glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Index) * shadowIndices.size(), &shadowIndices[0], GL_STATIC_DRAW);
		widget.glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
		widget.glBindVertexArray(0);
		widget.update();
	}
}

void ShadowVolume::onPluginLoad() {
	GLWidget & widget = *glwidget();
	widget.makeCurrent();
	widget.glGenVertexArrays(1, &shadowVertexArray);
	widget.glBindVertexArray(shadowVertexArray);
	widget.glGenBuffers(1, &shadowPositionBuffer);
	widget.glGenBuffers(1, &shadowIndexBuffer);
	widget.glBindVertexArray(0);
	Utility::linkShaders(this, &program,
		"ShadowVolume.vert",
		"ShadowVolume.geom",
		"ShadowVolume.frag");
	lightPosition = widget.camera()->getObs();
	maxDistance = widget.camera()->zfar();
	distance = maxDistance;
	showShadowVolume = false;
	computeShadowVolume();
}

void ShadowVolume::onObjectAdd() {
	GLWidget & widget = *glwidget();
	widget.makeCurrent();
	maxDistance = widget.camera()->zfar();
	computeShadowVolume();
}

bool ShadowVolume::paintGL() {
	GLWidget & widget = *glwidget();
	widget.makeCurrent();
	
	program->bind();
	program->setUniformValue("modelViewProjectionMatrix",
		widget.camera()->projectionMatrix() * widget.camera()->viewMatrix());
	program->setUniformValue("boundingBoxMin",
		 widget.scene()->boundingBox().min());
	program->setUniformValue("boundingBoxMax",
		 widget.scene()->boundingBox().max());
	
	widget.glClearColor(0.8f, 0.8f, 0.8f, 0.0f);
    widget.glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    widget.glEnable(GL_CULL_FACE);

	widget.glColorMask(GL_FALSE, GL_FALSE, GL_FALSE, GL_FALSE);
	widget.glCullFace(GL_BACK);
	program->setUniformValue("scene", true);
	if (drawPlugin()) drawPlugin()->drawScene();
	
    // Shadow volume.
    widget.glBindVertexArray(shadowVertexArray);
    widget.glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, shadowIndexBuffer);
    widget.glEnable(GL_STENCIL_TEST);
    
	widget.glDepthMask(GL_FALSE);
	widget.glStencilFunc(GL_ALWAYS, 0, 0);
	
	program->setUniformValue("scene", false);

	if (showShadowVolume)
		widget.glColorMask(GL_TRUE, GL_TRUE, GL_TRUE , GL_TRUE);
	
	widget.glStencilOp(GL_KEEP, GL_KEEP, GL_INCR);
	widget.glCullFace(GL_BACK);
	widget.glDrawElements(GL_TRIANGLES, shadowIndices.size(), GL_UNSIGNED_INT, (GLvoid *) 0);
	
	widget.glStencilOp(GL_KEEP, GL_KEEP, GL_DECR);
	widget.glCullFace(GL_FRONT);
	widget.glDrawElements(GL_TRIANGLES, shadowIndices.size(), GL_UNSIGNED_INT, (GLvoid *) 0);

	widget.glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
	widget.glBindVertexArray(0);

	// Scene.
    widget.glDepthMask(GL_TRUE);
    widget.glColorMask(GL_TRUE, GL_TRUE, GL_TRUE , GL_TRUE);
    widget.glCullFace(GL_BACK);
    widget.glDepthFunc(GL_LEQUAL);
    widget.glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);
	program->setUniformValue("scene", true);
	
	widget.glStencilFunc(GL_EQUAL, 1, 1);
    program->setUniformValue("shadow", true);
    if (drawPlugin()) drawPlugin()->drawScene();
    
    widget.glStencilFunc(GL_EQUAL, 0, 1);
    program->setUniformValue("shadow", false);
	if (drawPlugin()) drawPlugin()->drawScene();

	widget.glDepthFunc(GL_LESS);
	widget.glDisable(GL_STENCIL_TEST);
	
	widget.drawAxes();
	return true;
}

void ShadowVolume::keyPressEvent(QKeyEvent * event) {
	GLWidget & widget = *glwidget();
	widget.makeCurrent();
	
	if (event->key() == Qt::Key_C) {
		lightPosition = widget.camera()->getObs();
		computeShadowVolume();
	} else if (event->key() == Qt::Key_V) {
		showShadowVolume = ! showShadowVolume;
	} else if (event->key() == Qt::Key_Plus) {
		distance = min(distance + maxDistance / 10, maxDistance);
		computeShadowVolume();
	} else if (event->key() == Qt::Key_Minus) {
		distance = max(distance - maxDistance / 10, 0.0f);
		computeShadowVolume();
	}
}
