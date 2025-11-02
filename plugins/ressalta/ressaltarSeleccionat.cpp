#include "ressaltarSeleccionat.h"
#include "glwidget.h"

void RessaltarSeleccionat::onPluginLoad()
{
	vshader = new QOpenGLShader(QOpenGLShader::Vertex, this);
	QFile file("./vertex.vert");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        cout << "Error al abrir vertex.vert" << endl;
        return;
    }

    QTextStream in(&file);
    QString vertexShaderSource = in.readAll();
    file.close();

    if (!vshader->compileSourceCode(vertexShaderSource)) {
        cout << "Error al compilar vertex.vert: " << vshader->log().toStdString() << endl;
        return;
    }
	cout << "VS log: " << vshader-> log().toStdString() << endl;
	
	fshader = new QOpenGLShader(QOpenGLShader::Fragment, this);
	QFile file2("./fragment.frag");
    if (!file2.open(QIODevice::ReadOnly | QIODevice::Text)) {
        cout << "Error al abrir fragment.frag" << endl;
        return;
    }

    QTextStream in2(&file2);
    QString fragmentShaderSource = in2.readAll();
    file2.close();

    if (!fshader->compileSourceCode(fragmentShaderSource)) {
        cout << "Error al compilar fragment.frag: " << fshader->log().toStdString() << endl;
        return;
    }
	cout << "VS log: " << fshader-> log().toStdString() << endl;

	program = new QOpenGLShaderProgram(this);
	program->addShader(vshader);
	program->addShader(fshader);
	program->link();
	cout << "Link log:" << program->log().toStdString() << endl;

	created = false;
	
}

void RessaltarSeleccionat::preFrame()
{
	
}

void RessaltarSeleccionat::postFrame()
{
	createCube();
	program->bind();
	QMatrix4x4 MVP = camera()->projectionMatrix()*camera()->viewMatrix();
	program->setUniformValue("modelViewProjectionMatrix", MVP);

	GLWidget &g = *glwidget();
	Scene *scn = scene();
	const vector<Object> &obj = scn->objects();

	for(int i = 0; i < obj.size(); ++i) {

		//SELECCIÓN DEL OBJETO
		int selected_index= scene()->selectedObject();
		const Object& selected_obj = scene()->objects()[selected_index];
		
		program->setUniformValue("boundingBoxMin", selected_obj.boundingBox().min());
		program->setUniformValue("boundingBoxMax", selected_obj.boundingBox().max());


		// Vincula el VAO previamente configurado (cube_VAO)
		// Esto asegura que los datos del VBO y los atributos de vértices estén activos
		g.glBindVertexArray(cube_VAO);

		// Cambia el modo de renderizado a GL_LINE para pintar solo las líneas de los triángulos
		g.glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

		// Dibuja
		// 0: índice del primer vértice a dibujar
		// 10: cantidad de vértices a renderizar (hay 10 vértices definidos)
		g.glDrawArrays(GL_TRIANGLE_STRIP, 0, 10);

		// Restaura el modo de renderizado a GL_FILL para pintar sólidos después de dibujar la bounding box
		g.glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

		// Desvincula el VAO (por buenas prácticas, para evitar afectar otros dibujos)
		g.glBindVertexArray(0);
	}
}

void RessaltarSeleccionat::createCube() {
	program->bind();

	GLWidget &g = *glwidget();
	g.makeCurrent();
	if (!created) {
		created = true;

		float coords[] = { 
				0, 0, 0,
				0, 1, 0,
				1, 0, 0,
				1, 1, 0,
				1, 0, 1,
				1, 1, 1,
				0, 0, 1,
				0, 1, 1,
				0, 0, 0,
				0, 1, 0,
				};

			float color[] = { 
				1, 0, 1,
				1, 0, 0,
				1, 0, 1,
				1, 1, 0,
				1, 0, 0,
				0, 0, 1,
				1, 0, 0,
				1, 0, 0,
				1, 0, 0,
				1, 0, 1,
				1, 1, 0};

		g.glGenVertexArrays(1, &cube_VAO); // Genera un identificador único para un VAO 
		g.glBindVertexArray(cube_VAO); // Asocia (activa) el VAO generado
		g.glGenBuffers(1, &coordBuffer); //Genera un identificador único para un VBO
		g.glBindBuffer(GL_ARRAY_BUFFER, coordBuffer); //Asocia el VBO generado como el buffer activo para el tipo GL_ARRAY_BUFFER (activa)
		g.glBufferData(GL_ARRAY_BUFFER, sizeof(coords), coords, GL_STATIC_DRAW); 
		/*GL_ARRAY_BUFFER: Define que los datos cargados son para un VBO que almacena atributos de vértices (como posiciones, colores, normales, etc.).
		sizeof(coords): Especifica el tamaño en bytes de los datos que se cargarán al buffer.
		coords: Apunta al array en la CPU que contiene los datos de los vértices.
		GL_STATIC_DRAW: Indica que los datos son estáticos y no cambiarán después de cargarse.*/
		g.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
		/*Índice (0): Atributo de vértice a configurar (posiciones en este caso).
		Componentes (3): Cada vértice tiene 3 valores (X, Y, Z).
		Tipo (GL_FLOAT): Los valores son de tipo float.
		Normalización (GL_FALSE): Los valores no necesitan ser normalizados.
		Stride (0): Los datos están empaquetados sin separación.
		Desplazamiento (0): Los datos comienzan desde el inicio del buffer.*/
		g.glEnableVertexAttribArray(0); //Abilita atributo índice 0
		g.glGenBuffers(1, &colorVBO);
		g.glBindBuffer(GL_ARRAY_BUFFER, colorVBO);
		g.glBufferData(GL_ARRAY_BUFFER, sizeof(color), color, GL_STATIC_DRAW);
		g.glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, 0, 0);
        g.glEnableVertexAttribArray(2);
	}

}

void RessaltarSeleccionat::onObjectAdd()
{
	
}

bool RessaltarSeleccionat::drawScene()
{
	return false; // return true only if implemented
}

bool RessaltarSeleccionat::drawObject(int)
{
	return false; // return true only if implemented
}

bool RessaltarSeleccionat::paintGL()
{
	return false; // return true only if implemented
}

void RessaltarSeleccionat::keyPressEvent(QKeyEvent* event)
{
	 if (event->key() == Qt::Key_Plus) 
    {
		Scene *scn = scene();
        int selectedObj = scn->selectedObject();
		 if (selectedObj < scn->objects().size() - 1)
        {
            scn->setSelectedObject(selectedObj + 1); // Incrementa el seleccionado
        }
        else
        {
            scn->setSelectedObject(0); // Reinicia si alcanza el último objeto
        }

        onPluginLoad();
    } 
	
}

void RessaltarSeleccionat::mouseMoveEvent(QMouseEvent *)
{
	
}

