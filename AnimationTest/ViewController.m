//
//  ViewController.m
//  AnimationTest
//
//  Created by Christopher Guess on 12/18/13.
//  Copyright (c) 2013 What Is Up Labs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIView * _slideImageView;
    CAGradientLayer * _gradientLayer;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:[self addAnimatingSwipeScreen]];
}

- (UIView*)addAnimatingSwipeScreen
{
    //Create text image
    UIImage * text = [UIImage imageNamed:@"loading_copy_white"];
    UIImageView * maskedImageView = [[UIImageView alloc] initWithImage:text];
    
    //Create a holder view with the same dimensions as the text image
    _slideImageView = [[UIView alloc] initWithFrame:maskedImageView.frame];
    CGRect frame = _slideImageView.frame;
    //"center" the holder view
    frame.origin = CGPointMake(385.0f, 360.0f);
    _slideImageView.frame = frame;
    
    //Create the colors we want to animate
    UIColor * blackColor = [UIColor blackColor];
    UIColor * greenColor  = [UIColor colorWithRed:167.0f/255.0f green:245.0f/0.0f blue:81.0f/255.0f alpha:1.0f];
    
    //Add them to an array, as needed for a CAGradientLayer
    NSArray * colors = @[(id)[blackColor CGColor], (id)[greenColor CGColor], (id)[blackColor CGColor]];
    
    //Create gradient layer
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = maskedImageView.bounds;
    _gradientLayer.colors = colors;
    
    //set starting locations for the colors
    NSArray * startingLocations = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.4f]];
    _gradientLayer.startPoint = CGPointMake(0.0f, 0.3f);
    _gradientLayer.endPoint = CGPointMake(1.0f, 0.5f);
    _gradientLayer.locations = startingLocations;
    
    //add the text image as a mask on the gradient layer
    _gradientLayer.mask = maskedImageView.layer;
    
    //add the gradient layer to the holder view
    [_slideImageView.layer addSublayer:_gradientLayer];
    
    //Create animation for the "locations" aspect of the gradient layer
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"locations"];
    //Set the starting locations to the previously applied array
    fadeAnim.fromValue = _gradientLayer.locations;
    //create new to value for the animation
    fadeAnim.toValue = @[[NSNumber numberWithFloat:0.8f], [NSNumber numberWithFloat:1.0f]];
    //the delegate for this animation to call at the end is self
    fadeAnim.delegate = self;
    
    //Fill it in correctly at the end
    [fadeAnim setFillMode:kCAFillModeForwards];
    // 3 seconds of run time
    [fadeAnim setDuration:3.0f];
    
    //linear and straight timing since we want it smooth
    [fadeAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    //do the magic and apply the animation
    [_gradientLayer addAnimation:fadeAnim forKey:@"animation"];
    
    //This is a test animation that does work corretcly in changing the colors
    /*
    CABasicAnimation* fadeAnim1 = [CABasicAnimation animationWithKeyPath:@"colors"];
    fadeAnim1.toValue = @[(id)[UIColor greenColor].CGColor,(id)[transparentColor CGColor],(id)[UIColor blueColor].CGColor];
    fadeAnim1.duration = 5.0;
    [_gradientLayer addAnimation:fadeAnim1 forKey:@"colorAnimation"];
    */
    
    return _slideImageView;
}

//This is called after the animation finishes
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *keyPath = ((CAPropertyAnimation *)anim).keyPath;
    if ([keyPath isEqualToString:@"locations"]) {
        //This properly sets the locations and updates the view correctly
        _gradientLayer.locations = ((CABasicAnimation *)anim).toValue;
    }
}

@end
