//
//  ViewController.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/17/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _mapView.delegate = self;
    [self.locationManager startUpdatingLocation];
    _mapView.showsUserLocation = YES;
}

-(void) viewWillAppear:(BOOL)animated{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Map Methods

//Zooms in according to the region, using MKCoordinateRegion to center the location of the device in MKMapView

-(IBAction)zoomIn:(id)sender{
    MKUserLocation *currentLocation = _mapView.userLocation;
    MKCoordinateRegion currentRegion = MKCoordinateRegionMakeWithDistance(currentLocation.location.coordinate, 10000, 10000);
    [_mapView setRegion:currentRegion];
}

-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

//Why is this method required?

-(IBAction)changeMapType:(id)sender{
    if (_mapView.mapType == MKMapTypeStandard) {
        _mapView.mapType = MKMapTypeHybrid;
    }else{
        _mapView.mapType = MKMapTypeStandard;
    }
    
}

@end
