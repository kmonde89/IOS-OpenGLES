//
//  Shader.vsh
//  testopen
//
//  Created by Kévin Mondésir on 03/05/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

attribute vec2 textureCoord;
attribute vec4 position;
varying lowp vec2 textureCoordOut;
//varying lowp vec4 colorVarying;

uniform vec4 changePos;
uniform mat4 modelViewProjectionMatrix;

void main()
{
    //vec3 eyeNormal = normalize(normalMatrix * normal);
    //vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    //vec4 diffuseColor = vec4(0.8, 0.4, 1.0, 1.0);
    
    //float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
	textureCoordOut=textureCoord;
    //colorVarying = diffuseColor ;//* nDotVP;
    gl_Position = modelViewProjectionMatrix * (position+vec4(changePos[0],changePos[1],0,0));
	//gl_Position=position;
}