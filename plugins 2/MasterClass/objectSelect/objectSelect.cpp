// GLarena, a plugin based platform to teach OpenGL programming
// © Copyright 2012-2018, ViRVIG Research Group, UPC, https://www.virvig.eu
//
// This file is part of GLarena
//
// GLarena is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

#include "objectSelect.h"
#include <QCoreApplication>

void ObjectSelect::linkShaders()
{

	vsBox = new QOpenGLShader(QOpenGLShader::Vertex, this);
	vsBox->compileSourceFile("DrawBoundingBox.vert");
	cout << "VS log:" << vsBox->log().toStdString() << endl;
	
	fsBox = new QOpenGLShader(QOpenGLShader::Fragment, this);
	fsBox->compileSourceFile("DrawBoundingBox.frag");
	
	programBox = new QOpenGLShaderProgram(this);
	programBox->addShader(vsBox);
	programBox->addShader(fsBox);
	programBox->link();



}

void ObjectSelect::createBox(GLWidget & widget)
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

void ObjectSelect::drawBox(GLWidget & widget, const Box & box){
    const Point & translate = box.min();
    const Point & scale = box.max() - box.min();
    programBox->bind();
    QMatrix4x4 MVP = widget.camera()->projectionMatrix() * widget.camera()->viewMatrix();
    programBox->setUniformValue("modelViewProjectionMatrix", MVP);
    programBox->setUniformValue("translate", translate);
    programBox->setUniformValue("scale", scale);
    widget.glBindVertexArray(boxVAO);
    widget.glDrawArrays(GL_TRIANGLE_STRIP, 0, 14);
    widget.glBindVertexArray(0);
}

void ObjectSelect::encodeID(const unsigned int i, GLubyte * color) {
	// complete this method to encode the object index (i) as a color
    GLubyte R = (i & 0xFF); // complete
    GLubyte G = ((i>>8) & 0xFF); // complete
    GLubyte B = ((i>>16)& 0xFF); // complete
    color[0] = R;
    color[1] = G;
    color[2] = B;
    color[3] = 255;
}

void ObjectSelect::decodeID(const GLubyte *color, unsigned int &i) {
	// complete this method to decode the object index from the color 
    unsigned int R = (unsigned int) color[0];
    unsigned int G = (unsigned int) color[1];
    unsigned int B = (unsigned int) color[2];
	// compute i from R, G, B
    i = (B << 16) | (G << 8)| R; 
}

void ObjectSelect::onPluginLoad() {
    std::cout << "[ObjectSelect plugin] Ctrl + Right Click - Select object" << std::endl;

    GLWidget &g = *glwidget();
    g.makeCurrent();

    // Carregar shader, compile & link
    vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
    vs->compileSourceFile(g.getPluginPath() + "/../objectSelect/objectSelect.vert");

    fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
    fs->compileSourceFile(g.getPluginPath() + "/../objectSelect/objectSelect.frag");

    program = new QOpenGLShaderProgram(this);
    program->addShader(vs);
    program->addShader(fs);
    program->link();
    if (!program->isLinked())
        std::cout << "Shader link error" << std::endl;
    createBox(g);
    linkShaders(); 
   
}

void ObjectSelect::postFrame()
{
    GLWidget & widget = * glwidget();
    widget.makeCurrent();
    GLint polygonMode;
    widget.glGetIntegerv(GL_POLYGON_MODE, &polygonMode);
    widget.glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    int seleccionat= widget.scene()->selectedObject();
    if(seleccionat >= 0) drawBox(widget,widget.scene()->objects()[seleccionat].boundingBox());
        
    widget.glPolygonMode(GL_FRONT_AND_BACK, polygonMode);
}

void ObjectSelect::selectDraw(GLWidget & g) {
    // (b)
    g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);

    // (c)
    program->bind();

    // (d)
    QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
    program->setUniformValue("modelViewProjectionMatrix", MVP);

    // (e)
    for (unsigned int i=0; i<scene()->objects().size(); ++i){
        GLubyte color[4];
        encodeID(i,color);
        program->setUniformValue("color", QVector4D(color[0]/255.0f, color[1]/255.0f, color[2]/255.0f, 1.0));
        drawPlugin()->drawObject(i);
    }
}

void ObjectSelect::mouseReleaseEvent(QMouseEvent* e) {
    // (a)
    if (!(e->button() & Qt::RightButton)) return;
    if (e->modifiers() & (Qt::ShiftModifier)) return;
    if (!(e->modifiers() & Qt::ControlModifier)) return;

    GLWidget &g = *glwidget();
    g.makeCurrent();

    // (b) through (e)
    selectDraw(g);

    // (f)
    int x = e->x();
    int y = g.height() - e->y();
    GLubyte read[4];
    glReadPixels(x, y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, read);

    // (g)
    if(read[3] == 255){
        // Not the background, thus an object has been selected
        unsigned int tmp;
        decodeID(read, tmp);
        scene()->setSelectedObject((int) tmp);
        std::cout << tmp << std::endl;
    } else {
        scene()->setSelectedObject(-1);
        std::cout << -1 << std::endl;
    }

    // (h)
    g.update();
}
