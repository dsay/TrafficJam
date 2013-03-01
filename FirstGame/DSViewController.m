//
//  DSViewController.m
//  FirstGame
//
//  Created by Dima on 2/26/13.
//  Copyright (c) 2013 Dima Sai. All rights reserved.
//

#import "DSViewController.h"
#import "DSGameView.h"

@interface DSViewController ()

@end

@implementation DSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    DSGameView *rock1 = [[DSGameView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];
    
    
//    DSRock *rock2 = [[DSRock alloc] initWithBranchCount:3 directionToDown:NO];
//    
//    
    [self.view addSubview:rock1];
//    [self.view addSubview:rock2];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
