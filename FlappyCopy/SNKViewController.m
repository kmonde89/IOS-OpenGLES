//
//  SNKViewController.m
//  FlappyCopy
//
//  Created by Kévin Mondésir on 04/05/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import "SNKViewController.h"

@interface SNKViewController ()
@end

@implementation SNKViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
											 initWithTarget:self action:@selector(respondToTapGesture:)];
	tapRecognizer.numberOfTapsRequired = 1;
	[self.view addGestureRecognizer:tapRecognizer];
	UISwipeGestureRecognizer *SwipeRecognizer = [[UISwipeGestureRecognizer alloc]
											 initWithTarget:self action:@selector(respondToSwipeGesture:)];
	SwipeRecognizer.numberOfTouchesRequired=1;
	SwipeRecognizer.direction=UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:SwipeRecognizer];
	
	
	UISwipeGestureRecognizer *SwipeRecognizerD = [[UISwipeGestureRecognizer alloc]
												 initWithTarget:self action:@selector(respondToSwipeGestureDetailled:)];
	SwipeRecognizerD.numberOfTouchesRequired=1;
	SwipeRecognizerD.direction=UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:SwipeRecognizerD];
	
	UISwipeGestureRecognizer *SwipeRecognizerTop = [[UISwipeGestureRecognizer alloc]
												  initWithTarget:self action:@selector(respondToSwipeGestureTop:)];
	SwipeRecognizerTop.numberOfTouchesRequired=1;
	SwipeRecognizerTop.direction=UISwipeGestureRecognizerDirectionDown;
	[self.view addGestureRecognizer:SwipeRecognizerTop];
	speechSynthetizer=[AVSpeechSynthesizer new];
	
	
}
- (void)respondToSwipeGestureTop:(UISwipeGestureRecognizer *)recognizer
{
	[self performSegueWithIdentifier:@"topSwipe" sender:self];
}
- (void)respondToSwipeGesture:(UISwipeGestureRecognizer *)recognizer
{
	//NSLog(@"2");
	[self performSegueWithIdentifier:@"swip" sender:self];
}
- (void)respondToSwipeGestureDetailled:(UISwipeGestureRecognizer *)recognizer
{
	//NSLog(@"2");
	[self performSegueWithIdentifier:@"swipLeft" sender:self];
}
- (void)respondToTapGesture:(UITapGestureRecognizer *)recognizer
{
	NSLog(@"test");
	if(speechSynthetizer.isSpeaking)
	{
		
	}
	else{
		AVSpeechUtterance * speechUtterance=[[AVSpeechUtterance alloc]initWithString:@"Good . morning Sunshine!"];
		//speechUtterance=[[AVSpeechUtterance alloc]initWithString:@"Mon nom est Christina,      je suis canadienne parce que je le vaux bien"];
		[speechUtterance setRate:0.3f];
		NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
		speechUtterance.postUtteranceDelay=0.3f;
		speechUtterance.voice=[AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
		
		[speechSynthetizer speakUtterance:speechUtterance];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
