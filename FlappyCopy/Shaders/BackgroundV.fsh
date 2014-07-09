//
//  Shader.vsh
//  testopen
//
//  Created by Kévin Mondésir on 03/05/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

uniform sampler2D myTextureSampler;
varying lowp vec2 textureCoordOut;
void main()
{
	gl_FragColor=vec4(textureCoordOut,1.0,1.0);
    gl_FragColor = texture2D( myTextureSampler,textureCoordOut).rgba; //*texture( myTextTexture, Textcoord ).rgba;
}
