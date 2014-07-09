//
//  Shader.fsh
//  testopen
//
//  Created by Kévin Mondésir on 03/05/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//
//uniform mat4 rotation2;
//uniform sampler2D myTextureSampler;
varying lowp vec4 colorVarying;
void main()
{
    gl_FragColor = colorVarying; //*texture( myTextTexture, Textcoord ).rgba;
}
