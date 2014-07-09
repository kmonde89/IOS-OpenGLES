//
//  SNKViewController.h
//  FlappyCopy
//
//  Created by Kévin Mondésir on 04/05/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SNKViewController : UIViewController <UIGestureRecognizerDelegate>
{
	AVSpeechSynthesizer * speechSynthetizer;
}
- (void)respondToTapGesture:(UITapGestureRecognizer *)recognizer;
- (void)respondToSwipeGesture:(UISwipeGestureRecognizer *)recognizer;
- (void)respondToSwipeGestureTop:(UISwipeGestureRecognizer *)recognizer;
- (void)respondToSwipeGestureDetailled:(UISwipeGestureRecognizer *)recognizer;
@end
