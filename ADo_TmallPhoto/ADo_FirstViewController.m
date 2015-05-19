//
//  ADo_FirstViewController.m
//  ADo_TmallPhotoAlbum
//
//  Created by 杜 维欣 on 15/5/19.
//  Copyright (c) 2015年 ADo. All rights reserved.
//

#import "ADo_FirstViewController.h"
#import "ADo_SecondViewController.h"
@interface ADo_FirstViewController ()
- (IBAction)openAlbum;

@end

@implementation ADo_FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)openAlbum {
    ADo_SecondViewController *secVC = [[ADo_SecondViewController alloc] init];
    UINavigationController *nextVC = [[UINavigationController alloc] initWithRootViewController:secVC];
    [self presentViewController:nextVC animated:YES completion:nil];
}
@end
