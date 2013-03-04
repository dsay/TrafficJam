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

@property (weak, nonatomic) IBOutlet UILabel *roundNumber;
@property (nonatomic, strong)DSGameView *rock1;

@end

@implementation DSViewController

@synthesize rock1 = rock1;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    rock1 = [[DSGameView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];
    rock1.newRound = ^ (int number){
        self.roundNumber.text = [NSString stringWithFormat:@"%d", number];
    };
 
    [self.view addSubview:rock1];
}
- (IBAction)ctrZ:(id)sender
{
    [rock1 cancelMove];
}
- (IBAction)anewRound:(id)sender
{
    [rock1 enewRound];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setRoundNumber:nil];
    [super viewDidUnload];
}
@end
