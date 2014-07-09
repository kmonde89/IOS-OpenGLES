//
//  BlackTile.vsh
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
    vec4 diffuseColor = vec4(0.125, 0.124, 0.124, 1.0);
	vec4 valide=vec4(0.8046875,0.8046875,0.8046875,1.0);
	if(int(changePos[2])>0){
		colorVarying=valide;
	}
	else{
		colorVarying = diffuseColor;
	}
    gl_Position = modelViewProjectionMatrix * (position+vec4(changePos[0],changePos[1],0,0));
}