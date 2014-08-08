//
//  routeDetailsViewController.m
//  GetOnThatBus
//
//  Created by Chris Snyder on 8/5/14.
//  Copyright (c) 2014 Chris Snyder. All rights reserved.
//

#import "routeDetailsViewController.h"

@interface routeDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stopAddress;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;

@property (weak, nonatomic) IBOutlet UILabel *transferLabel;
@end

@implementation routeDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [self.stop objectForKey:@"cta_stop_name"];
    self.stopAddress.text = [self.stop objectForKey:@"cta_stop_name"];
    self.routeLabel.text = [self.stop objectForKey:@"routes"];
    self.transferLabel.text = [self.stop objectForKey:@"inter_modal"];
}



@end
