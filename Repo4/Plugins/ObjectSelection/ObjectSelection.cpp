#include "ObjectSelection.h"
#include "glwidget.h"

void ObjectSelection::linkBoxShaders()
{
	boxVertexShader = new QOpenGLShader(QOpenGLShader::Vertex, this);
	boxVertexShader->compileSourceFile("Box.vert");
	cout << "VS log (box):" << boxVertexShader->log().toStdString() << endl;

	boxFragmentShader = new QOpenGLShader(QOpenGLShader::Fragment, this);
	boxFragmentShader->compileSourceFile("Box.frag");
	cout << "FS log (box):" << boxFragmentShader->log().toStdString() << endl;

	boxShaderProgram = new QOpenGLShaderProgram(this);
	boxShaderProgram->addShader(boxVertexShader);
	boxShaderProgram->addShader(boxFragmentShader);
	boxShaderProgram->link();
	cout << "Link log (box):" << boxShaderProgram->log().toStdString() << endl;
}

void ObjectSelection::linkSelectionShaders()
{
	selectionVertexShader = new QOpenGLShader(QOpenGLShader::Vertex, this);
	selectionVertexShader->compileSourceFile("Selection.vert");
	cout << "VS log (selection):" << selectionVertexShader->log().toStdString() << endl;

	selectionFragmentShader = new QOpenGLShader(QOpenGLShader::Fragment, this);
	selectionFragmentShader->compileSourceFile("Selection.frag");
	cout << "FS log (selection):" << selectionFragmentShader->log().toStdString() << endl;

	selectionShaderProgram = new QOpenGLShaderProgram(this);
	selectionShaderProgram->addShader(selectionVertexShader);
	selectionShaderProgram->addShader(selectionFragmentShader);
	selectionShaderProgram->link();
	cout << "Link log (selection):" << selectionShaderProgram->log().toStdString() << endl;
}

void ObjectSelection::createBox(GLWidget & widget) {
	float coordinates[] = {
		1, 1, 0,	 0, 1, 0,
		1, 0, 0,	 0, 0, 0,
		0, 0, 1,	 0, 1, 0,
		0, 1, 1,	 1, 1, 0,
		1, 1, 1,	 1, 0, 0,
		1, 0, 1,	 0, 0, 1,
		1, 1, 1,	 0, 1, 1
	};
	GLuint id;
	widget.glGenVertexArrays(1, &boxId);
	widget.glBindVertexArray(boxId);
	widget.glGenBuffers(1, &id);
	widget.glBindBuffer(GL_ARRAY_BUFFER, id);
	widget.glBufferData(GL_ARRAY_BUFFER, sizeof(coordinates), coordinates, GL_STATIC_DRAW);
	widget.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
	widget.glEnableVertexAttribArray(0);
	widget.glBindVertexArray(0);
}

void ObjectSelection::drawBox(GLWidget & widget, const Box & box)
{
	QMatrix4x4 MVP = widget.camera()->projectionMatrix() * widget.camera()->viewMatrix();
	const Point & translate = box.min();
	const Point & scale = box.max() - box.min();
	GLint polygonMode;
	boxShaderProgram->bind();
	boxShaderProgram->setUniformValue("modelViewProjectionMatrix", MVP);
	boxShaderProgram->setUniformValue("translate", translate);
	boxShaderProgram->setUniformValue("scale", scale);
	boxShaderProgram->setUniformValue("color", QVector4D(0.0f, 0.0f, 0.0f, 1.0f));
	widget.glGetIntegerv(GL_POLYGON_MODE, &polygonMode);
	widget.glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
	widget.glBindVertexArray(boxId);
	widget.glDrawArrays(GL_TRIANGLE_STRIP, 0, 14);
	widget.glBindVertexArray(0);
	widget.glPolygonMode(GL_FRONT_AND_BACK, polygonMode);
	widget.defaultProgram()->bind();
}

void ObjectSelection::onPluginLoad()
{
	GLWidget & widget = * glwidget();
	widget.makeCurrent();
	linkBoxShaders();
	linkSelectionShaders();
	createBox(widget);
}

void ObjectSelection::preFrame()
{
	
}

void ObjectSelection::postFrame()
{
	GLWidget & widget = * glwidget();
	widget.makeCurrent();
	int id = widget.scene()->selectedObject();
	if (id >= 0) drawBox(widget, widget.scene()->objects()[id].boundingBox());
}

void ObjectSelection::onObjectAdd()
{

}

bool ObjectSelection::drawScene()
{
	return false; // return true only if implemented
}

bool ObjectSelection::drawObject(int)
{
	return false; // return true only if implemented
}

bool ObjectSelection::paintGL()
{
	return false; // return true only if implemented
}

void ObjectSelection::keyPressEvent(QKeyEvent * event)
{
	if (Qt::Key_0 <= event->key() && event->key() <= Qt::Key_9) {
		GLWidget & widget = * glwidget();
		widget.makeCurrent();
		int id = event->key() - Qt::Key_0;
		id = ((unsigned int) id) < widget.scene()->objects().size() ? id : -1;
		widget.scene()->setSelectedObject(id);
		widget.update();
	}
}

QVector4D intToVec(unsigned int x) {
	return QVector4D(
		((x      ) & 0xFF) / 255.0f,
		((x >>  8) & 0xFF) / 255.0f,
		((x >> 16) & 0xFF) / 255.0f,
		((x >> 24) & 0xFF) / 255.0f);
}

unsigned int bytesToInt(const GLubyte * x) {
	return (x[3] << 24) | (x[2] << 16) | (x[1] << 8) | x[0];
}

void printBytes(const GLubyte * x) {
	cout << "(" << (unsigned int) x[0] << ", "
	            << (unsigned int) x[1] << ", "
	            << (unsigned int) x[2] << ", "
	            << (unsigned int) x[3] << ")" << endl;
}

void ObjectSelection::mouseReleaseEvent(QMouseEvent * event)
{
	if (event->button() & Qt::LeftButton &&
	    event->modifiers() & Qt::ControlModifier) {
		GLWidget & widget = * glwidget();
		widget.makeCurrent();
		selectionShaderProgram->bind();
		QMatrix4x4 MVP = widget.camera()->projectionMatrix() * widget.camera()->viewMatrix();
		selectionShaderProgram->setUniformValue("modelViewProjectionMatrix", MVP);
		glClearColor(0, 0, 0, 0);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		unsigned int n = scene()->objects().size();
		for (unsigned int i = 0; i < n; i++) {
			selectionShaderProgram->setUniformValue("color", intToVec(i + 1));
			if (drawPlugin()) drawPlugin()->drawObject(i);
		}
		GLubyte color[4];
		glReadPixels(event->x(), widget.height() - event->y(), 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, color);
		printBytes(color);
		widget.scene()->setSelectedObject(bytesToInt(color) - 1);
		widget.defaultProgram()->bind();
		widget.update();
	}
}
