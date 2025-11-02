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

#include "TextureSplatting.h"

void TextureSplatting::addTexture(const char * filename, GLuint * id) {
	GLWidget & g = * glwidget();
	QImage image(filename);
	image = image.convertToFormat(QImage::Format_ARGB32).rgbSwapped().mirrored();
	g.glGenTextures(1, id);
	g.glBindTexture(GL_TEXTURE_2D, * id);
	g.glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, image.width(), image.height(), 0, GL_RGBA, GL_UNSIGNED_BYTE, image.bits());
	g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	g.glBindTexture(GL_TEXTURE_2D, 0);
}
 
void TextureSplatting::onPluginLoad()
{
	GLWidget & g = * glwidget();
	g.makeCurrent();
	
	vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
	vs->compileSourceFile("TextureSplatting.vert");
	cout << "VS log:" << vs->log().toStdString() << endl;
	
	fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
	fs->compileSourceFile("TextureSplatting.frag");
	cout << "FS log:" << fs->log().toStdString() << endl;
	
  	program = new QOpenGLShaderProgram(this);
	program->addShader(vs);
	program->addShader(fs);
	program->link();
	cout << "Link log:" << program->log().toStdString() << endl;
	
	addTexture("noise.png", &textureId0);
	addTexture("rock.jpg", &textureId1);
	addTexture("grass.png", &textureId2);
}

void TextureSplatting::preFrame() 
{
	GLWidget & g = * glwidget();
	g.makeCurrent();
	
	program->bind();
	program->setUniformValue("sampler0", 0);
	program->setUniformValue("sampler1", 1);
	program->setUniformValue("sampler2", 2);
	float radius = scene()->boundingBox().radius();
	program->setUniformValue("radius", radius);
	QMatrix4x4 MVP = g.camera()->projectionMatrix() * g.camera()->viewMatrix();
	program->setUniformValue("modelViewProjectionMatrix", MVP);
	QMatrix3x3 N = g.camera()->viewMatrix().normalMatrix();
	program->setUniformValue("normalMatrix", N);
	
	g.glActiveTexture(GL_TEXTURE0);
	g.glBindTexture(GL_TEXTURE_2D, textureId0);
	g.glActiveTexture(GL_TEXTURE1);
	g.glBindTexture(GL_TEXTURE_2D, textureId1);
	g.glActiveTexture(GL_TEXTURE2);
	g.glBindTexture(GL_TEXTURE_2D, textureId2);
}

void TextureSplatting::postFrame() 
{
	GLWidget & g = * glwidget();
	g.makeCurrent();
	
	g.defaultProgram()->bind();
	
	g.glActiveTexture(GL_TEXTURE0);
	g.glBindTexture(GL_TEXTURE_2D, 0);
	g.glActiveTexture(GL_TEXTURE1);
	g.glBindTexture(GL_TEXTURE_2D, 0);
	g.glActiveTexture(GL_TEXTURE2);
	g.glBindTexture(GL_TEXTURE_2D, 0);
}
