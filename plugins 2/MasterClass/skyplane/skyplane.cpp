#include "skyplane.h"
#include "glwidget.h"


void Skyplane::linkShaders()
{

	vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
	vs->compileSourceFile("sky.vert");
	cout << "VS log:" << vs->log().toStdString() << endl;
	
	fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
	fs->compileSourceFile("sky.frag");
	
	program = new QOpenGLShaderProgram(this);
	program->addShader(vs);
	program->addShader(fs);
	program->link();
	
	
	vsMir = new QOpenGLShader(QOpenGLShader::Vertex, this);
	vsMir->compileSourceFile("mirror.vert");
	cout << "VS log:" << vsMir->log().toStdString() << endl;
	
	fsMir = new QOpenGLShader(QOpenGLShader::Fragment, this);
	fsMir->compileSourceFile("mirror.frag");
	
	programMir = new QOpenGLShaderProgram(this);
	programMir->addShader(vsMir);
	programMir->addShader(fsMir);
	programMir->link();

}

void Skyplane::loadText(GLWidget & g){

	QString filename = QFileDialog::getOpenFileName(0, "Open Image", "/assig/grau-g/Textures", "Image file (*.png *.jpg)");	
	QImage img0(filename);	
	QImage im0 = img0.convertToFormat(QImage::Format_ARGB32).rgbSwapped().mirrored();
        g.makeCurrent();
	g.glActiveTexture(GL_TEXTURE0);
	g.glGenTextures( 1, &textureId0);
	g.glBindTexture(GL_TEXTURE_2D, textureId0);
	g.glTexImage2D( GL_TEXTURE_2D, 0, GL_RGB, im0.width(), im0.height(), 0, GL_RGBA, GL_UNSIGNED_BYTE, im0.bits());
	g.glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
	g.glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
	g.glBindTexture(GL_TEXTURE_2D, 0);

}

void Skyplane::onPluginLoad()
{	
	GLWidget & widget = * glwidget();
	widget.makeCurrent();
	linkShaders();
	loadText(widget);
}
void drawRect(GLWidget &g)
{
    static bool created = false;
    static GLuint VAO_rect;

    // 1. Create VBO Buffers
    if (!created)
    {
        created = true;
        

        // Create & bind empty VAO
        g.glGenVertexArrays(1, &VAO_rect);
        g.glBindVertexArray(VAO_rect);

        // Create VBO with (x,y,z) coordinates
        float coords[] = { -1, -1, 0.999, 
                            1, -1, 0.999, 
                           -1,  1, 0.999, 
                            1,  1, 0.999};

        GLuint VBO_coords;
        g.glGenBuffers(1, &VBO_coords);
        g.glBindBuffer(GL_ARRAY_BUFFER, VBO_coords);
        g.glBufferData(GL_ARRAY_BUFFER, sizeof(coords), coords, GL_STATIC_DRAW);
        g.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
        g.glEnableVertexAttribArray(0);
        g.glBindVertexArray(0);
    }

    // 2. Draw
    g.glBindVertexArray (VAO_rect);
    g.glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    g.glBindVertexArray(0);
}

bool Skyplane::paintGL()
{
    GLWidget &g = *glwidget();
    g.makeCurrent();
    // Pass 1. Draw scene
    g.glClearColor(0,0,0,0);
    g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    g.glActiveTexture(GL_TEXTURE0);
    g.glBindTexture(GL_TEXTURE_2D, textureId0);
    program->bind();
    program->setUniformValue("sampler0", 0); 
    program->setUniformValue("modelViewMatrix", g.camera()->viewMatrix());
    program->setUniformValue("modelViewProjectionMatrix", g.camera()->projectionMatrix() * g.camera()->viewMatrix());
    drawRect(g);
    //if (drawPlugin()) drawPlugin()->drawScene();
    // bind shader and define uniforms
    programMir->bind();
    programMir->setUniformValue("sampler0", 0);  // texture unit del primer sampler 
    programMir->setUniformValue("modelViewMatrix", g.camera()->viewMatrix());
    programMir->setUniformValue("modelViewProjectionMatrix", g.camera()->projectionMatrix() * g.camera()->viewMatrix());
    // bind textures
   
    if (drawPlugin()) drawPlugin()->drawScene();
    

    g.defaultProgram()->bind();
    
    g.glBindTexture(GL_TEXTURE_2D, 0);
    
    return true;
}

void Skyplane::postFrame()
{
    GLWidget &g = *glwidget();
    g.makeCurrent();

    // bind default shaders
    g.defaultProgram()->bind();
    // unbind textures
    g.glActiveTexture(GL_TEXTURE0);
    g.glBindTexture(GL_TEXTURE_2D, 0);
}

void Skyplane::onObjectAdd()
{
	
}

bool Skyplane::drawScene()
{
	return false; // return true only if implemented
}

bool Skyplane::drawObject(int)
{
	return false; // return true only if implemented
}



void Skyplane::keyPressEvent(QKeyEvent *)
{
	
}

void Skyplane::mouseMoveEvent(QMouseEvent *)
{
	
}

