//
//  Shader.vsh
//  testopen
//
//  Created by Kévin Mondésir on 03/05/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

attribute vec4 position;

//varying lowp vec4 colorVarying;

//uniform mat4 rotation;
uniform vec4 changePos;
uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewProjectionMatrix2;
attribute vec2 textureCoord;
varying lowp vec2 textureCoordOut;
void main()
{
    //vec3 eyeNormal = normalize(normalMatrix * normal);
    //vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    //vec4 diffuseColor = vec4(0.8, 0.7, 1.0, 1.0);
    
    //float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
	//position=rotation*position;
	//vec4 test=rotation*vec4(1,1,1,1);
    //colorVarying = diffuseColor;// *rotation;//* nDotVP;
	textureCoordOut=textureCoord+changePos[2]*vec2(0,-0.09375);
    gl_Position = modelViewProjectionMatrix*(vec4(changePos[0],changePos[1],0,0)+modelViewProjectionMatrix2 * position);
	//gl_Position=position;
}


