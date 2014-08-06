//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Chris Snyder on 8/5/14.
//  Copyright (c) 2014 Chris Snyder. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "MapViewAnnotation.h"
#import "routeDetailsViewController.h"


@interface ViewController ()<MKMapViewDelegate>
@property NSArray *busStops;
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property NSDictionary *selectedStop;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.busStops = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError] objectForKey:@"row"];
        for (NSDictionary *busStop in self.busStops) {
            MapViewAnnotation *stop = [[MapViewAnnotation alloc] init];
            stop.dictionary1 = busStop;
            [self.myMapView addAnnotation:stop];
        }
        [self.myMapView showAnnotations:self.myMapView.annotations animated:YES];
    }];

}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return  pin;

}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MapViewAnnotation *selectedAnnotation = (MapViewAnnotation *)view.annotation;
    self.selectedStop = selectedAnnotation.dictionary1;
    [self performSegueWithIdentifier:@"detailSegue" sender:self];


}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    routeDetailsViewController *vc = segue.destinationViewController;
    vc.title = [self.selectedStop objectForKey:@"cta_stop_name"];
    vc.stop = self.selectedStop;
}

@end
