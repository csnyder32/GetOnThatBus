//
//  MapViewAnnotation.m
//  GetOnThatBus
//
//  Created by Chris Snyder on 8/5/14.
//  Copyright (c) 2014 Chris Snyder. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

- (NSString *)title;
{
    return [self.dictionary1 objectForKey:@"cta_stop_name"];
}

- (NSString *)subtitle
{
    return [self.dictionary1 objectForKey:@"routes"];
}

- (CLLocationCoordinate2D)coordinate
{
    double latitude = [[self.dictionary1 objectForKey:@"latitude"] doubleValue];
    double longitude = -fabs([[self.dictionary1 objectForKey:@"longitude"] doubleValue]);

    return CLLocationCoordinate2DMake(latitude, longitude);
}


@end
