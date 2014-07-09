//
//  SNKWhiteTile.m
//  FlappyCopy
//
//  Created by Kévin Mondésir on 12/05/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import "SNKWhiteTile.h"
#import <MediaPlayer/MediaPlayer.h>
#define BUFFER_OFFSET(i) ((char *)NULL + (i))
#define ARC4RANDOM_MAX 0x100000000
enum
{
	UNIFORM_MODELVIEWPROJECTION_MATRIX,
	UNIFORM_MODELVIEWPROJECTION_MATRIX2,
	UNIFORM_POS1,
	UNIFORM_POS2,
	ROTATION,
	NUM_UNIFORMS
};
GLint uniforms3[NUM_UNIFORMS];
GLfloat Tile[18]=
{
	0.99f,0.99f,0.0f,
	0.99f,-0.99f,0.0f,
	-0.99f,-0.99f,0.0f,
	0.99f,0.99f,0.0f,
	-0.99f,0.99f,0.0f,
	-0.99f,-0.99f,0.0f
	
};
@interface SNKWhiteTile (){
	GLuint programs[3];
    GLuint _program;
	
    
    GLKMatrix4 _modelViewProjectionMatrix;
	GLKVector4 _BirdPos;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
	
	int scoreVal;
	GLuint backgroundTexture;
	float Vitesse;
	float positionY;
	BOOL loose;
	BOOL start;
	int test;
	float tableau[5][4];
	CGPoint blackTiles[5];
	int score;
	
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders2:(int)programIndex vertexShader:(NSString *) vertexShader AndFragmentShader:(NSString *) fragmentShader;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation SNKWhiteTile

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)respondToTapGesture:(UITapGestureRecognizer *)recognizer
{
	//GLKMatrix3 matriceTranslate=GLKMatrix3Identity;
	//matriceTranslate=GLKMatrix
	//scoreVal++;
	//GLKVector4Make(1.0, 1.0, 0.0, 0.0);
	start=YES;
	//NSLog(@"%@",NSStringFromGLKMatrix4(_rotationVec));
	CGPoint position=[recognizer locationInView:self.view];
	position.x=floor(4*position.x/self.view.bounds.size.width);
	position.y=floor(4.0-4*position.y/self.view.bounds.size.height -(positionY+2*test)/2);
	//NSLog(@"%f %f  %f",position.x,position.y,(positionY+2*test)/2);
	if(blackTiles[(int)position.y].x==position.x)
		blackTiles[(int)position.y].y=1.0f;
	if (tableau[(int)position.y][(int)position.x]==0) {
		tableau[(int)position.y][(int)position.x]+=1;
	}
	else if (tableau[(int)position.y][(int)position.x]==2)
	{
		tableau[(int)position.y][(int)position.x]+=1;
	}
	if(loose)
	{
		positionY=0.0f;
		Vitesse=4.0;
		
		for (int i=0; i<5; i++) {
			for (int j=0; j<4; j++) {
				tableau[i][j]=0;
			}
			
			blackTiles[i]=CGPointMake(((double)arc4random() / ARC4RANDOM_MAX)* 4.0f, 0);
			blackTiles[i].x=floor( blackTiles[i].x);
			tableau[i][(int)floor( blackTiles[i].x)]=2;
		}
		start=NO;
		loose=NO;
		score=0;
		/*
		MPMusicPlayerController * ipod = [MPMusicPlayerController iPodMusicPlayer];
		[ipod stop];*/
		[self dismissViewControllerAnimated:NO completion:nil];
	}
	
	
	
	//NSLog(@"%f %f",position.x,position.y);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
	positionY=1.9f;
	Vitesse=4.0;
	test=0;
	start=NO;
	score=0;
	
	for (int i=0; i<5; i++) {
		for (int j=0; j<4; j++) {
			tableau[i][j]=0;
		}
		
		blackTiles[i]=CGPointMake(((double)arc4random() / ARC4RANDOM_MAX)* 4.0f, 0);
		blackTiles[i].x=floor( blackTiles[i].x);
		tableau[i][(int)floor( blackTiles[i].x)]=2;
	}
	MPMusicPlayerController * ipod = [MPMusicPlayerController iPodMusicPlayer];
	//[ipod beginSeekingBackward];
	[ipod play];
	
	
	/*for (int i=0; i<5; i++) {
		blackTiles[i]=CGPointMake(((double)arc4random() / ARC4RANDOM_MAX)* 4.0f, 0);
		blackTiles[i].x=floor( blackTiles[i].x);	}*/
	
}
/*
-(void)viewWillAppear:(BOOL)animated
{
	MPMusicPlayerController * ipod = [MPMusicPlayerController iPodMusicPlayer];
	//[ipod beginSeekingBackward];
	[ipod play];
}
-(void)viewDidAppear
{
	
}*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
	 glEnable(GL_DEPTH_TEST);
	[self loadShaders2:0 vertexShader:@"Tile" AndFragmentShader:@"Shader"];
	[self loadShaders2:1 vertexShader:@"BlackTile" AndFragmentShader:@"Shader"];
	
    
   
	glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
	glGenBuffers(1, &_vertexBuffer);
	glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Tile), Tile, GL_STATIC_DRAW);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
	glBindVertexArrayOES(0);
	_modelViewProjectionMatrix= GLKMatrix4Translate(GLKMatrix4MakeScale(1/4.0, 1.0/4.0, 1.0f), -3, -3, 0.0);
	//_BirdPos=GLKVector4Make(-4, 15, 0, 0);
	test=0;
	
	
}
- (void)update
{
	if(start){
		if(!loose){
			positionY+=-2*Vitesse*self.timeSinceLastUpdate;
			Vitesse=8.0-4*exp(positionY/2000);
		}
		if(test<-(int)positionY/2)
		{
			for (int i=0; i<4; i++) {
				if(((int)tableau[0][i])==1)
					loose=YES;
			}/*
			  if(blackTiles[0].y<0.1)
			  {
			  loose=YES;
			  }*/
			
			for (int i=0; i<4; i++) {
				for (int j=0; j<4; j++) {
					tableau[i][j]=tableau[i+1][j];
				}
				blackTiles[i]=blackTiles[i+1];
			}
			for (int j=0; j<4; j++) {
				tableau[4][j]=0;
			}
			blackTiles[4]=CGPointMake(((double)arc4random() / ARC4RANDOM_MAX)* 4.0f, 0);
			//NSLog(@"%f %f",blackTiles[4].x,blackTiles[4].y);
			blackTiles[4].x=floor( blackTiles[4].x);
			tableau[4][(int)floor( blackTiles[4].x)]=2;
			//NSLog(@"%f %f",blackTiles[4].x,blackTiles[4].y);
			test=-positionY/2;
			if(!loose)
				score++;
		}
	}
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.25f, 0.875f, 0.8125f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	//NSLog(@"test");
	glBindVertexArrayOES(_vertexArray);
    glUseProgram(programs[0]);
    
    glUniformMatrix4fv(uniforms3[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    //glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
	
	for (int i=0; i<4; i++) {
		for (int j=0; j<5; j++) {
			glUniform4fv(uniforms3[UNIFORM_POS1], 1, GLKVector4Make(i*2, positionY+j*2+2*test, tableau[j][i], 0).v);
			
			glDrawArrays(GL_TRIANGLES, 0, 12);
		}
	}
	
	
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
    
	
	
	if(programIndex==0)
	{
		uniforms3[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(programs[programIndex], "modelViewProjectionMatrix");
		uniforms3[UNIFORM_POS1]=glGetUniformLocation(programs[programIndex], "changePos");
	}
	if(programIndex==1)
	{
		uniforms3[UNIFORM_MODELVIEWPROJECTION_MATRIX2] = glGetUniformLocation(programs[programIndex], "modelViewProjectionMatrix");
		uniforms3[UNIFORM_POS2]=glGetUniformLocation(programs[programIndex], "changePos");
		
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
