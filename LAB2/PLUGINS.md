# GLarena Plugin Development - Quick Reference Cheat Sheet

## Table of Contents
1. [Plugin Structure](#plugin-structure)
2. [Header File Template](#header-file-template)
3. [Implementation File Template](#implementation-file-template)
4. [Shader Management](#shader-management)
5. [Common Plugin Methods](#common-plugin-methods)
6. [Matrices & Transformations](#matrices--transformations)
7. [Texture Management](#texture-management)
8. [Framebuffer & FBO](#framebuffer--fbo)
9. [VAO/VBO Setup](#vaovbo-setup)
10. [Shader Uniform Patterns](#shader-uniform-patterns)
11. [Common Shader Code](#common-shader-code)
12. [.pro File Setup](#pro-file-setup)
13. [Quick Tips & Patterns](#quick-tips--patterns)

---

## Plugin Structure

### Essential Files
```
YourPlugin/
├── YourPlugin.h          # Header file
├── YourPlugin.cpp        # Implementation
├── YourPlugin.pro        # Qt project file
├── YourPlugin.vert       # Vertex shader (optional)
├── YourPlugin.frag       # Fragment shader (optional)
├── Makefile              # Build file
└── build/                # Build output directory
```

---

## Header File Template

```cpp
#ifndef _YOURPLUGIN_H
#define _YOURPLUGIN_H

#include "plugin.h" 
#include <QOpenGLShader>
#include <QOpenGLShaderProgram>

class YourPlugin: public QObject, public Plugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "Plugin") 
    Q_INTERFACES(Plugin)

public:
    // Plugin lifecycle methods
    void onPluginLoad();        // Called once when plugin loads
    void preFrame();            // Called before rendering each frame
    void postFrame();           // Called after rendering each frame
    
    void onObjectAdd();         // Called when new object added to scene
    bool drawScene();           // Override scene drawing
    bool drawObject(int);       // Override individual object drawing
    bool paintGL();             // Complete rendering override
    
    // Event handlers
    void keyPressEvent(QKeyEvent *);
    void mouseMoveEvent(QMouseEvent *);
    
private:
    QOpenGLShaderProgram *program;
    QOpenGLShader *fs, *vs;
    
    // Your variables here
    GLuint VAO, VBO;
    GLuint textureId;
    GLuint fboId;
};

#endif
```

---

## Implementation File Template

```cpp
#include "YourPlugin.h"
#include "glwidget.h"

void YourPlugin::onPluginLoad()
{
    // Get GLWidget reference
    GLWidget &g = *glwidget();
    g.makeCurrent();
    
    // Load and compile shaders
    vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
    vs->compileSourceFile("YourPlugin.vert");
    cout << "VS log: " << vs->log().toStdString() << endl;

    fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
    fs->compileSourceFile("YourPlugin.frag");
    cout << "FS log: " << fs->log().toStdString() << endl;

    // Link shader program
    program = new QOpenGLShaderProgram(this);
    program->addShader(vs);
    program->addShader(fs);
    program->link();
    cout << "Link log: " << program->log().toStdString() << endl;
    
    // Initialize your resources here
}

void YourPlugin::preFrame()
{
    program->bind();
    
    // Set uniforms that change per frame
    QMatrix4x4 MV = camera()->viewMatrix();
    QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
    QMatrix3x3 N = camera()->viewMatrix().normalMatrix();
    
    program->setUniformValue("modelViewMatrix", MV);
    program->setUniformValue("modelViewProjectionMatrix", MVP);
    program->setUniformValue("normalMatrix", N);
}

void YourPlugin::postFrame()
{
    program->release();
}

void YourPlugin::onObjectAdd()
{
    // Called when object is added to scene
}

bool YourPlugin::drawScene()
{
    return false; // true if you handle drawing
}

bool YourPlugin::drawObject(int)
{
    return false; // true if you handle object drawing
}

bool YourPlugin::paintGL()
{
    return false; // true if you handle entire rendering
}

void YourPlugin::keyPressEvent(QKeyEvent *e)
{
    // Handle keyboard input
}

void YourPlugin::mouseMoveEvent(QMouseEvent *e)
{
    // Handle mouse movement
}
```

---

## Shader Management

### Loading Shaders from Files
```cpp
// Basic shader loading from external files
// This is the most common approach for complex shaders
vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
vs->compileSourceFile("shader.vert");  // Looks in plugin directory
cout << "VS log: " << vs->log().toStdString() << endl;  // Always check logs!

fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
fs->compileSourceFile("shader.frag");
cout << "FS log: " << fs->log().toStdString() << endl;

program = new QOpenGLShaderProgram(this);
program->addShader(vs);
program->addShader(fs);
program->link();
cout << "Link log: " << program->log().toStdString() << endl;
```

### Inline Shaders (Using Raw String Literals)
```cpp
// Useful for simple shaders or when you want everything in one file
// Use R"""( ... )""" for multi-line strings (C++11)
QString vs_src = R"""(
    #version 330 core
    layout (location = 0) in vec3 vertex;
    uniform mat4 modelViewProjectionMatrix;
    void main() {
        gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
    }
)""";

vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
vs->compileSourceCode(vs_src);  // compileSourceCode instead of compileSourceFile
cout << "VS log: " << vs->log().toStdString() << endl;

QString fs_src = R"""(
    #version 330 core
    out vec4 fragColor;
    void main() {
        fragColor = vec4(1.0, 0.0, 0.0, 1.0);
    }
)""";

fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
fs->compileSourceCode(fs_src);
cout << "FS log: " << fs->log().toStdString() << endl;

program = new QOpenGLShaderProgram(this);
program->addShader(vs);
program->addShader(fs);
program->link();
```

### Using Plugin Path (for shared shaders)
```cpp
GLWidget &g = *glwidget();
vs->compileSourceFile(g.getPluginPath() + "/../yourfolder/shader.vert");
```

### Multiple Shader Programs
```cpp
// Deferred shading example
QOpenGLShaderProgram *deferredProgram;
QOpenGLShaderProgram *gbufferProgram;
QOpenGLShaderProgram *lightingProgram;

// Create each program separately
// Program 1
QOpenGLShader* vs1 = new QOpenGLShader(QOpenGLShader::Vertex, this);
vs1->compileSourceFile("pass1.vert");
QOpenGLShader* fs1 = new QOpenGLShader(QOpenGLShader::Fragment, this);
fs1->compileSourceFile("pass1.frag");
deferredProgram = new QOpenGLShaderProgram(this);
deferredProgram->addShader(vs1);
deferredProgram->addShader(fs1);
deferredProgram->link();

// Program 2, 3, etc...
```

---

## Common Plugin Methods

### Return Values
| Method | Return `false` | Return `true` |
|--------|----------------|---------------|
| `drawScene()` | Use default scene drawing | Plugin handles all scene drawing |
| `drawObject(int)` | Use default object drawing | Plugin handles object drawing |
| `paintGL()` | Use default rendering | Plugin handles entire frame |

### Method Call Order
```
onPluginLoad()           // Once at startup - initialize resources
  ↓
[For each frame:]
  preFrame()             // Before drawing - bind shaders, set uniforms
    ↓
  drawScene()/drawObject()  // Drawing phase - render geometry
    ↓
  postFrame()            // After drawing - release shaders, draw overlays
```

**Explanation:**
- **preFrame()**: Called BEFORE the scene is drawn. Perfect for binding your shader program and setting up uniforms that are constant for the entire frame (like view/projection matrices).
- **postFrame()**: Called AFTER the scene is drawn. Ideal for drawing overlays (like bounding boxes, text, HUD elements) or releasing shader programs.
- **drawScene()**: Override this to replace the entire scene rendering.
- **drawObject(int)**: Override this to replace individual object rendering.
- **paintGL()**: Complete control over the entire rendering pipeline, including clearing the screen.

### Accessing Scene Data
```cpp
// Get current camera (for view/projection matrices)
Camera *cam = camera();

// Get GLWidget reference (needed for all OpenGL calls)
GLWidget &g = *glwidget();
g.makeCurrent();  // Always call this before OpenGL operations

// Access the scene
const Scene *scn = scene();

// Iterate through all objects in the scene
for (Object &obj : scene()->objects()) {
    // Do something with each object
    const Box &box = obj.boundingBox();
    const vector<Vertex> &vertices = obj.vertices();
    const vector<Face> &faces = obj.faces();
}

// Access specific object by index
const Object &obj = scene()->objects()[0];

// Get selected object (for object selection plugins)
int selectedId = scene()->selectedObject();
if (selectedId >= 0) {
    const Object &selectedObj = scene()->objects()[selectedId];
}

// Get scene bounding box (useful for camera setup, light positioning)
const Box &sceneBox = scene()->boundingBox();
float sceneRadius = scene()->boundingBox().radius();
Point sceneCenter = scene()->boundingBox().center();

// Use draw plugin for default rendering (when you want to draw normally)
if (drawPlugin()) drawPlugin()->drawScene();
```

---

## Matrices & Transformations

### Standard Matrix Uniforms
```cpp
// Model-View-Projection matrix
QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
program->setUniformValue("modelViewProjectionMatrix", MVP);

// Model-View matrix
QMatrix4x4 MV = camera()->viewMatrix();
program->setUniformValue("modelViewMatrix", MV);

// Normal matrix (for transforming normals)
QMatrix3x3 N = camera()->viewMatrix().normalMatrix();
program->setUniformValue("normalMatrix", N);

// View matrix only
QMatrix4x4 V = camera()->viewMatrix();
program->setUniformValue("viewMatrix", V);

// Projection matrix only
QMatrix4x4 P = camera()->projectionMatrix();
program->setUniformValue("projectionMatrix", P);
```

### Per-Object Transformations
```cpp
// Bounding box transformations
const Box &box = object.boundingBox();
const Point &translate = box.min();
const Point &scale = box.max() - box.min();

program->setUniformValue("translate", translate);
program->setUniformValue("scale", scale);
```

---

## Texture Management

### Basic Texture Setup
```cpp
GLWidget &g = *glwidget();

// Generate and bind texture
g.glActiveTexture(GL_TEXTURE0);
g.glGenTextures(1, &textureId);
g.glBindTexture(GL_TEXTURE_2D, textureId);

// Set texture parameters
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

// Allocate texture memory
g.glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_FLOAT, NULL);

// With mipmaps
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
g.glGenerateMipmap(GL_TEXTURE_2D);

// Unbind
g.glBindTexture(GL_TEXTURE_2D, 0);
```

### Loading Image as Texture
```cpp
void loadTexture(GLuint *id, const QString &filename)
{
    GLWidget &g = *glwidget();
    QImage image(filename);
    image = image.convertToFormat(QImage::Format_RGBA8888);
    
    g.glGenTextures(1, id);
    g.glBindTexture(GL_TEXTURE_2D, *id);
    g.glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 
                   image.width(), image.height(), 
                   0, GL_RGBA, GL_UNSIGNED_BYTE, image.bits());
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    g.glBindTexture(GL_TEXTURE_2D, 0);
}
```

### Copy Framebuffer to Texture
```cpp
g.glBindTexture(GL_TEXTURE_2D, textureId);
g.glCopyTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 0, 0, width, height);
g.glGenerateMipmap(GL_TEXTURE_2D);
```

### Multi-Texturing
```cpp
// Bind multiple textures
g.glActiveTexture(GL_TEXTURE0);
g.glBindTexture(GL_TEXTURE_2D, textureId0);
g.glActiveTexture(GL_TEXTURE1);
g.glBindTexture(GL_TEXTURE_2D, textureId1);
g.glActiveTexture(GL_TEXTURE2);
g.glBindTexture(GL_TEXTURE_2D, textureId2);

// Set uniform samplers
program->setUniformValue("texture0", 0);
program->setUniformValue("texture1", 1);
program->setUniformValue("texture2", 2);

// In fragment shader:
// uniform sampler2D texture0;
// uniform sampler2D texture1;
// uniform sampler2D texture2;
```

---

## Framebuffer & FBO

### Basic FBO Setup
```cpp
GLuint fboId;
GLuint colorTextureId;
GLuint depthTextureId;

GLWidget &g = *glwidget();

// Create FBO
g.glGenFramebuffers(1, &fboId);
g.glBindFramebuffer(GL_FRAMEBUFFER, fboId);

// Create color texture
g.glGenTextures(1, &colorTextureId);
g.glBindTexture(GL_TEXTURE_2D, colorTextureId);
g.glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 
               0, GL_RGB, GL_FLOAT, NULL);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

// Attach color texture to FBO
g.glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, 
                         GL_TEXTURE_2D, colorTextureId, 0);

// Create depth texture
g.glGenTextures(1, &depthTextureId);
g.glBindTexture(GL_TEXTURE_2D, depthTextureId);
g.glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT24, width, height,
               0, GL_DEPTH_COMPONENT, GL_FLOAT, NULL);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

// Attach depth texture to FBO
g.glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, 
                         GL_TEXTURE_2D, depthTextureId, 0);

// Check FBO status
if (g.glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    cout << "Framebuffer not complete!" << endl;

// Unbind
g.glBindFramebuffer(GL_FRAMEBUFFER, 0);
```

### Using FBO for Rendering
```cpp
// Render to FBO
g.glBindFramebuffer(GL_FRAMEBUFFER, fboId);
g.glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
// ... render scene ...
g.glBindFramebuffer(GL_FRAMEBUFFER, 0);

// Render to screen using FBO texture
g.glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
g.glBindTexture(GL_TEXTURE_2D, colorTextureId);
// ... render quad with texture ...
```

### Shadow Map FBO
```cpp
// Depth-only FBO for shadow mapping
g.glGenFramebuffers(1, &shadowFBO);
g.glBindFramebuffer(GL_FRAMEBUFFER, shadowFBO);

g.glGenTextures(1, &shadowTexture);
g.glBindTexture(GL_TEXTURE_2D, shadowTexture);
g.glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT24, 
               SHADOW_WIDTH, SHADOW_HEIGHT,
               0, GL_DEPTH_COMPONENT, GL_FLOAT, NULL);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC, GL_LEQUAL);

g.glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, 
                         GL_TEXTURE_2D, shadowTexture, 0);
g.glDrawBuffer(GL_NONE);  // No color buffer
g.glBindFramebuffer(GL_FRAMEBUFFER, 0);
```

---

## VAO/VBO Setup

### Simple VAO/VBO Pattern
```cpp
GLuint VAO, VBO;
GLWidget &g = *glwidget();

// Generate and bind VAO
g.glGenVertexArrays(1, &VAO);
g.glBindVertexArray(VAO);

// Vertex data
float vertices[] = {
    // positions      // normals       // texcoords
    -1.0f, -1.0f, 0.0f,  0.0f, 0.0f, 1.0f,  0.0f, 0.0f,
     1.0f, -1.0f, 0.0f,  0.0f, 0.0f, 1.0f,  1.0f, 0.0f,
    -1.0f,  1.0f, 0.0f,  0.0f, 0.0f, 1.0f,  0.0f, 1.0f,
     1.0f,  1.0f, 0.0f,  0.0f, 0.0f, 1.0f,  1.0f, 1.0f
};

// Generate and bind VBO
g.glGenBuffers(1, &VBO);
g.glBindBuffer(GL_ARRAY_BUFFER, VBO);
g.glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

// Set vertex attributes
// Position attribute (location = 0)
g.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)0);
g.glEnableVertexAttribArray(0);

// Normal attribute (location = 1)
g.glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)(3 * sizeof(float)));
g.glEnableVertexAttribArray(1);

// Texcoord attribute (location = 2)
g.glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void*)(6 * sizeof(float)));
g.glEnableVertexAttribArray(2);

// Unbind
g.glBindVertexArray(0);
```

### Drawing with VAO
```cpp
g.glBindVertexArray(VAO);
g.glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
g.glBindVertexArray(0);
```

### Fullscreen Quad Helper
```cpp
void drawRect(GLWidget &g)
{
    static bool created = false;
    static GLuint VAO_rect;

    if (!created) {
        created = true;
        g.glGenVertexArrays(1, &VAO_rect);
        g.glBindVertexArray(VAO_rect);
        
        float coords[] = {
            -1, -1, 0,
             1, -1, 0,
            -1,  1, 0,
             1,  1, 0
        };
        
        GLuint VBO_coords;
        g.glGenBuffers(1, &VBO_coords);
        g.glBindBuffer(GL_ARRAY_BUFFER, VBO_coords);
        g.glBufferData(GL_ARRAY_BUFFER, sizeof(coords), coords, GL_STATIC_DRAW);
        g.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
        g.glEnableVertexAttribArray(0);
        g.glBindVertexArray(0);
    }

    g.glBindVertexArray(VAO_rect);
    g.glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    g.glBindVertexArray(0);
}
```

---

## Shader Uniform Patterns

### Setting Common Uniforms
```cpp
// Matrices
program->setUniformValue("modelViewProjectionMatrix", MVP);
program->setUniformValue("modelViewMatrix", MV);
program->setUniformValue("normalMatrix", N);

// Floats
program->setUniformValue("time", (float)elapsedTime);
program->setUniformValue("shininess", 64.0f);

// Vectors
program->setUniformValue("lightPosition", QVector3D(0, 10, 0));
program->setUniformValue("color", QVector4D(1, 0, 0, 1));

// Texture samplers
program->setUniformValue("colorTexture", 0);  // GL_TEXTURE0
program->setUniformValue("normalTexture", 1); // GL_TEXTURE1

// Points
program->setUniformValue("translate", point);
program->setUniformValue("scale", scale);
```

### Time-based Animation
```cpp
// In header:
QElapsedTimer elapsedTimer;

// In onPluginLoad():
elapsedTimer.start();

// In preFrame() or paintGL():
float time = elapsedTimer.elapsed() / 1000.0f;
program->setUniformValue("time", time);
```

---

## Common Shader Code

### Vertex Shader Template
```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec2 texCoord;

out vec3 V_obs;      // Vertex position in view space
out vec3 N_ver;      // Normal in view space
out vec2 vtexCoord;  // Texture coordinates

uniform mat4 modelViewMatrix;
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main()
{
    V_obs = (modelViewMatrix * vec4(vertex, 1.0)).xyz;
    N_ver = normalize(normalMatrix * normal);
    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
```

### Fragment Shader - Phong Lighting
```glsl
#version 330 core

in vec3 V_obs;
in vec3 N_ver;
in vec2 vtexCoord;

out vec4 fragColor;

// Light properties
uniform vec4 lightPosition;      // View space
uniform vec4 lightAmbient;
uniform vec4 lightDiffuse;
uniform vec4 lightSpecular;

// Material properties
uniform vec4 matAmbient;
uniform vec4 matDiffuse;
uniform vec4 matSpecular;
uniform float matShininess;

vec4 phong(vec3 L, vec3 N, vec3 V)
{
    vec4 ambient = matAmbient * lightAmbient;
    vec4 diffuse = vec4(0.0);
    vec4 specular = vec4(0.0);
    
    float NL = dot(N, L);
    if (NL > 0.0) {
        diffuse = matDiffuse * lightDiffuse * NL;
        
        vec3 R = reflect(-L, N);
        float RV = max(0.0, dot(R, V));
        specular = matSpecular * lightSpecular * pow(RV, matShininess);
    }
    
    return ambient + diffuse + specular;
}

void main()
{
    vec3 L = normalize(lightPosition.xyz - V_obs);
    vec3 N = normalize(N_ver);
    vec3 V = normalize(-V_obs);
    
    fragColor = phong(L, N, V);
}
```

### Fragment Shader - Texture Sampling
```glsl
#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

uniform sampler2D colorTexture;

void main()
{
    fragColor = texture(colorTexture, vtexCoord);
}
```

### Common Shader Input Locations
```glsl
layout (location = 0) in vec3 vertex;      // Position
layout (location = 1) in vec3 normal;      // Normal
layout (location = 2) in vec2 texCoord;    // Texture coordinates
layout (location = 3) in vec3 color;       // Vertex color
layout (location = 4) in vec3 tangent;     // Tangent (for normal mapping)
```

---

## .pro File Setup

### Basic .pro Template
```qmake
TARGET     = $$qtLibraryTarget(YourPluginName)
include(../common.pro)
```

### If common.pro Doesn't Exist
```qmake
TEMPLATE    = lib
CONFIG     += plugin
QT         += opengl
INCLUDEPATH += ..

HEADERS     = YourPlugin.h
SOURCES     = YourPlugin.cpp

TARGET      = $$qtLibraryTarget(YourPlugin)
DESTDIR     = ..
```

---

## Quick Tips & Patterns

### Accessing GLWidget Pointer
```cpp
GLWidget &g = *glwidget();  // Preferred
// or
GLWidget *widget = glwidget();
```

### Debug Output
```cpp
cout << "VS log: " << vs->log().toStdString() << endl;
cout << "Link log: " << program->log().toStdString() << endl;
cout << "FBO status: " << g.glCheckFramebufferStatus(GL_FRAMEBUFFER) << endl;
```

### Resize Viewport
```cpp
g.resize(width, height);
```

### Clear Screen
```cpp
g.glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
g.glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
```

### Enable/Disable OpenGL Features
```cpp
// Depth testing (required for proper 3D rendering)
g.glEnable(GL_DEPTH_TEST);
g.glDisable(GL_DEPTH_TEST);
g.glDepthFunc(GL_LESS);  // or GL_LEQUAL, GL_GREATER, etc.

// Alpha blending (for transparency)
g.glEnable(GL_BLEND);
g.glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);  // Standard transparency
g.glBlendFunc(GL_SRC_ALPHA, GL_ONE);  // Additive blending (for glowing effects)
g.glBlendEquation(GL_FUNC_ADD);  // How to combine source and destination
g.glDisable(GL_BLEND);

// Face culling (improves performance by not drawing back faces)
g.glEnable(GL_CULL_FACE);
g.glCullFace(GL_BACK);   // Don't draw back faces (default)
g.glCullFace(GL_FRONT);  // Don't draw front faces
g.glDisable(GL_CULL_FACE);

// Wireframe mode vs filled polygons
g.glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);  // Wireframe/edges only
g.glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);  // Solid/filled (default)
g.glPolygonMode(GL_FRONT_AND_BACK, GL_POINT); // Points only
```

### Save and Restore Polygon Mode
```cpp
// Save current polygon mode before changing it
GLint polygonMode;
g.glGetIntegerv(GL_POLYGON_MODE, &polygonMode);

// Change to wireframe
g.glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
// ... draw something in wireframe ...

// Restore previous mode
g.glPolygonMode(GL_FRONT_AND_BACK, polygonMode);
```

### Common Constants
```cpp
const int IMAGE_WIDTH = 512;
const int IMAGE_HEIGHT = 512;
const int SHADOW_MAP_SIZE = 1024;
```

### Plugin Printing Help Message
```cpp
void YourPlugin::onPluginLoad()
{
    cout << "[YourPlugin] H - Toggle feature" << endl;
    cout << "[YourPlugin] R - Reset" << endl;
    // ...
}
```

### Keyboard Handling Pattern
```cpp
void YourPlugin::keyPressEvent(QKeyEvent *e)
{
    if (e->key() == Qt::Key_H) {
        // Toggle help display
        showHelp = !showHelp;
        glwidget()->update();  // Force redraw
    }
    else if (e->key() == Qt::Key_R) {
        // Reset camera or state
        elapsedTimer.restart();
    }
    else if (e->key() == Qt::Key_W) {
        // Toggle wireframe
        wireframe = !wireframe;
    }
}
```

### Print Help Messages
```cpp
void YourPlugin::onPluginLoad()
{
    // Always print available keys to help users
    cout << "[YourPlugin] Available controls:" << endl;
    cout << "  H - Toggle help display" << endl;
    cout << "  W - Toggle wireframe mode" << endl;
    cout << "  R - Reset animation" << endl;
    cout << "  C - Copy camera to light position" << endl;
    
    // ... rest of initialization ...
}
```

### Two-Pass Rendering Pattern
```cpp
bool YourPlugin::paintGL()
{
    GLWidget &g = *glwidget();
    
    // PASS 1: Render to FBO
    g.glBindFramebuffer(GL_FRAMEBUFFER, fboId);
    g.glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    program1->bind();
    // ... set uniforms ...
    if (drawPlugin()) drawPlugin()->drawScene();
    program1->release();
    g.glBindFramebuffer(GL_FRAMEBUFFER, 0);
    
    // PASS 2: Render to screen
    g.glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    program2->bind();
    g.glActiveTexture(GL_TEXTURE0);
    g.glBindTexture(GL_TEXTURE_2D, fboTextureId);
    program2->setUniformValue("texture", 0);
    drawRect(g);
    program2->release();
    
    return true;
}
```

### Deferred Shading Pattern (G-Buffer)
```cpp
// Multiple render targets
GLenum drawBuffers[] = {
    GL_COLOR_ATTACHMENT0,  // Position
    GL_COLOR_ATTACHMENT1,  // Normal
    GL_COLOR_ATTACHMENT2   // Color + Specular
};
g.glDrawBuffers(3, drawBuffers);

// First pass: Fill G-buffer
// Second pass: Lighting calculation using G-buffer textures
```

### Include Guards
Always use include guards in header files:
```cpp
#ifndef _YOURPLUGIN_H
#define _YOURPLUGIN_H
// ... code ...
#endif
```

---

## Drawing Bounding Boxes

### Complete Bounding Box Implementation
```cpp
// In your header file:
GLuint boxVAO;
QOpenGLShaderProgram *boxProgram;

// Create the bounding box geometry (call in onPluginLoad)
void createBox(GLWidget &g) {
    g.glGenVertexArrays(1, &boxVAO);
    g.glBindVertexArray(boxVAO);
    
    // These coordinates define a unit cube (0,0,0) to (1,1,1)
    // using triangle strip for efficient rendering
    float coordinates[] = {
        1, 1, 0,    0, 1, 0,
        1, 0, 0,    0, 0, 0,
        0, 0, 1,    0, 1, 0,
        0, 1, 1,    1, 1, 0,
        1, 1, 1,    1, 0, 0,
        1, 0, 1,    0, 0, 1,
        1, 1, 1,    0, 1, 1
    };
    
    GLuint VBO;
    g.glGenBuffers(1, &VBO);
    g.glBindBuffer(GL_ARRAY_BUFFER, VBO);
    g.glBufferData(GL_ARRAY_BUFFER, sizeof(coordinates), coordinates, GL_STATIC_DRAW);
    g.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
    g.glEnableVertexAttribArray(0);
    g.glBindVertexArray(0);
}

// Draw a bounding box for an object
void drawBox(GLWidget &g, const Box &box) {
    // Get the box dimensions
    const Point &translate = box.min();  // Bottom-left-back corner
    const Point &scale = box.max() - box.min();  // Size in each dimension
    
    // Set up shader
    boxProgram->bind();
    QMatrix4x4 MVP = g.camera()->projectionMatrix() * g.camera()->viewMatrix();
    boxProgram->setUniformValue("modelViewProjectionMatrix", MVP);
    boxProgram->setUniformValue("translate", translate);
    boxProgram->setUniformValue("scale", scale);
    boxProgram->setUniformValue("color", QVector4D(1.0f, 1.0f, 0.0f, 1.0f));  // Yellow
    
    // Save current polygon mode and switch to wireframe
    GLint polygonMode;
    g.glGetIntegerv(GL_POLYGON_MODE, &polygonMode);
    g.glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    
    // Draw the box
    g.glBindVertexArray(boxVAO);
    g.glDrawArrays(GL_TRIANGLE_STRIP, 0, 14);  // 14 vertices for the strip
    g.glBindVertexArray(0);
    
    // Restore polygon mode
    g.glPolygonMode(GL_FRONT_AND_BACK, polygonMode);
    boxProgram->release();
}

// In onPluginLoad():
void onPluginLoad() {
    GLWidget &g = *glwidget();
    g.makeCurrent();
    
    // Compute bounding boxes for all objects
    for (Object &obj : g.scene()->objects())
        obj.computeBoundingBox();
    
    createBox(g);
    // ... load box shaders ...\n}\n\n// In postFrame() to draw boxes:
void postFrame() {
    GLWidget &g = *glwidget();
    
    // Draw bounding box for each object
    for (const Object &obj : g.scene()->objects()) {
        drawBox(g, obj.boundingBox());
    }
    
    // Or just for selected object
    int selectedId = g.scene()->selectedObject();
    if (selectedId >= 0) {
        drawBox(g, g.scene()->objects()[selectedId].boundingBox());
    }
}
```

### Bounding Box Vertex Shader
```glsl
// DrawBoundingBox.vert
#version 330 core

layout (location = 0) in vec3 vertex;  // Unit cube vertices (0-1)

uniform mat4 modelViewProjectionMatrix;
uniform vec3 translate;  // Box minimum corner
uniform vec3 scale;      // Box size

void main()
{
    // Transform unit cube to actual bounding box size and position
    vec3 scaledVertex = vertex * scale + translate;
    gl_Position = modelViewProjectionMatrix * vec4(scaledVertex, 1.0);
}
```

### Bounding Box Fragment Shader
```glsl
// DrawBoundingBox.frag
#version 330 core

uniform vec4 color;
out vec4 fragColor;

void main()
{
    fragColor = color;
}
```

---

## Text Rendering (2D Overlay)

### Drawing Text on Screen
```cpp
// In your header:
#include <QPainter>
QPainter painter;

// In postFrame() or a custom method:
void drawText() {
    QFont font;
    int size = 15;  // Pixel size
    font.setPixelSize(size);
    
    painter.begin(glwidget());  // Start painting
    painter.setFont(font);
    
    // Draw text at position (x, y) - top-left corner
    painter.drawText(0, 1 * size, "FPS: 60");
    painter.drawText(0, 2 * size, QString("Objects: ") + QString::number(objectCount));
    painter.drawText(0, 3 * size, QString("Vertices: ") + QString::number(vertexCount));
    
    // Multi-line text
    painter.drawText(0, 4 * size, QString("Color RGB: ") 
        + QString::number(color[0]) + " "
        + QString::number(color[1]) + " "
        + QString::number(color[2]));
    
    painter.end();  // Finish painting
}

// Call from postFrame():
void postFrame() {
    drawText();
}
```

---

## Mouse and Keyboard Events

### Keyboard Input Handling
```cpp
void keyPressEvent(QKeyEvent *e)
{
    // Check specific keys
    if (e->key() == Qt::Key_H) {
        // Toggle help display
        showHelp = !showHelp;
    }
    else if (e->key() == Qt::Key_Space) {
        // Toggle animation
        animationEnabled = !animationEnabled;
    }
    else if (e->key() == Qt::Key_R) {
        // Reset to default state
        resetState();
    }
    else if (e->key() == Qt::Key_C) {
        // Copy camera position (useful for shadow mapping)
        lightPosition = camera()->position();
    }
    else if (e->key() == Qt::Key_W) {
        // Toggle wireframe mode
        wireframeMode = !wireframeMode;
    }
    
    // Force redraw
    glwidget()->update();
}

// Common key constants:
// Qt::Key_A through Qt::Key_Z
// Qt::Key_0 through Qt::Key_9
// Qt::Key_Space, Qt::Key_Return, Qt::Key_Escape
// Qt::Key_Left, Qt::Key_Right, Qt::Key_Up, Qt::Key_Down
```

### Mouse Input Handling
```cpp
void mousePressEvent(QMouseEvent *event)
{
    GLWidget &g = *glwidget();
    g.makeCurrent();
    
    // Get mouse coordinates (convert Y coordinate)
    int x = event->x();
    int y = g.height() - event->y();  // OpenGL Y is bottom-up
    
    // Read pixel color at mouse position
    unsigned char color[3];
    glReadPixels(x, y, 1, 1, GL_RGB, GL_UNSIGNED_BYTE, color);
    cout << "Color at (" << x << ", " << y << "): "
         << (int)color[0] << " " << (int)color[1] << " " << (int)color[2] << endl;
    
    // Check mouse buttons
    if (event->button() == Qt::LeftButton) {
        // Left button clicked
    }
    else if (event->button() == Qt::RightButton) {
        // Right button clicked
    }
}

void mouseMoveEvent(QMouseEvent *event)
{
    // Called when mouse moves
    int x = event->x();
    int y = event->y();
    
    // Track mouse position
    mouseX = x;
    mouseY = y;
}
```

---

## Timers and Animation

### Using QElapsedTimer for Animation
```cpp
// In header:
#include <QElapsedTimer>
QElapsedTimer elapsedTimer;

// In onPluginLoad():
elapsedTimer.start();

// In preFrame() or paintGL():
float time = elapsedTimer.elapsed() / 1000.0f;  // Convert to seconds
program->setUniformValue("time", time);

// Periodic animation (0 to 1 and back)
float period = 2.0f;  // 2 seconds
float t = fmod(time, period);  // 0 to 2
float normalizedTime = t <= 1.0f ? t : (2.0f - t);  // 0 to 1 to 0

// Use in shader for vertex animation, color cycling, etc.
program->setUniformValue("animTime", normalizedTime);
```

### Using QTimer for Events
```cpp
// In header:
#include <QTimer>
QTimer timer;
int frameCount;

// In onPluginLoad():
frameCount = 0;
connect(&timer, SIGNAL(timeout()), this, SLOT(updateFPS()));  // Connect to slot
timer.setInterval(1000);  // 1000ms = 1 second
timer.start();

// In preFrame():
frameCount++;

// Custom slot (add to header with Q_OBJECT):
public slots:
    void updateFPS() {
        cout << "FPS: " << frameCount << endl;
        frameCount = 0;
    }
```

---

## Creating Mirror/Reflection Effects

### Basic Mirror Concept
A mirror effect requires:
1. Render the scene with a reflection transformation
2. Capture the result to a texture
3. Draw the real scene
4. Draw a textured quad (the mirror surface) with the reflected texture

### Reflection Transformations
```cpp
// Reflection across Y plane (floor mirror, Y = min.y)
QMatrix4x4 reflectionY;
reflectionY.scale(1, -1, 1);  // Flip Y axis
reflectionY.translate(0, -2 * scene()->boundingBox().min().y(), 0);

// Reflection across X plane (wall mirror, X = min.x)
QMatrix4x4 reflectionX;
reflectionX.scale(-1, 1, 1);  // Flip X axis
reflectionX.translate(-2 * scene()->boundingBox().min().x(), 0, 0);

// Reflection across Z plane (Z = min.z)
QMatrix4x4 reflectionZ;
reflectionZ.scale(1, 1, -1);  // Flip Z axis
reflectionZ.translate(0, 0, -2 * scene()->boundingBox().min().z());
```

### Complete Mirror Implementation
```cpp
// In header:
GLuint mirrorTextureId;
QOpenGLShaderProgram *mirrorProgram;  // For rendering the mirror quad

// In onPluginLoad() - Setup texture for capturing reflected scene:
GLWidget &g = *glwidget();
g.makeCurrent();

const int IMAGE_WIDTH = 512;
const int IMAGE_HEIGHT = 512;

g.glActiveTexture(GL_TEXTURE0);
g.glGenTextures(1, &mirrorTextureId);
g.glBindTexture(GL_TEXTURE_2D, mirrorTextureId);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
g.glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, IMAGE_WIDTH, IMAGE_HEIGHT, 
               0, GL_RGB, GL_FLOAT, NULL);
g.resize(IMAGE_WIDTH, IMAGE_HEIGHT);  // Resize viewport to match texture

// In paintGL() - Multi-pass rendering:
bool paintGL()
{
    GLWidget &g = *glwidget();
    
    // PASS 1: Draw reflected scene and capture to texture
    g.glClearColor(0.8f, 0.8f, 0.8f, 1.0f);
    g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    // Apply reflection transformation (floor mirror example)
    QMatrix4x4 reflection;
    reflection.scale(1, -1, 1);
    reflection.translate(0, -2 * scene()->boundingBox().min().y(), 0);
    
    // Set MVP with reflection
    g.defaultProgram()->setUniformValue("modelViewProjectionMatrix",
        camera()->projectionMatrix() * camera()->viewMatrix() * reflection);
    
    if (drawPlugin()) drawPlugin()->drawScene();
    
    // Copy framebuffer to texture
    g.glBindTexture(GL_TEXTURE_2D, mirrorTextureId);
    g.glCopyTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
    g.glGenerateMipmap(GL_TEXTURE_2D);
    
    // PASS 2: Draw real scene
    g.glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    g.defaultProgram()->setUniformValue("modelViewProjectionMatrix",
        camera()->projectionMatrix() * camera()->viewMatrix());
    
    if (drawPlugin()) drawPlugin()->drawScene();
    
    // PASS 3: Draw mirror surface (textured quad)
    Box b = scene()->boundingBox();
    
    mirrorProgram->bind();
    mirrorProgram->setUniformValue("colorMap", 0);
    mirrorProgram->setUniformValue("SIZE", float(IMAGE_WIDTH));
    mirrorProgram->setUniformValue("modelViewProjectionMatrix",
        camera()->projectionMatrix() * camera()->viewMatrix());
    
    // Bind reflection texture
    g.glBindTexture(GL_TEXTURE_2D, mirrorTextureId);
    
    // Draw quad at the mirror plane (Y = min.y for floor)
    Point V0 = b.min();
    Point V1 = Point(b.max().x(), b.min().y(), b.min().z());
    Point V2 = Point(b.max().x(), b.min().y(), b.max().z());
    Point V3 = Point(b.min().x(), b.min().y(), b.max().z());
    
    drawQuad(g, V0, V1, V2, V3);  // See helper function below
    
    mirrorProgram->release();
    g.glBindTexture(GL_TEXTURE_2D, 0);
    
    return true;
}
```

### Helper Function: Draw Textured Quad
```cpp
void drawQuad(GLWidget &g, Point V0, Point V1, Point V2, Point V3)
{
    GLuint VAO_quad;
    
    // Create VAO
    g.glGenVertexArrays(1, &VAO_quad);
    g.glBindVertexArray(VAO_quad);
    
    // Vertex coordinates in triangle strip order
    float coords[] = {
        V0.x(), V0.y(), V0.z(),
        V1.x(), V1.y(), V1.z(),
        V3.x(), V3.y(), V3.z(),
        V2.x(), V2.y(), V2.z()
    };
    
    GLuint VBO_coords;
    g.glGenBuffers(1, &VBO_coords);
    g.glBindBuffer(GL_ARRAY_BUFFER, VBO_coords);
    g.glBufferData(GL_ARRAY_BUFFER, sizeof(coords), coords, GL_STATIC_DRAW);
    g.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
    g.glEnableVertexAttribArray(0);
    g.glBindVertexArray(0);
    
    // Draw
    g.glBindVertexArray(VAO_quad);
    g.glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    g.glBindVertexArray(0);
    
    // Cleanup
    g.glDeleteBuffers(1, &VBO_coords);
    g.glDeleteVertexArrays(1, &VAO_quad);
}
```

### Mirror Quad Shaders
```glsl
// mirror.vert
#version 330 core

layout (location = 0) in vec3 vertex;
uniform mat4 modelViewProjectionMatrix;

void main()
{
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
```

```glsl
// mirror.frag
#version 330 core

out vec4 fragColor;
uniform sampler2D colorMap;
uniform float SIZE;  // Texture size (e.g., 512)

void main()
{
    // Sample texture using screen coordinates
    fragColor = texture(colorMap, gl_FragCoord.xy / SIZE);
}
```

---

## Split Screen / Multiple Viewports

### Drawing Different Content in Each Half of Screen
This technique uses `glViewport()` to divide the screen into regions, useful for:
- Side-by-side comparisons (depth vs normal, different shaders, etc.)
- Multi-view rendering
- Picture-in-picture effects

### Basic Split Screen Implementation
```cpp
bool paintGL()
{
    GLWidget &g = *glwidget();
    g.makeCurrent();
    
    // Clear entire screen
    g.glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    int w = g.width();
    int h = g.height();
    float aspect = float(w) / float(h);
    
    // Adjust camera aspect ratio for half-width viewport
    camera()->setAspectRatio(aspect / 2.0f);
    
    // LEFT HALF: Draw first view/shader
    glViewport(0, 0, w/2, h);  // x, y, width, height
    
    program1->bind();
    program1->setUniformValue("modelViewProjectionMatrix",
        camera()->projectionMatrix() * camera()->viewMatrix());
    
    if (drawPlugin()) drawPlugin()->drawScene();
    program1->release();
    
    // RIGHT HALF: Draw second view/shader
    glViewport(w/2, 0, w/2, h);  // Start at x = w/2
    
    program2->bind();
    program2->setUniformValue("modelViewProjectionMatrix",
        camera()->projectionMatrix() * camera()->viewMatrix());
    
    if (drawPlugin()) drawPlugin()->drawScene();
    program2->release();
    
    // Reset viewport to full screen (important!)
    glViewport(0, 0, w, h);
    
    return true;
}
```

### Four-Way Split Screen
```cpp
bool paintGL()
{
    GLWidget &g = *glwidget();
    int w = g.width();
    int h = g.height();
    
    g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    // Adjust aspect ratio for quarter screen
    float aspect = float(w) / float(h);
    camera()->setAspectRatio(aspect);
    
    // TOP-LEFT
    glViewport(0, h/2, w/2, h/2);
    drawView1(g);
    
    // TOP-RIGHT
    glViewport(w/2, h/2, w/2, h/2);
    drawView2(g);
    
    // BOTTOM-LEFT
    glViewport(0, 0, w/2, h/2);
    drawView3(g);
    
    // BOTTOM-RIGHT
    glViewport(w/2, 0, w/2, h/2);
    drawView4(g);
    
    // Restore full viewport
    glViewport(0, 0, w, h);
    
    return true;
}
```

### Viewport Patterns
```cpp
// Full screen
glViewport(0, 0, width, height);

// Left half
glViewport(0, 0, width/2, height);

// Right half
glViewport(width/2, 0, width/2, height);

// Top half
glViewport(0, height/2, width, height/2);

// Bottom half
glViewport(0, 0, width, height/2);

// Picture-in-picture (small view in corner)
// Bottom-right corner, 1/4 size
glViewport(3*width/4, 0, width/4, height/4);

// Top-left corner, 1/4 size
glViewport(0, 3*height/4, width/4, height/4);
```

### Example: Depth vs Normal Visualization
```cpp
bool paintGL()
{
    GLWidget &g = *glwidget();
    g.glClearColor(0, 0, 0, 0);
    g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    int w = g.width();
    int h = g.height();
    float aspect = float(w) / float(h);
    
    // Adjust camera for half-width
    camera()->setAspectRatio(aspect / 2.0f);
    
    // LEFT: Show depth buffer
    glViewport(0, 0, w/2, h);
    depthProgram->bind();
    depthProgram->setUniformValue("modelViewProjectionMatrix",
        camera()->projectionMatrix() * camera()->viewMatrix());
    
    if (drawPlugin()) drawPlugin()->drawScene();
    depthProgram->release();
    
    // RIGHT: Show normals
    glViewport(w/2, 0, w/2, h);
    normalProgram->bind();
    normalProgram->setUniformValue("modelViewProjectionMatrix",
        camera()->projectionMatrix() * camera()->viewMatrix());
    
    if (drawPlugin()) drawPlugin()->drawScene();
    normalProgram->release();
    
    // Restore viewport
    glViewport(0, 0, w, h);
    
    return true;
}
```

### Important Notes
- **Always restore viewport** after using custom viewports: `glViewport(0, 0, width, height)`
- **Adjust aspect ratio** when using non-square viewports to prevent distortion
- **Clear the entire screen** before splitting, or clear each viewport separately
- **Viewport coordinates**: `glViewport(x, y, width, height)` where (0,0) is bottom-left
- Each viewport renders independently with its own depth buffer testing

---

## Post-Processing Effects

### Basic Post-Processing Pattern
Post-processing applies effects to the rendered image using a two-pass technique:
1. Render scene to texture
2. Apply effect shader to a fullscreen quad

### Complete Post-Processing Setup
```cpp
// In header:
GLuint textureId;
QOpenGLShaderProgram *effectProgram;
const int IMAGE_WIDTH = 1024;
const int IMAGE_HEIGHT = 1024;

// In onPluginLoad():
GLWidget &g = *glwidget();
g.makeCurrent();

// Setup render-to-texture
g.glActiveTexture(GL_TEXTURE0);
g.glGenTextures(1, &textureId);
g.glBindTexture(GL_TEXTURE_2D, textureId);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
g.glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, IMAGE_WIDTH, IMAGE_HEIGHT,
               0, GL_RGB, GL_FLOAT, NULL);
g.glBindTexture(GL_TEXTURE_2D, 0);

// Resize viewport to texture size
g.resize(IMAGE_WIDTH, IMAGE_HEIGHT);

// Load effect shader
effectProgram = new QOpenGLShaderProgram(this);
// ... load and link shaders ...

// In paintGL():
bool paintGL()
{
    GLWidget &g = *glwidget();
    
    // PASS 1: Render scene to framebuffer
    g.glClearColor(0, 0, 0, 0);
    g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    if (drawPlugin()) drawPlugin()->drawScene();
    
    // Copy framebuffer to texture
    g.glBindTexture(GL_TEXTURE_2D, textureId);
    g.glCopyTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
    g.glGenerateMipmap(GL_TEXTURE_2D);
    
    // PASS 2: Apply effect to fullscreen quad
    g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    effectProgram->bind();
    effectProgram->setUniformValue("colorMap", 0);
    effectProgram->setUniformValue("time", elapsedTime);
    
    g.glBindTexture(GL_TEXTURE_2D, textureId);
    drawFullscreenQuad(g);  // See helper below
    
    effectProgram->release();
    g.glBindTexture(GL_TEXTURE_2D, 0);
    
    return true;
}
```

### Common Post-Processing Effects

**Glowing/Bloom Effect:**
```glsl
// Fragment shader for glow
uniform sampler2D colorMap;
uniform float glowIntensity;

void main()
{
    vec2 texCoord = gl_FragCoord.xy / textureSize(colorMap, 0);
    vec4 color = texture(colorMap, texCoord);
    
    // Brighten bright areas
    float brightness = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
    if (brightness > 0.8) {
        color.rgb *= glowIntensity;
    }
    
    fragColor = color;
}
```

**Distortion Effect:**
```glsl
// Wave distortion
uniform sampler2D colorMap;
uniform float time;

void main()
{
    vec2 texCoord = gl_FragCoord.xy / textureSize(colorMap, 0);
    
    // Apply wave distortion
    float offset = sin(texCoord.y * 20.0 + time * 2.0) * 0.02;
    texCoord.x += offset;
    
    fragColor = texture(colorMap, texCoord);
}
```

**CRT Effect:**
```glsl
// Scanlines and barrel distortion
uniform sampler2D colorMap;
uniform float time;

void main()
{
    vec2 texCoord = gl_FragCoord.xy / textureSize(colorMap, 0);
    
    // Barrel distortion
    vec2 center = texCoord - 0.5;
    float dist = length(center);
    texCoord = center * (1.0 + 0.2 * dist * dist) + 0.5;
    
    vec4 color = texture(colorMap, texCoord);
    
    // Scanlines
    float scanline = sin(texCoord.y * 800.0) * 0.1;
    color.rgb -= scanline;
    
    fragColor = color;
}
```

**Color Inversion:**
```glsl
uniform sampler2D colorMap;

void main()
{
    vec2 texCoord = gl_FragCoord.xy / textureSize(colorMap, 0);
    vec4 color = texture(colorMap, texCoord);
    fragColor = vec4(1.0 - color.rgb, 1.0);
}
```

---

## Shadow Mapping

### Shadow Map Technique Overview
Shadow mapping uses a depth texture rendered from the light's perspective:
1. Render scene from light's viewpoint to depth texture
2. Render scene normally, comparing fragment depth with shadow map

### Complete Shadow Map Implementation
```cpp
// In header:
GLuint shadowMapFBO;
GLuint shadowMapTexture;
QMatrix4x4 lightViewMatrix;
QMatrix4x4 lightProjectionMatrix;
const int SHADOW_MAP_SIZE = 1024;

// In onPluginLoad() - Setup shadow map:
GLWidget &g = *glwidget();
g.makeCurrent();

// Create depth texture for shadow map
g.glGenTextures(1, &shadowMapTexture);
g.glBindTexture(GL_TEXTURE_2D, shadowMapTexture);
g.glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT24, 
               SHADOW_MAP_SIZE, SHADOW_MAP_SIZE,
               0, GL_DEPTH_COMPONENT, GL_FLOAT, NULL);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

// Enable shadow comparison mode
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);
g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC, GL_LEQUAL);

// Create FBO for shadow map
g.glGenFramebuffers(1, &shadowMapFBO);
g.glBindFramebuffer(GL_FRAMEBUFFER, shadowMapFBO);
g.glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT,
                         GL_TEXTURE_2D, shadowMapTexture, 0);
g.glDrawBuffer(GL_NONE);  // No color buffer needed
g.glBindFramebuffer(GL_FRAMEBUFFER, 0);

// Setup light view/projection matrices
setupLightMatrices();

// In paintGL() - Two-pass rendering:
bool paintGL()
{
    GLWidget &g = *glwidget();
    
    // PASS 1: Render depth from light's perspective
    g.glBindFramebuffer(GL_FRAMEBUFFER, shadowMapFBO);
    g.glViewport(0, 0, SHADOW_MAP_SIZE, SHADOW_MAP_SIZE);
    g.glClear(GL_DEPTH_BUFFER_BIT);
    
    // Render with light's matrices
    g.defaultProgram()->setUniformValue("modelViewProjectionMatrix",
        lightProjectionMatrix * lightViewMatrix);
    
    if (drawPlugin()) drawPlugin()->drawScene();
    
    g.glBindFramebuffer(GL_FRAMEBUFFER, 0);
    
    // PASS 2: Render scene with shadows
    g.glViewport(0, 0, g.width(), g.height());
    g.glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    shadowProgram->bind();
    
    // Bind shadow map texture
    g.glActiveTexture(GL_TEXTURE0);
    g.glBindTexture(GL_TEXTURE_2D, shadowMapTexture);
    shadowProgram->setUniformValue("shadowMap", 0);
    
    // Pass matrices
    QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
    shadowProgram->setUniformValue("modelViewProjectionMatrix", MVP);
    
    // Shadow matrix: transforms from camera space to light space
    QMatrix4x4 shadowMatrix = lightProjectionMatrix * lightViewMatrix;
    shadowProgram->setUniformValue("shadowMatrix", shadowMatrix);
    
    if (drawPlugin()) drawPlugin()->drawScene();
    
    shadowProgram->release();
    
    return true;
}

// Helper: Setup light view/projection
void setupLightMatrices()
{
    // Position light above scene
    Point sceneCenter = scene()->boundingBox().center();
    float sceneRadius = scene()->boundingBox().radius();
    
    QVector3D lightPos(sceneCenter.x(), sceneCenter.y() + sceneRadius * 2, sceneCenter.z());
    QVector3D lookAt(sceneCenter.x(), sceneCenter.y(), sceneCenter.z());
    
    lightViewMatrix.setToIdentity();
    lightViewMatrix.lookAt(lightPos, lookAt, QVector3D(0, 1, 0));
    
    lightProjectionMatrix.setToIdentity();
    lightProjectionMatrix.ortho(-sceneRadius, sceneRadius,
                                -sceneRadius, sceneRadius,
                                0.1f, sceneRadius * 4);
}
```

### Shadow Map Fragment Shader
```glsl
#version 330 core

in vec3 V_obs;
in vec3 N_ver;
in vec4 shadowCoord;  // Position in light space

out vec4 fragColor;

uniform sampler2DShadow shadowMap;
uniform vec4 lightPosition;

void main()
{
    vec3 N = normalize(N_ver);
    vec3 L = normalize(lightPosition.xyz - V_obs);
    
    // Basic lighting
    float diff = max(0.0, dot(N, L));
    
    // Shadow lookup
    float shadow = textureProj(shadowMap, shadowCoord);
    
    // Combine lighting and shadow (shadow = 0.0 in shadow, 1.0 in light)
    vec3 color = vec3(0.2) + diff * shadow * vec3(0.8);
    
    fragColor = vec4(color, 1.0);
}
```

### Copying Camera Position to Light (Common Pattern)
```cpp
void keyPressEvent(QKeyEvent *e)
{
    if (e->key() == Qt::Key_C) {
        // Copy current camera position/orientation to light
        lightViewMatrix = camera()->viewMatrix();
        lightProjectionMatrix = camera()->projectionMatrix();
        cout << "[ShadowMap] Camera copied to light" << endl;
    }
}
```

---

## Stencil Buffer for Shadow Volumes

### Shadow Volume Technique
Uses stencil buffer to mark shadowed regions:
1. Render scene to depth buffer (color off)
2. Increment stencil for front-facing shadow volume faces
3. Decrement stencil for back-facing shadow volume faces
4. Render darkened scene where stencil != 0
5. Render lit scene where stencil == 0

### Shadow Volume Implementation
```cpp
bool paintGL()
{
    GLWidget &g = *glwidget();
    
    program->bind();
    QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
    program->setUniformValue("modelViewProjectionMatrix", MVP);
    
    g.glClearColor(1, 1, 1, 0);
    g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
    
    // STEP 1: Render scene to depth buffer only
    g.glColorMask(GL_FALSE, GL_FALSE, GL_FALSE, GL_FALSE);
    
    if (drawPlugin()) drawPlugin()->drawScene();
    
    // STEP 2: Render front faces of shadow volume to stencil
    g.glEnable(GL_STENCIL_TEST);
    g.glDepthMask(GL_FALSE);  // Don't write to depth
    g.glStencilFunc(GL_ALWAYS, 0, 0);
    g.glEnable(GL_CULL_FACE);
    g.glStencilOp(GL_KEEP, GL_KEEP, GL_INCR);  // Increment on depth pass
    g.glCullFace(GL_BACK);  // Draw only front faces
    
    g.glBindVertexArray(shadowVolumeVAO);
    g.glDrawArrays(GL_TRIANGLES, 0, shadowVolumeVertexCount);
    
    // STEP 3: Render back faces of shadow volume to stencil
    g.glStencilOp(GL_KEEP, GL_KEEP, GL_DECR);  // Decrement on depth pass
    g.glCullFace(GL_FRONT);  // Draw only back faces
    
    g.glBindVertexArray(shadowVolumeVAO);
    g.glDrawArrays(GL_TRIANGLES, 0, shadowVolumeVertexCount);
    
    // STEP 4: Render darkened scene where stencil != 0 (in shadow)
    g.glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
    g.glDepthMask(GL_TRUE);
    g.glDepthFunc(GL_LEQUAL);
    g.glStencilFunc(GL_NOTEQUAL, 0, 0xFF);  // Where stencil != 0
    g.glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);  // Don't modify stencil
    g.glDisable(GL_CULL_FACE);
    
    program->setUniformValue("darkFactor", 0.2f);  // Dark multiplier
    
    if (drawPlugin()) drawPlugin()->drawScene();
    
    // STEP 5: Render lit scene where stencil == 0 (in light)
    g.glStencilFunc(GL_EQUAL, 0, 0xFF);  // Where stencil == 0
    program->setUniformValue("darkFactor", 1.0f);  // Full brightness
    
    if (drawPlugin()) drawPlugin()->drawScene();
    
    g.glDisable(GL_STENCIL_TEST);
    program->release();
    
    return true;
}
```

### Stencil Buffer Key Functions
```cpp
// Enable stencil testing
g.glEnable(GL_STENCIL_TEST);

// Set stencil function: func(ref, value, mask)
g.glStencilFunc(GL_ALWAYS, 0, 0xFF);    // Always pass
g.glStencilFunc(GL_EQUAL, 0, 0xFF);     // Pass if stencil == 0
g.glStencilFunc(GL_NOTEQUAL, 0, 0xFF);  // Pass if stencil != 0
g.glStencilFunc(GL_LESS, 1, 0xFF);      // Pass if stencil < 1

// Set stencil operation: op(stencil fail, depth fail, depth pass)
g.glStencilOp(GL_KEEP, GL_KEEP, GL_INCR);  // Increment on depth pass
g.glStencilOp(GL_KEEP, GL_KEEP, GL_DECR);  // Decrement on depth pass
g.glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);  // Don't modify

// Clear stencil buffer
g.glClear(GL_STENCIL_BUFFER_BIT);

// Disable stencil testing
g.glDisable(GL_STENCIL_TEST);
```

---

## Texture Splatting (Multi-Texture Blending)

### Texture Splatting Concept
Blend multiple textures based on vertex attributes (like normal direction for terrain):
- Grass on flat surfaces (normal pointing up)
- Rock on steep surfaces (normal pointing sideways)
- Blend smoothly between textures

### Complete Texture Splatting Setup
```cpp
// In header:
GLuint textureId0, textureId1, textureId2;  // noise, rock, grass

// Helper: Load texture from file
void addTexture(const char *filename, GLuint *id)
{
    GLWidget &g = *glwidget();
    QImage image(filename);
    image = image.convertToFormat(QImage::Format_ARGB32).rgbSwapped().mirrored();
    
    g.glGenTextures(1, id);
    g.glBindTexture(GL_TEXTURE_2D, *id);
    g.glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 
                   image.width(), image.height(),
                   0, GL_RGBA, GL_UNSIGNED_BYTE, image.bits());
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    g.glBindTexture(GL_TEXTURE_2D, 0);
}

// In onPluginLoad():
addTexture("noise.png", &textureId0);   // Splat map/blend texture
addTexture("rock.jpg", &textureId1);    // Rock texture
addTexture("grass.png", &textureId2);   // Grass texture

// In preFrame():
void preFrame()
{
    GLWidget &g = *glwidget();
    g.makeCurrent();
    
    program->bind();
    
    // Bind all textures to different units
    g.glActiveTexture(GL_TEXTURE0);
    g.glBindTexture(GL_TEXTURE_2D, textureId0);
    g.glActiveTexture(GL_TEXTURE1);
    g.glBindTexture(GL_TEXTURE_2D, textureId1);
    g.glActiveTexture(GL_TEXTURE2);
    g.glBindTexture(GL_TEXTURE_2D, textureId2);
    
    // Set sampler uniforms
    program->setUniformValue("sampler0", 0);  // Noise/splat
    program->setUniformValue("sampler1", 1);  // Rock
    program->setUniformValue("sampler2", 2);  // Grass
    
    // Pass scene radius for texture scaling
    float radius = scene()->boundingBox().radius();
    program->setUniformValue("radius", radius);
    
    // Standard matrices
    QMatrix4x4 MVP = g.camera()->projectionMatrix() * g.camera()->viewMatrix();
    program->setUniformValue("modelViewProjectionMatrix", MVP);
    QMatrix3x3 N = g.camera()->viewMatrix().normalMatrix();
    program->setUniformValue("normalMatrix", N);
}

// In postFrame():
void postFrame()
{
    GLWidget &g = *glwidget();
    g.makeCurrent();
    
    // Unbind all textures
    g.glActiveTexture(GL_TEXTURE0);
    g.glBindTexture(GL_TEXTURE_2D, 0);
    g.glActiveTexture(GL_TEXTURE1);
    g.glBindTexture(GL_TEXTURE_2D, 0);
    g.glActiveTexture(GL_TEXTURE2);
    g.glBindTexture(GL_TEXTURE_2D, 0);
    
    g.defaultProgram()->bind();
}
```

### Texture Splatting Fragment Shader
```glsl
#version 330 core

in vec3 N_ver;
in vec3 vertexPos;

out vec4 fragColor;

uniform sampler2D sampler0;  // Noise/blend map
uniform sampler2D sampler1;  // Rock texture
uniform sampler2D sampler2;  // Grass texture
uniform float radius;

void main()
{
    vec3 N = normalize(N_ver);
    
    // Generate texture coordinates from world position
    vec2 texCoord = vertexPos.xz / (radius * 2.0);
    
    // Sample all textures
    float noise = texture(sampler0, texCoord).r;
    vec4 rock = texture(sampler1, texCoord * 4.0);    // Tiled more
    vec4 grass = texture(sampler2, texCoord * 4.0);
    
    // Blend based on normal (steep = rock, flat = grass)
    float steepness = 1.0 - abs(N.y);  // 0 = flat, 1 = steep
    
    // Use noise to add variation
    float blendFactor = mix(steepness, noise, 0.3);
    
    // Mix textures
    fragColor = mix(grass, rock, blendFactor);
}
```

---

## Scene Information and Statistics

### Getting Object Data
```cpp
void computeSceneInfo()
{
    const vector<Object> &objects = scene()->objects();
    
    int objectCount = objects.size();
    int totalVertices = 0;
    int totalFaces = 0;
    int totalTriangles = 0;
    
    for (const Object &obj : objects) {
        const vector<Vertex> &vertices = obj.vertices();
        const vector<Face> &faces = obj.faces();
        
        totalVertices += vertices.size();
        totalFaces += faces.size();
        
        // Count triangles specifically
        for (const Face &face : faces) {
            if (face.numVertices() == 3) {
                totalTriangles++;
            }
        }
    }
    
    cout << "Objects: " << objectCount << endl;
    cout << "Vertices: " << totalVertices << endl;
    cout << "Faces: " << totalFaces << endl;
    cout << "Triangles: " << totalTriangles << endl;
}
```

### Accessing Vertex Data
```cpp
const Object &obj = scene()->objects()[0];
const vector<Vertex> &vertices = obj.vertices();

for (const Vertex &v : vertices) {
    Point position = v.coord();  // Vertex position
    Vector normal = v.normal();  // Vertex normal
    Color color = v.color();     // Vertex color
}

// Access faces
const vector<Face> &faces = obj.faces();
for (const Face &face : faces) {
    int numVerts = face.numVertices();
    // Get vertex indices
    for (int i = 0; i < numVerts; i++) {
        int vertexIndex = face.vertexIndex(i);
        const Vertex &v = vertices[vertexIndex];
    }
}
```

---

## Deferred Shading / G-Buffer Rendering

### Deferred Shading Overview
Deferred shading decouples geometry from lighting by rendering in multiple passes:
1. **Geometry Pass**: Render scene geometry to multiple textures (G-buffer)
2. **Lighting Pass**: Use G-buffer textures to compute lighting on a fullscreen quad

**Advantages:**
- Lighting cost = screen pixels × number of lights (not geometry × lights)
- Efficient for many lights
- All geometric data available for post-processing

### G-Buffer Setup (3 Textures)
```cpp
// In header:
GLuint colorAndSpecularMapId;  // RGB=diffuse, A=shininess
GLuint normalMapId;             // RGB=normals
GLuint positionMapId;           // RGB=positions
GLuint gBufferFBO;
GLuint depthRBO;
const int IMAGE_WIDTH = 1024;
const int IMAGE_HEIGHT = 1024;

// In onPluginLoad() - Create G-buffer textures:
void initGbuffer()
{
    GLWidget &g = *glwidget();
    
    // Texture 1: Color + Specular
    g.glGenTextures(1, &colorAndSpecularMapId);
    g.glBindTexture(GL_TEXTURE_2D, colorAndSpecularMapId);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    g.glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, IMAGE_WIDTH, IMAGE_HEIGHT, 
                   0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    // Texture 2: Normals
    g.glGenTextures(1, &normalMapId);
    g.glBindTexture(GL_TEXTURE_2D, normalMapId);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    g.glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, IMAGE_WIDTH, IMAGE_HEIGHT,
                   0, GL_RGB, GL_UNSIGNED_BYTE, NULL);
    
    // Texture 3: Positions
    g.glGenTextures(1, &positionMapId);
    g.glBindTexture(GL_TEXTURE_2D, positionMapId);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    g.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    g.glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, IMAGE_WIDTH, IMAGE_HEIGHT,
                   0, GL_RGB, GL_UNSIGNED_BYTE, NULL);
    
    // Create FBO
    g.glGenFramebuffers(1, &gBufferFBO);
    g.glBindFramebuffer(GL_FRAMEBUFFER, gBufferFBO);
    
    // Attach textures to FBO
    g.glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                             GL_TEXTURE_2D, colorAndSpecularMapId, 0);
    g.glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT1,
                             GL_TEXTURE_2D, normalMapId, 0);
    g.glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT2,
                             GL_TEXTURE_2D, positionMapId, 0);
    
    // Create depth renderbuffer
    g.glGenRenderbuffers(1, &depthRBO);
    g.glBindRenderbuffer(GL_RENDERBUFFER, depthRBO);
    g.glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT24,
                            IMAGE_WIDTH, IMAGE_HEIGHT);
    g.glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT,
                                GL_RENDERBUFFER, depthRBO);
    
    // Specify multiple render targets (MRT)
    GLenum drawBuffers[] = {GL_COLOR_ATTACHMENT0, GL_COLOR_ATTACHMENT1, GL_COLOR_ATTACHMENT2};
    g.glDrawBuffers(3, drawBuffers);
    
    // Check FBO completeness
    if (g.glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
        cout << "G-Buffer FBO not complete!" << endl;
    
    g.glBindFramebuffer(GL_FRAMEBUFFER, 0);
}
```

### Deferred Rendering Pipeline
```cpp
bool paintGL()
{
    GLWidget &g = *glwidget();
    
    // PASS 1: Geometry Pass - Fill G-buffer
    g.glBindFramebuffer(GL_FRAMEBUFFER, gBufferFBO);
    g.glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Render scene with G-buffer shader
    gbufferProgram->bind();
    gbufferProgram->setUniformValue("modelViewProjectionMatrix",
        camera()->projectionMatrix() * camera()->viewMatrix());
    gbufferProgram->setUniformValue("modelViewMatrix",
        camera()->viewMatrix());
    gbufferProgram->setUniformValue("normalMatrix",
        camera()->viewMatrix().normalMatrix());
    
    if (drawPlugin()) drawPlugin()->drawScene();
    gbufferProgram->release();
    
    g.glBindFramebuffer(GL_FRAMEBUFFER, 0);
    
    // PASS 2: Lighting Pass - Use G-buffer textures
    g.glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    lightingProgram->bind();
    
    // Bind all G-buffer textures
    g.glActiveTexture(GL_TEXTURE0);
    g.glBindTexture(GL_TEXTURE_2D, colorAndSpecularMapId);
    lightingProgram->setUniformValue("colorAndSpecularMap", 0);
    
    g.glActiveTexture(GL_TEXTURE1);
    g.glBindTexture(GL_TEXTURE_2D, normalMapId);
    lightingProgram->setUniformValue("normalMap", 1);
    
    g.glActiveTexture(GL_TEXTURE2);
    g.glBindTexture(GL_TEXTURE_2D, positionMapId);
    lightingProgram->setUniformValue("positionMap", 2);
    
    // Pass lighting parameters
    lightingProgram->setUniformValue("lightPosition", lightPos);
    lightingProgram->setUniformValue("cameraPosition", camera()->position());
    lightingProgram->setUniformValue("SIZE", float(IMAGE_WIDTH));
    
    // Draw fullscreen quad
    drawFullscreenQuad(g);
    
    lightingProgram->release();
    
    return true;
}
```

### G-Buffer Fragment Shader (Geometry Pass)
```glsl
#version 330 core

// Multiple outputs using MRT (Multiple Render Targets)
layout(location = 0) out vec4 outColorSpecular;
layout(location = 1) out vec4 outNormal;
layout(location = 2) out vec4 outPosition;

in vec3 fragPosition;
in vec3 fragNormal;
in vec3 fragColor;
in float fragShininess;

void main()
{
    // Output 0: Color (RGB) + Shininess (A)
    outColorSpecular = vec4(fragColor, fragShininess);
    
    // Output 1: Normal (encode [-1,1] to [0,1] for storage)
    outNormal = vec4(normalize(fragNormal) * 0.5 + 0.5, 1.0);
    
    // Output 2: Position (world space or normalized)
    outPosition = vec4(fragPosition, 1.0);
}
```

### Deferred Lighting Fragment Shader
```glsl
#version 330 core

out vec4 fragColor;

uniform sampler2D colorAndSpecularMap;
uniform sampler2D normalMap;
uniform sampler2D positionMap;
uniform vec3 lightPosition;
uniform vec3 cameraPosition;
uniform float SIZE;  // Texture size

void main()
{
    // Reconstruct G-buffer data
    vec2 texCoord = gl_FragCoord.xy / SIZE;
    
    vec4 colorSpec = texture(colorAndSpecularMap, texCoord);
    vec3 diffuseColor = colorSpec.rgb;
    float shininess = colorSpec.a;
    
    vec3 normal = texture(normalMap, texCoord).rgb;
    normal = normalize(normal * 2.0 - 1.0);  // Decode from [0,1] to [-1,1]
    
    vec3 position = texture(positionMap, texCoord).rgb;
    
    // Compute lighting (Phong model)
    vec3 L = normalize(lightPosition - position);
    vec3 V = normalize(cameraPosition - position);
    vec3 R = reflect(-L, normal);
    
    float NdotL = max(0.0, dot(normal, L));
    float RdotV = max(0.0, dot(R, V));
    
    vec3 ambient = diffuseColor * 0.1;
    vec3 diffuse = diffuseColor * NdotL;
    vec3 specular = vec3(1.0) * pow(RdotV, shininess);
    
    fragColor = vec4(ambient + diffuse + specular, 1.0);
}
```

---

## GPU-Based Object Picking (Color ID Encoding)

### Concept
Render each object with a unique color encoding its ID, then read pixel color at mouse position.

### Complete Implementation
```cpp
// In header:
GLuint selectionFBO;
GLuint selectionTexture;
GLuint selectionDepthRBO;

// Encode object ID into RGB color
QVector3D encodeID(int objectID)
{
    return QVector3D(
        ((objectID >> 16) & 0xFF) / 255.0f,  // Red channel
        ((objectID >> 8) & 0xFF) / 255.0f,   // Green channel
        (objectID & 0xFF) / 255.0f           // Blue channel
    );
}

// Decode RGB color back to object ID
int decodeID(unsigned char r, unsigned char g, unsigned char b)
{
    return (r << 16) | (g << 8) | b;
}

// Mouse press event
void mousePressEvent(QMouseEvent *event)
{
    if (event->button() == Qt::RightButton && 
        event->modifiers() & Qt::ControlModifier)
    {
        GLWidget &g = *glwidget();
        int x = event->x();
        int y = g.height() - event->y();
        
        // Render scene with ID colors to FBO
        g.glBindFramebuffer(GL_FRAMEBUFFER, selectionFBO);
        g.glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        selectionProgram->bind();
        
        int id = 0;
        for (Object &obj : scene()->objects()) {
            QVector3D color = encodeID(id);
            selectionProgram->setUniformValue("objectColor", color);
            // ... render object ...
            id++;
        }
        
        // Read pixel at mouse position
        unsigned char pixel[3];
        g.glReadPixels(x, y, 1, 1, GL_RGB, GL_UNSIGNED_BYTE, pixel);
        
        int objectID = decodeID(pixel[0], pixel[1], pixel[2]);
        
        if (objectID < scene()->objects().size()) {
            scene()->setSelectedObject(objectID);
            cout << "Selected object: " << objectID << endl;
        }
        
        g.glBindFramebuffer(GL_FRAMEBUFFER, 0);
    }
}
```

### Selection Fragment Shader
```glsl
#version 330 core

out vec4 fragColor;
uniform vec3 objectColor;  // Encoded object ID

void main()
{
    fragColor = vec4(objectColor, 1.0);
}
```

---

## Geometry Shaders

### Geometry Shader Pipeline
Vertex Shader → **Geometry Shader** → Fragment Shader

Geometry shaders can:
- Generate new geometry
- Modify or discard primitives
- Change primitive type (points → triangles, etc.)

### Basic Geometry Shader Setup
```cpp
// In onPluginLoad():
vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
vs->compileSourceFile("shader.vert");

gs = new QOpenGLShader(QOpenGLShader::Geometry, this);
gs->compileSourceFile("shader.geom");

fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
fs->compileSourceFile("shader.frag");

program = new QOpenGLShaderProgram(this);
program->addShader(vs);
program->addShader(gs);  // Add geometry shader
program->addShader(fs);
program->link();
```

### Example Geometry Shader (Passthrough)
```glsl
#version 330 core

layout(triangles) in;           // Input: triangles
layout(triangle_strip, max_vertices = 3) out;  // Output: triangle strip

in vec3 vertexNormal[];  // Input from vertex shader (array)
out vec3 fragNormal;     // Output to fragment shader

void main()
{
    // Emit all 3 vertices of the input triangle
    for (int i = 0; i < 3; i++) {
        gl_Position = gl_in[i].gl_Position;
        fragNormal = vertexNormal[i];
        EmitVertex();
    }
    EndPrimitive();
}
```

### Geometry Shader for Normal Visualization
```glsl
#version 330 core

layout(triangles) in;
layout(line_strip, max_vertices = 6) out;

in vec3 vertexPosition[];
in vec3 vertexNormal[];

uniform mat4 projectionMatrix;
uniform float normalLength;

void main()
{
    // Draw normal line for each vertex
    for (int i = 0; i < 3; i++) {
        // Start point
        gl_Position = projectionMatrix * vec4(vertexPosition[i], 1.0);
        EmitVertex();
        
        // End point (along normal)
        vec3 normalEnd = vertexPosition[i] + vertexNormal[i] * normalLength;
        gl_Position = projectionMatrix * vec4(normalEnd, 1.0);
        EmitVertex();
        
        EndPrimitive();
    }
}
```

---

## Advanced Techniques from Plugins

### Indexed vs Non-Indexed Rendering (draw_smooth)
```cpp
// Toggle between rendering modes
bool useIndexedRendering = true;

void keyPressEvent(QKeyEvent *e)
{
    if (e->key() == Qt::Key_E) {
        useIndexedRendering = !useIndexedRendering;
        cout << (useIndexedRendering ? "Indexed" : "Non-indexed") << " mode" << endl;
    }
}

// Non-indexed: Duplicate vertices for flat shading per face
void createFlatShadedMesh(const Object &obj)
{
    vector<float> vertices;
    
    for (const Face &face : obj.faces()) {
        // Compute face normal
        Vector normal = computeFaceNormal(obj, face);
        
        // Add each vertex with face normal
        for (int i = 0; i < face.numVertices(); i++) {
            const Vertex &v = obj.vertices()[face.vertexIndex(i)];
            vertices.push_back(v.coord().x());
            vertices.push_back(v.coord().y());
            vertices.push_back(v.coord().z());
            vertices.push_back(normal.x());  // Same normal for all verts in face
            vertices.push_back(normal.y());
            vertices.push_back(normal.z());
        }
    }
    
    // Upload to VBO without index buffer
}
```

### Volume Calculation for Meshes
```cpp
// Compute volume using divergence theorem
float computeVolume(const Object &obj)
{
    float volume = 0.0f;
    Point centroid = faceCentroid(obj, face);  // Average of vertices
    
    for (const Face &face : obj.faces()) {
        Point c = faceCentroid(obj, face);
        Vector n = faceNormal(obj, face);
        float area = faceArea(obj, face);
        
        // Signed volume contribution
        volume += Vector::dotProduct(c - Point(0,0,0), n) * area / 3.0f;
    }
    
    return abs(volume);
}

// Compute face area using cross product
float faceArea(const Object &obj, const Face &face)
{
    const Vertex &v0 = obj.vertices()[face.vertexIndex(0)];
    const Vertex &v1 = obj.vertices()[face.vertexIndex(1)];
    const Vertex &v2 = obj.vertices()[face.vertexIndex(2)];
    
    Vector edge1 = v1.coord() - v0.coord();
    Vector edge2 = v2.coord() - v0.coord();
    
    return Vector::crossProduct(edge1, edge2).length() / 2.0f;
}
```

### Floor Detection Algorithm
```cpp
// Compute lambda ratio: upward surface area / total surface area
float computeFloorRatio(const Object &obj)
{
    float totalArea = 0.0f;
    float upwardArea = 0.0f;
    
    for (const Face &face : obj.faces()) {
        float area = faceArea(obj, face);
        Vector normal = faceNormal(obj, face);
        
        totalArea += area;
        
        // Check if normal points upward (Y component > threshold)
        if (normal.y() > 0.8f) {
            upwardArea += area;
        }
    }
    
    return totalArea > 0 ? upwardArea / totalArea : 0.0f;
}

// Use in shader for color coding
program->setUniformValue("lambda", floorRatio);

// In fragment shader:
// vec3 floorColor = vec3(0.0, 1.0, 0.0);   // Green
// vec3 notFloorColor = vec3(1.0, 0.0, 0.0); // Red
// fragColor = vec4(mix(notFloorColor, floorColor, lambda), 1.0);
```

### Object ID Uniform for Multi-Object Differentiation
```cpp
// In preFrame() or drawObject(int objID):
void drawObject(int objID)
{
    program->setUniformValue("objectID", objID);
    
    // In shader, use objectID to vary appearance
    // Example: different colors per object
}

// In fragment shader:
uniform int objectID;

void main()
{
    vec3 color = vec3(
        float(objectID % 3) / 3.0,
        float((objectID / 3) % 3) / 3.0,
        float((objectID / 9) % 3) / 3.0
    );
    fragColor = vec4(color, 1.0);
}
```

---

## Common Errors & Solutions

| Error | Solution |
|-------|----------|
| Shader compile error | Check shader syntax, print shader log |
| Black screen | Check if shader is bound, uniforms set correctly |
| FBO incomplete | Check all attachments, verify texture formats |
| Texture not showing | Verify texture binding, sampler uniforms, texture coordinates |
| Crash on load | Check glwidget() is valid, makeCurrent() called |
| Wrong transformation | Check matrix multiplication order (P * V * M) |

---

## Build Commands

### Using Makefile
```bash
make
```

### Using qmake
```bash
qmake
make
```

---

## Common Include Headers
```cpp
#include "plugin.h"
#include "glwidget.h"
#include <QOpenGLShader>
#include <QOpenGLShaderProgram>
#include <QElapsedTimer>
#include <QCoreApplication>
#include <QKeyEvent>
#include <QMouseEvent>
#include <QImage>
```

---

## Quick Checklist for New Plugin

**Initial Setup:**
- [ ] Create `.h` file with Q_OBJECT, Q_PLUGIN_METADATA, Q_INTERFACES macros
- [ ] Inherit from QObject and Plugin
- [ ] Declare shader pointers (QOpenGLShaderProgram, QOpenGLShader)
- [ ] Declare required virtual methods
- [ ] Create `.cpp` file with #include "YourPlugin.h" and "glwidget.h"
- [ ] Create `.pro` file (usually just 2 lines if common.pro exists)

**Shader Setup:**
- [ ] Create shader files (.vert, .frag) OR use inline shaders with R"""( )""" 
- [ ] Load/compile shaders in onPluginLoad()
- [ ] Print shader logs (vs->log(), fs->log(), program->log())
- [ ] Test shader compilation (check console for errors)
- [ ] Link shader program

**Rendering Pipeline:**
- [ ] Call g.makeCurrent() before OpenGL operations
- [ ] Bind program in preFrame() or paintGL()
- [ ] Set up uniforms (matrices, time, textures, etc.)
- [ ] Implement rendering logic (drawScene/drawObject/paintGL)
- [ ] Release program in postFrame() or after drawing
- [ ] Return correct boolean values from draw methods

**Common Resources:**
- [ ] Create VAO/VBO if using custom geometry
- [ ] Set up textures if needed (glGenTextures, glBindTexture)
- [ ] Create FBO if doing multi-pass rendering
- [ ] Initialize timers if animating (QElapsedTimer, QTimer)
- [ ] Set up event handlers (keyboard, mouse) if needed

**Testing:**
- [ ] Check shader compilation logs for errors
- [ ] Verify matrices are set correctly (objects appear in view)
- [ ] Test with different models/scenes
- [ ] Check console output for warnings
- [ ] Verify resources are cleaned up properly

**Common Issues to Check:**
- [ ] Called makeCurrent() before OpenGL calls?
- [ ] Shader bound before setting uniforms?
- [ ] VAO bound before drawing?
- [ ] Correct matrix multiplication order (Projection * View)?
- [ ] Textures bound to correct texture units?
- [ ] Polygon mode restored after wireframe?
- [ ] Blend/depth test enabled/disabled correctly?

---
