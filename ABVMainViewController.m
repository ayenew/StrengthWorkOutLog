//
//  ABVMainViewController.m
//  StrengthWorkoutLog
//
//  Created by ayenew on 1/31/14.
//  Copyright (c) 2014 com.ayenew. All rights reserved.
//

#import "ABVMainViewController.h"

@interface ABVMainViewController ()

@property (weak, nonatomic) IBOutlet ADBannerView *banner;
@end

@implementation ABVMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.banner setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - iAD
- (void)bannerViewWillLoadAd:(ADBannerView *)banner  NS_AVAILABLE_IOS(5_0){
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    [UIView commitAnimations];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
}

@end
