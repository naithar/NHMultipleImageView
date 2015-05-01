//
//  NViewController.m
//  NHMultipleImageView
//
//  Created by Naithar on 05/01/2015.
//  Copyright (c) 2014 Naithar. All rights reserved.
//

#import "NViewController.h"
#import <NHMultiImageView.h>

@interface NViewController ()

@end

@implementation NViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    NHMultiImageView *view = [[NHMultiImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];

    [self.view addSubview:view];
//    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    view.imageCount = 1;

    [view addImage:[UIImage imageNamed:@"img6"] toIndex:2];
    
    [view addImage:[UIImage imageNamed:@"img6"] toIndex:1];
//
    [view addImage:[UIImage imageNamed:@"img6"] toIndex:0];
        [view addImage:[UIImage imageNamed:@"img6"] toIndex:3];
        [view addImage:[UIImage imageNamed:@"img6"] toIndex:0];
            [view addImage:[UIImage imageNamed:@"img6"] toIndex:0];
    [view addImage:[UIImage imageNamed:@"img6"] toIndex:0];





}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
