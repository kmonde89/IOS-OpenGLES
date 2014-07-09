//
//  SNKWhiteTile.h
//  FlappyCopy
//
//  Created by Kévin Mondésir on 12/05/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <GLKit/GLKMath.h>
#import <iAd/iAd.h>

@interface SNKWhiteTile : GLKViewController<UIGestureRecognizerDelegate,ADBannerViewDelegate>
- (void)respondToTapGesture:(UITapGestureRecognizer *)recognizer;
@end
