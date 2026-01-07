#include "myPlugin.h"
#include "glwidget.h"


void MyPlugin::linkShaders()
{

	vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
	vs->compileSourceFile("DrawBoundingBox.vert");
	cout << "VS log:" << vs->log().toStdString() << endl;
	
	fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
	fs->compileSourceFile("DrawBoundingBox.frag");
	
	program = new QOpenGLShaderProgram(this);
	program->addShader(vs);
	program->addShader(fs);
	program->link();



}

void MyPlugin::drawBox(GLWidget & widget, const Box & box){
    const Point & translate = box.min();
    const Point & scale = box.max() - box.min();
    program->bind();
    QMatrix4x4 MVP = widget.camera()->projectionMatrix() * widget.camera()->viewMatrix();
    program->setUniformValue("modelViewProjectionMatrix", MVP);
    program->setUniformValue("translate", translate);
    program->setUniformValue("scale", scale);
    widget.glBindVertexArray(boxVAO);
    widget.glDrawArrays(GL_TRIANGLE_STRIP, 0, 14);
    widget.glBindVertexArray(0);
}



void MyPlugin::createBox(GLWidget & widget)
{
  widget.glGenVertexArrays(1, &boxVAO);
  widget.glBindVertexArray(boxVAO);
  float coordinates[] = {
        1, 1, 0,     0, 1, 0,
        1, 0, 0,     0, 0, 0,
        0, 0, 1,     0, 1, 0,
        0, 1, 1,     1, 1, 0,
        1, 1, 1,     1, 0, 0,
        1, 0, 1,     0, 0, 1,
        1, 1, 1,     0, 1, 1
    };
    
  GLuint VBO_coordinates;
  widget.glGenBuffers(1, &VBO_coordinates);
  widget.glBindBuffer(GL_ARRAY_BUFFER, VBO_coordinates);
  widget.glBufferData(GL_ARRAY_BUFFER, sizeof(coordinates), coordinates, GL_STATIC_DRAW);
  widget.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
  widget.glEnableVertexAttribArray(0);
  widget.glBindVertexArray(0);
}

void MyPlugin::onPluginLoad()
{	
	GLWidget & widget = * glwidget();
	widget.makeCurrent();
	createBox(widget);
	linkShaders();
	for( auto & o : widget.scene()->objects())o.computeBoundingBox();
	
}

void MyPlugin::preFrame()
{
	
}

void MyPlugin::postFrame()
{
    GLWidget & widget = * glwidget();
    widget.makeCurrent();
    GLint polygonMode;
    widget.glGetIntegerv(GL_POLYGON_MODE, &polygonMode);
    widget.glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    int seleccionat= widget.scene()->selectedObject();
    cout<<seleccionat<<endl;
    for (int i=0; i< widget.scene()->objects().size(); ++i){
    	if(i==seleccionat)drawBox(widget,widget.scene()->objects()[i].boundingBox());
    }
        
    widget.glPolygonMode(GL_FRONT_AND_BACK, polygonMode);
}

void MyPlugin::onObjectAdd()
{
    GLWidget & widget = * glwidget();
    widget.makeCurrent();
    for( auto & o : widget.scene()->objects())o.computeBoundingBox();
}

bool MyPlugin::drawScene()
{
	return false; // return true only if implemented
}

bool MyPlugin::drawObject(int)
{
	return false; // return true only if implemented
}

bool MyPlugin::paintGL()
{
	return false; // return true only if implemented
}

void MyPlugin::keyPressEvent(QKeyEvent *)
{
	
}

void MyPlugin::mouseMoveEvent(QMouseEvent *)
{
	
}

