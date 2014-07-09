//
//  Shader.vsh
//  testopen
//
//  Created by Kévin Mondésir on 03/05/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

attribute vec4 position;

varying lowp vec4 colorVarying;

uniform vec4 changePos;
uniform mat4 modelViewProjectionMatrix;

void main()
{
    //vec3 eyeNormal = normalize(normalMatrix * normal);
    //vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    vec4 diffuseColor = vec4(0.4, 0.8, 0.4, 1.0);
    
    //float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
	
    colorVarying = diffuseColor ;//* nDotVP;
    gl_Position = modelViewProjectionMatrix * position;
	//gl_Position=position;
}
