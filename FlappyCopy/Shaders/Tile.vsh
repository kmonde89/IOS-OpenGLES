//
//  Tile.vsh
//  testopen
//
//  Created by Kévin Mondésir on 03/05/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

attribute vec4 position;
uniform vec4 changePos;
varying lowp vec4 colorVarying;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    //vec4 diffuseColor = vec4(0.94921875, 0.94140625, 0.890625, 1.0);
	if(int(changePos[2])==1){
		//Tile error
		colorVarying = vec4(0.734375,0.2734375,0.33203125,1.0);
	}
	else if(int(changePos[2])==2)
	{
		//blackTile
		colorVarying=vec4(0.125, 0.124, 0.124, 1.0);
	}
	else if(int(changePos[2])==3)
	{
		//BlackTile Valide
		colorVarying=vec4(0.8046875,0.8046875,0.8046875,1.0);
	}
	else{
		//white Tile
		colorVarying = vec4(0.94921875, 0.94140625, 0.890625, 1.0);
	}
    
    gl_Position = modelViewProjectionMatrix * (position+vec4(changePos[0],changePos[1],0,0));
}