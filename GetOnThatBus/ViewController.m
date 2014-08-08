//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Chris Snyder on 8/5/14.
//  Copyright (c) 2014 Chris Snyder. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "routeDetailsViewController.h"



@interface ViewController ()<MKMapViewDelegate>
@property NSMutableArray *stopArray;
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property NSMutableDictionary *busStopDictionary;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadJSON];

    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 41.896775;
    zoomLocation.longitude = -87.623295;

    MKCoordinateRegion viewRegion =MKCoordinateRegionMakeWithDistance(zoomLocation, 10000, 10000);
    [self.myMapView setRegion:viewRegion];
}

-(void)loadJSON
{
    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.busStopDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.stopArray = [self.busStopDictionary objectForKey:@"row"];
        [self loadAnnotations];
    }];
}
-(void)loadAnnotations
{
    for (NSDictionary *d in self.stopArray) {
        MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
        NSString *latString = d[@"latitude"];
        NSString *longString = d[@"longitude"];
        CLLocationDegrees longitude;
        if ([longString hasPrefix:@"-"])
        {
            longitude = [longString doubleValue];
        }
        else{
            longitude = -[longString doubleValue];
        }
        CLLocationDegrees latitude = [latString doubleValue];
        NSLog(@"%f", latitude);
        point.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        point.title = d[@"cta_stop_name"];
        point.subtitle = d[@"routes"];
        [self.myMapView addAnnotation:point];
    }
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return  pin;

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    routeDetailsViewController *vc = segue.destinationViewController;
    vc.title = [self.busStopDictionary objectForKey:@"cta_stop_name"];
    vc.stop = self.busStopDictionary;

}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
    
    
}
@end
