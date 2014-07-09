//
//  SNKgameViewController2ViewController.m
//  FlappyCopy
//
//  Created by Kévin Mondésir on 07/05/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import "SNKgameViewController2.h"
#define BUFFER_OFFSET(i) ((char *)NULL + (i))
#define ARC4RANDOM_MAX 0x100000000

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
	UNIFORM_BIRD_POS,
	ROTATION,
    NUM_UNIFORMS
};
GLint uniforms2[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
	
};
GLfloat test2[8]=
{
	10.f, 2.5f, 0.0f, -0.0f,
	18.0f, 8.5f, 0.0f, -0.0f
};
/*
 0.5f,0.5f,0.0f, 	1.0f,-0.09375f,0.0f,
 0.5f,-0.5f,0.0f,	1.0f,0.0f,0.0f,
 -0.5f,-0.5f,0.0f,	0.90625f,0.0f,0.0f,
 0.5f,0.5f,0.0f,		1.0f,-0.09375f,0.0f,
 -0.5f,0.5f,0.0f,	0.90625f,-0.09375f,0.0f,
 -0.5f,-0.5f,0.0f,	0.90625f,0.0f,0.0f
 */
GLfloat sol2[36]=
{
	0.5f,0.5f,0.0f, 	0.90625f,-0.09375f,0.0f,
	0.5f,-0.5f,0.0f,	0.998f,-0.09375f,0.0f,
	-0.5f,-0.5f,0.0f,	0.998f,-0.002f,0.0f,
	0.5f,0.5f,0.0f,		0.90625f,-0.09375f,0.0f,
	-0.5f,0.5f,0.0f,	0.90625f,-0.002f,0.0f,
	-0.5f,-0.5f,0.0f,	0.998f,-0.002f,0.0f,
	
};//41176471
GLfloat base2[72]=
{
	-3.0f,0.0f,0.0f,		0.411f,0.61960f,0.0f,
	-3.0f,-2.4f,0.0f,	0.411f,0.999f,0.0f,
	-4.5f,-2.4f,0.0f,	0.001f,0.999f,0.0f,
	-3.0f,0.0f,0.0f,		0.411f,0.61960f,0.0f,
	-4.5f,0.0f,0.0f,	0.001f,0.61960f,0.0f,
	-4.5f,-2.4f,0.0f,	0.001f,0.999f,0.0f,
	
	-3.0f,-2.2f,0.0f,		0.41176471f,0.81960f,0.0f,
	-3.0f,-20.4f,0.0f,	0.41176471f,1.0f,0.0f,
	-4.5f,-20.4f,0.0f,	0.2f,1.0f,0.0f,
	-3.0f,-2.2f,0.0f,		0.41176471f,0.81960f,0.0f,
	-4.5f,-2.2f,0.0f,	0.2f,0.81960f,0.0f,
	-4.5f,-20.4f,0.0f,	0.2f,1.0f,0.0f
};
GLfloat tunnel2[144]=
{
	1.3f,0.0f,0.0f,  	0.446f,0.207f,0.0f,
	1.3f,-1.5f,0.0f,	0.446f,0.008f,0.0f,
	-1.3f,-1.5f,0.0f,	0.008f,0.008f,0.0f,
	1.3f,0.0f,0.0f,		0.446f,0.207f,0.0f,
	-1.3f,00.0f,0.0f,	0.008f,0.207f,0.0f,
	-1.3f,-1.5f,0.0f,	0.008f,0.008f,0.0f,
	
	1.3f,4.25f,0.0f,	0.446f,0.207f,0.0f,
	1.3f,5.75f,0.0f,	0.446f,0.008f,0.0f,
	-1.3f,5.75f,0.0f,	0.008f,0.008f,0.0f,
	1.3f,4.25f,0.0f,	0.446f,0.207f,0.0f,
	-1.3f,4.25f,0.0f,	0.008f,0.207f,0.0f,
	-1.3f,5.75f,0.0f,	0.008f,0.008f,0.0f,
	
	
	1.1f,-1.5f,0.0f,	0.998f,0.1725f,0.0f,
	1.1f,-100.5f,0.0f,	0.998f,0.001f,0.0f,
	-1.1f,-100.5f,0.0f,	0.596f,0.001f,0.0f,
	1.1f,-1.5f,0.0f,	0.998f,0.1725f,0.0f,
	-1.1f,-1.5f,0.0f,	0.596f,0.1725f,0.0f,
	-1.1f,-100.5f,0.0f,	0.596f,0.001f,0.0f,
	
	1.1f,5.75f,0.0f,	0.998f,0.1725f,0.0f,
	1.1f,105.75f,0.0f,	0.998f,0.001f,0.0f,
	-1.1f,105.75f,0.0f,	0.596f,0.001f,0.0f,
	1.1f,5.75f,0.0f,	0.998f,0.1725f,0.0f,
	-1.1f,5.75f,0.0f,	0.596f,0.1725f,0.0f,
	-1.1f,105.75f,0.0f,	0.596f,0.001f,0.0f
};

@interface SNKgameViewController2 () {
	GLuint programs[3];
    GLuint _program;
	
    
    GLKMatrix4 _modelViewProjectionMatrix;
	GLKVector4 _BirdPos;
	GLKVector4 _blocpos;
	GLKVector4 _temporaryvect;
	GLKMatrix4 _rotationVec;
	GLKMatrix4 _identity;
	GLKVector4 rotateVec;
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
	GLuint texture2D;
	 GLuint texName;
	GLKTextureInfo *spriteTexture;
	AVAudioPlayer * player;
	
	GLuint rotate;
	float tempstot;
	
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
- (BOOL)setupTexture:(NSString *)fileName;
@end

@implementation SNKgameViewController2
@synthesize score=score;
@synthesize adview=adview;

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
	//NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"coin" ofType:@"mp3"];
	//NSError * erreur;
	//player=[[AVAudioPlayer alloc]initWithData:[[NSFileManager defaultManager] contentsAtPath:resourcePath] fileTypeHint:AVFileTypeMPEGLayer3 error:&erreur];
	tempstot=-1;
	
	
}
- (void)respondToTapGesture:(UITapGestureRecognizer *)recognizer
{
	//GLKMatrix3 matriceTranslate=GLKMatrix3Identity;
	//matriceTranslate=GLKMatrix
	//scoreVal++;
	//GLKVector4Make(1.0, 1.0, 0.0, 0.0);

	//NSLog(@"%@",NSStringFromGLKMatrix4(_rotationVec));
	Vy=11;
	if(loose)
	{
		test2[0]=18;
		test2[4]=26;
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
	glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    //glBlendFunc(GL_ONE, GL_SRC_COLOR);
    //[self loadShaders2:0 vertexShader:@"BackgroundV" AndFragmentShader:@"BackgroundV"];
    //[self loadShaders];
	
	if([self setupTexture:@"backgroundCp2"])
		//NSLog(@"yes!!!!");
    glEnable(GL_DEPTH_TEST);
	glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
	glGenBuffers(1, &_vertexBuffer);
	glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sol2), sol2, GL_STATIC_DRAW);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
	
	
	glBindVertexArrayOES(0);
	_modelViewProjectionMatrix= GLKMatrix4Translate(GLKMatrix4MakeScale(50/self.view.bounds.size.width, 50/self.view.bounds.size.height, 1.0f), 0, -0.01*self.view.bounds.size.height, 0.0);
	_BirdPos=GLKVector4Make(-4, 15, 0, 0);
	_blocpos=GLKVector4Make(0.0, 0.0, 0.0, 0.0);
	_temporaryvect=GLKVector4Make(0.0, 0.0, 0.0, 0.0);
	_rotationVec=GLKMatrix4Identity;
	[self loadShaders2:1 vertexShader:@"Background2V" AndFragmentShader:@"BackgroundV"];
	glGenVertexArraysOES(1, &_vertexArrayBase);
    glBindVertexArrayOES(_vertexArrayBase);
	glGenBuffers(1, &_vertexBufferBase);
	glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferBase);
    glBufferData(GL_ARRAY_BUFFER, sizeof(base2), base2, GL_STATIC_DRAW);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
	glBindVertexArrayOES(0);
	
	[self loadShaders2:2 vertexShader:@"BackgroundV" AndFragmentShader:@"BackgroundV"];
	glGenVertexArraysOES(1, &_vertexArrayTunnel);
    glBindVertexArrayOES(_vertexArrayTunnel);
	glGenBuffers(1, &_vertexBufferTunnel);
	glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferTunnel);
    glBufferData(GL_ARRAY_BUFFER, sizeof(tunnel2), tunnel2, GL_STATIC_DRAW);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
	glBindVertexArrayOES(0);
	
	
	
	
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
	
	glDeleteBuffers(1, &_vertexArrayBase);
    glDeleteVertexArraysOES(1, &_vertexBufferBase);
	
	glDeleteBuffers(1, &_vertexArrayTunnel);
    glDeleteVertexArraysOES(1, &_vertexBufferTunnel);
	
	
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
	//GLuint texture=spriteTexture.name;
	glDeleteTextures(1,&texName);
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
		if(tempstot<0)
		{
			tempstot=0;
		}
		else{
			tempstot+=self.timeSinceLastUpdate;
			if(tempstot>0.08)
			{
				_BirdPos.v[2]=((int)_BirdPos.v[2]+1)%3;
				tempstot=0;
			}
		}
		//vec de base 0*1
		_blocpos.v[0]+=-self.timeSinceLastUpdate*5;
		_blocpos.v[0]=_blocpos.v[0]<-1.5?_blocpos.v[0]+1.5:_blocpos.v[0];
		test2[0]+=-6.0*self.timeSinceLastUpdate;
		test2[4]+=-6.0*self.timeSinceLastUpdate;/*
		//calcul the angle between the speed vector and the default vector
		//angle=a.b/(|a|+|b|)
		_rotation=(5/sqrtf((_BirdPos.v[0]*_BirdPos.v[0]+Vy*Vy+_BirdPos.v[2]+_BirdPos.v[2])*2))/1.2;
		//_rotation=_rotation>1?(-_rotation+2)/4:_rotation;
		_rotation=acosf(_rotation);
		//_rotation*=2*M_PI;
		//_rotation=acosf(Vy/6);
		//_rotation=Vy==0?0:_rotation;
		_rotation=Vy<0?-_rotation:_rotation;
		_rotationVec=GLKMatrix4RotateZ(GLKMatrix4Identity, _rotation);
		//rotateVec=GLKVector4Make(_rotationVec.m00, _rotationVec.m01, _rotationVec.m10, _rotationVec.m11);
		//rotateVec=GLKVector4Make(0, 0, 0, 0);
		//NSLog(@"%f° %f",(_rotation*180.0)/M_PI, 5/sqrtf((_BirdPos.v[0]*_BirdPos.v[0]+Vy*Vy+_BirdPos.v[2]+_BirdPos.v[2])*1));*/
		_rotation=3*expf(-Vy*Vy/90);
		//NSLog(@"rotation :%f",_rotation);
		_rotationVec=GLKMatrix4RotateZ(GLKMatrix4Identity, _rotation>2.0?2.0:_rotation);
		
		if(test2[4]<-8)
		{
			test2[4]=8;
			test2[5]=((double)arc4random() / ARC4RANDOM_MAX)* 6.0f
			+ 2.5f;
			wall2=YES;
		}
		if(test2[0]<-8)
		{
			test2[0]=8;
			test2[1]=((double)arc4random() / ARC4RANDOM_MAX)* 6.0f
			+ 2.5f;
			wall1=YES;
		}
		if(test2[4]<-4&&wall2)
		{
			wall2=NO;
			scoreVal++;
			[score setText:[NSString stringWithFormat:@"%d",scoreVal]];
			//[player play];
		}
		if(test2[0]<-4&&wall1)
		{
			wall1=NO;
			scoreVal++;
			[score setText:[NSString stringWithFormat:@"%d",scoreVal]];
			//[player play];
		}
		if(test2[0]>-5.85&&test2[0]<-2.15)
		{
			if(_BirdPos.v[1]<test2[1]+0.5||_BirdPos.v[1]>test2[1]+3.75)
			{
				loose=YES;
			}
		}
		if(test2[4]>-5.85&&test2[4]<-2.15)
		{
			if(_BirdPos.v[1]<test2[5]+0.5||_BirdPos.v[1]>test2[5]+3.75)
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
    
    glEnable(GL_TEXTURE_2D);
	
	//on dessine les tunnels
	glBindVertexArrayOES(_vertexArrayTunnel);
    glUseProgram(programs[2]);
    
    glUniformMatrix4fv(uniforms2[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
	glUniform4fv(uniforms2[UNIFORM_BIRD_POS], 1, test2);
    
	glDrawArrays(GL_TRIANGLES, 0, 24);
	
	glUniform4fv(uniforms2[UNIFORM_BIRD_POS], 1, test2+4);
    
	glDrawArrays(GL_TRIANGLES, 0, 24);
	
	glClear(GL_DEPTH_BUFFER_BIT);
	//on dessine le sol
	glBindVertexArrayOES(_vertexArrayBase);
    //glUseProgram(programs[0]);
	glUniformMatrix4fv(uniforms2[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
	for (int i=-4; i<9; i++) {
		_temporaryvect.v[0]=i*1.49+_blocpos.v[0];
		glUniform4fv(uniforms2[UNIFORM_BIRD_POS], 1, _temporaryvect.v);
		glDrawArrays(GL_TRIANGLES, 0, 12);
	}
    
	//glDisable(GL_TEXTURE_2D);
	glClear(GL_DEPTH_BUFFER_BIT);
	//on dessine le piaf
	glUseProgram(programs[1]);
	glBindVertexArrayOES(_vertexArray);
    GLKMatrix4MakeZRotation(2);
	
    glUniformMatrix4fv(rotate, 1,0, _rotationVec.m);
    glUniformMatrix4fv(uniforms2[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0,  _modelViewProjectionMatrix.m);
	glUniform4fv(uniforms2[UNIFORM_BIRD_POS], 1, _BirdPos.v);
    //
	
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
    //if (programIndex!=1) {
		//NSLog(@"%@",vertexShader);
		glBindAttribLocation(programs[programIndex], GLKVertexAttribTexCoord0, "textureCoord");
	//}
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
    uniforms2[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(programs[programIndex], "modelViewProjectionMatrix");
	
	
	if(programIndex!=1)
		uniforms2[UNIFORM_BIRD_POS]=glGetUniformLocation(programs[programIndex], "changePos");
	
		texture2D = glGetUniformLocation(programs[programIndex], "myTextureSampler");
		glActiveTexture(GL_TEXTURE0);
		glBindTexture(GL_TEXTURE_2D, texName);
		glUniform1i(texture2D, 0);
	
    if(programIndex==1){
		rotate=glGetUniformLocation(programs[programIndex], "modelViewProjectionMatrix2");
		//NSLog(@"vals %d  %d %d %d",texture2D, rotate,uniforms2[UNIFORM_BIRD_POS],uniforms2[UNIFORM_MODELVIEWPROJECTION_MATRIX]);
		
	}
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
    uniforms2[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms2[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
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
- (BOOL)setupTexture:(NSString *)fileName
{
	/*
	NSError *theError;
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"]; // 1
	
	spriteTexture = [GLKTextureLoader textureWithContentsOfFile:filePath options:nil error:&theError]; // 2
	glBindTexture(spriteTexture.target, spriteTexture.name);
	glEnable(spriteTexture.target);
	
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	
    //glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
	*/
	CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
	
    // 2
    GLsizei width = (GLsizei)CGImageGetWidth(spriteImage);
    GLsizei height = (GLsizei)CGImageGetHeight(spriteImage);
	
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
	
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
													   CGImageGetColorSpace(spriteImage),(CGBitmapInfo) kCGImageAlphaPremultipliedLast);
	
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
	
    CGContextRelease(spriteContext);
	
    // 4
   
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
	
    //glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 0);
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 0);
	glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
	glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
	
    free(spriteData);
	return YES;
}

#pragma mark -AdBanner methods
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
