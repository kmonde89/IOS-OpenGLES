//
//  Shader.fsh
//  testopen
//
//  Created by Kévin Mondésir on 03/05/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
