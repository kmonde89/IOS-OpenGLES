//
//  SNKgameViewController.h
//  FlappyCopy
//
//  Created by Kévin Mondésir on 04/05/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <GLKit/GLKMath.h>
#import <iAd/iAd.h>

@interface SNKgameViewController : GLKViewController<UIGestureRecognizerDelegate,ADBannerViewDelegate>
@property IBOutlet UILabel * score;
@property IBOutlet UILabel * gameOver;
@property  IBOutlet ADBannerView * adview;
- (void)respondToTapGesture:(UITapGestureRecognizer *)recognizer;

@end
