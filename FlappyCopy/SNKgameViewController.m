//
//  SNKgameViewController.m
//  FlappyCopy
//
//  Created by Kévin Mondésir on 04/05/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import "SNKgameViewController.h"
#define BUFFER_OFFSET(i) ((char *)NULL + (i))
#define ARC4RANDOM_MAX 0x100000000
typedef  struct _TextTextureStruct
{
	GLuint vertCount;
	GLuint indexCount;
	GLuint vertsID;
	GLuint textID;
	GLuint indicesID;
}quadricText;
// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
	UNIFORM_BIRD_POS,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};
GLfloat test[8]=
{
	10.f, 2.5f, 0.0f, -0.0f,
	18.0f, 8.5f, 0.0f, -0.0f
};
GLfloat sol[18]=
{
	0.5f,0.5f,0.0f,
	0.5f,-0.5f,0.0f,
	-0.5f,-0.5f,0.0f,
	0.5f,0.5f,0.0f,
	-0.5f,0.5f,0.0f,
	-0.5f,-0.5f,0.0f
	
};
GLfloat base[18]=
{
	100.5f,0.0f,0.0f,
	100.5f,-40.5f,0.0f,
	-100.5f,-40.5f,0.0f,
	100.5f,0.0f,0.0f,
	-100.5f,0.0f,0.0f,
	-100.5f,-40.5f,0.0f
};
GLfloat tunnel[36]=
{
	1.3f,0.0f,0.0f,
	1.3f,-200.0f,0.0f,
	-1.3f,-200.0f,0.0f,
	1.3f,0.0f,0.0f,
	-1.3f,00.0f,0.0f,
	-1.3f,-200.0f,0.0f,
	
	1.3f,4.25f,0.0f,
	1.3f,200.0f,0.0f,
	-1.3f,200.0f,0.0f,
	1.3f,4.25f,0.0f,
	-1.3f,4.25f,0.0f,
	-1.3f,200.0f,0.0f
};
/*
GLfloat gCubeVertexData[324] =
{
    // Data layout for each line below is:
    // positionX, positionY, positionZ,     normalX, normalY, normalZ,
    0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f, 	1.0f, -1.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,   	-1.0f, -1.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,  	1.0f, 1.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,	1.0f, 1.0f, 0.0f,
    0.5f, 0.5f, -0.5f,          1.0f, 0.0f, 0.0f,	-1.0f, -1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,		-1.0f, 0.0f, 0.0f,
    
    0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,	1.0f, -1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,	-1.0f, -1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,	1.0f, 1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,	1.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,	-1.0f, -1.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,	-1.0f, 1.0f, 0.0f,
    
    -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,	1.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,	-1.0f, -1.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,	1.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,	1.0f, 1.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,	-1.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,	-1.0f, 1.0f, 0.0f,
    
    -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,	1.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,	-1.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,	1.0f, 1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,	1.0f, 1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,	-1.0f, -1.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
    
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,	1.0f, -1.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,	-1.0f, -1.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,	1.0f, 1.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,	1.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,	-1.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,	-1.0f, 1.0f, 0.0f,
    
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,	1.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,	-1.0f, -1.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,	1.0f, 1.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,	1.0f, 1.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,	-1.0f, -1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f,	-1.0f, 1.0f, 0.0f
};*/

@interface SNKgameViewController () {
	GLuint programs[3];
	//quadricText background;
    GLuint _program;
	
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
	GLKVector4 _BirdPos;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
	
	GLuint _vertexArrayBase;
    GLuint _vertexBufferBase;
	
	GLuint _vertexArrayTunnel;
	GLuint _vertexBufferTunnel;
	int scoreVal;
	GLuint backgroundTexture;
	float Vy;
	BOOL wall1,wall2;
	BOOL loose;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)loadShaders2:(int)programIndex vertexShader:(NSString *) vertexShader AndFragmentShader:(NSString *) fragmentShader;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end
@implementation SNKgameViewController
@synthesize score=score;
@synthesize adview=adview;

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	//NSLog(@"bonjour");
	[banner setAlpha:1];
	[adview setHidden:NO];
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	//NSLog(@"bye");
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	[adview setHidden:YES];
	[banner setAlpha:0];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	/*
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
	if (self.context == nil) {
		self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	}*/
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableMultisample=GLKViewDrawableMultisample4X;
    [self setupGL];
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
											 initWithTarget:self action:@selector(respondToTapGesture:)];
	tapRecognizer.numberOfTapsRequired = 1;
	[self.view addGestureRecognizer:tapRecognizer];
	scoreVal=0;
	[score setText:[NSString stringWithFormat:@"%d",scoreVal]];
	self.adview.delegate=self;
	[adview setHidden:YES];
	Vy=0;
	loose=NO;
	wall1=YES;wall2=YES;
	[self.gameOver setHidden:YES];
	self.pauseOnWillResignActive=YES;
	self.resumeOnDidBecomeActive=YES;
}
- (void)respondToTapGesture:(UITapGestureRecognizer *)recognizer
{
	//scoreVal++;
	
	NSLog(@"posY : %lf",_BirdPos.v[1]);
	Vy=11;
	if(loose)
	{
		test[0]=18;
		test[4]=26;
		[self dismissViewControllerAnimated:NO completion:nil];
	}
}

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
	
    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    [self loadShaders2:0 vertexShader:@"Background" AndFragmentShader:@"Background"];
    //[self loadShaders];
    /*
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
    */
    glEnable(GL_DEPTH_TEST);
	glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
	glGenBuffers(1, &_vertexBuffer);
	glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sol), sol, GL_STATIC_DRAW);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
	glBindVertexArrayOES(0);
	_modelViewProjectionMatrix= GLKMatrix4Translate(GLKMatrix4MakeScale(50/self.view.bounds.size.width, 50/self.view.bounds.size.height, 1.0f), 0, -0.01*self.view.bounds.size.height, 0.0);
	_BirdPos=GLKVector4Make(-4, 15, 0, 0);
	
	[self loadShaders2:1 vertexShader:@"Background2" AndFragmentShader:@"Background"];
	glGenVertexArraysOES(1, &_vertexArrayBase);
    glBindVertexArrayOES(_vertexArrayBase);
	glGenBuffers(1, &_vertexBufferBase);
	glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferBase);
    glBufferData(GL_ARRAY_BUFFER, sizeof(base), base, GL_STATIC_DRAW);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
	glBindVertexArrayOES(0);
	
	[self loadShaders2:2 vertexShader:@"Background3" AndFragmentShader:@"Background"];
	glGenVertexArraysOES(1, &_vertexArrayTunnel);
    glBindVertexArrayOES(_vertexArrayTunnel);
	glGenBuffers(1, &_vertexBufferTunnel);
	glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferTunnel);
    glBufferData(GL_ARRAY_BUFFER, sizeof(tunnel), tunnel, GL_STATIC_DRAW);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
	glBindVertexArrayOES(0);
	
	
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    self.effect = nil;
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
	for(int i=0;i<3;i++)
	{
		if (programs[i]) {
			glDeleteProgram(programs[i]);
			programs[i] = 0;
		}
	}
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
	Vy+=-0.5*50*self.timeSinceLastUpdate;
	_BirdPos.v[1]+=Vy*self.timeSinceLastUpdate;
	if(loose)
	{
		_BirdPos.v[1]=_BirdPos.v[1]<0.501?0.5:_BirdPos.v[1];
		[self.gameOver setHidden:NO];
		//loose=YES;
	}
	else{
		test[0]+=-6.0*self.timeSinceLastUpdate;
		test[4]+=-6.0*self.timeSinceLastUpdate;
		if(test[4]<-8)
		{
			test[4]=8;
			test[5]=((double)arc4random() / ARC4RANDOM_MAX)* 6.0f
			+ 2.5f;
			wall2=YES;
		}
		if(test[0]<-8)
		{
			test[0]=8;
			test[1]=((double)arc4random() / ARC4RANDOM_MAX)* 6.0f
			+ 2.5f;
			wall1=YES;
		}
		if(test[4]<-4&&wall2)
		{
			wall2=NO;
			scoreVal++;
			[score setText:[NSString stringWithFormat:@"%d",scoreVal]];
		}
		if(test[0]<-4&&wall1)
		{
			wall1=NO;
			scoreVal++;
			[score setText:[NSString stringWithFormat:@"%d",scoreVal]];
		}
		if(test[0]>-5.85&&test[0]<-2.15)
		{
			if(_BirdPos.v[1]<test[1]+0.5||_BirdPos.v[1]>test[1]+3.75)
			{
				loose=YES;
			}
		}
		if(test[4]>-5.85&&test[4]<-2.15)
		{
			if(_BirdPos.v[1]<test[5]+0.5||_BirdPos.v[1]>test[5]+3.75)
			{
				loose=YES;
			}
		}
		if(_BirdPos.v[1]<=0.501)
		{
			loose=YES;
		}
		
	}
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.95f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
	
	//on dessine les tunnels
	glBindVertexArrayOES(_vertexArrayTunnel);
    glUseProgram(programs[2]);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    //glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
	glUniform4fv(uniforms[UNIFORM_BIRD_POS], 1, test);
    
	glDrawArrays(GL_TRIANGLES, 0, 12);
	
	glUniform4fv(uniforms[UNIFORM_BIRD_POS], 1, test+4);
    
	glDrawArrays(GL_TRIANGLES, 0, 12);
	
	glClear(GL_DEPTH_BUFFER_BIT);
	//on dessine le sol
	glBindVertexArrayOES(_vertexArrayBase);
    glUseProgram(programs[1]);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    //glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
    
	glDrawArrays(GL_TRIANGLES, 0, 6);
	glClear(GL_DEPTH_BUFFER_BIT);
	//on dessine le piaf
	glBindVertexArrayOES(_vertexArray);
    glUseProgram(programs[0]);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
	glUniform4fv(uniforms[UNIFORM_BIRD_POS], 1, _BirdPos.v);
    
	glDrawArrays(GL_TRIANGLES, 0, 6);
}

#pragma mark -  OpenGL ES 2 shader compilation
- (BOOL)loadShaders2:(int)programIndex vertexShader:(NSString *) vertexShader AndFragmentShader:(NSString *) fragmentShader
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    programs[programIndex] = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:vertexShader ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:fragmentShader ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(programs[programIndex], vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(programs[programIndex], fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(programs[programIndex], GLKVertexAttribPosition, "position");
    
    // Link program.
    if (![self linkProgram:programs[programIndex]]) {
        NSLog(@"Failed to link program: %d", programs[programIndex]);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (programs[programIndex]) {
            glDeleteProgram(programs[programIndex]);
            programs[programIndex] = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(programs[programIndex], "modelViewProjectionMatrix");
	if(programIndex!=1)
		uniforms[UNIFORM_BIRD_POS]=glGetUniformLocation(programs[programIndex], "changePos");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(programs[programIndex], vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(programs[programIndex], fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}
- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "normal");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}
/*
- (void)setupTexture:(NSString *)fileName
{
	//initialisation des variable
	size_t width;size_t height;
	GLubyte * spriteData;
	CGContextRef spriteContext ;
    // Chargement de l'image
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
	
    // 2
    width = CGImageGetWidth(spriteImage);
    height = CGImageGetHeight(spriteImage);
	
     spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
	
    spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
													   CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
	
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
	
    CGContextRelease(spriteContext);
	
    // 4
    glGenTextures(1, &backgroundTexture);
    glBindTexture(GL_TEXTURE_2D, backgroundTexture);
	
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width,(GLsizei) height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
	
    free(spriteData);
}*/
@end
