//
//  ViewController.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/17/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ViewController.h"



@interface ViewController () <UITextFieldDelegate>

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Start locationManager
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }

    
    self.searchText.delegate = self;
    _mapView.delegate = self;
    [self.locationManager startUpdatingLocation];
    _mapView.showsUserLocation = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Map Actions

- (IBAction)zoomIn:(id)sender {
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 20000, 20000);
    [_mapView setRegion:region];
}

- (IBAction)changeMapType:(id)sender {
    if (_mapView.mapType == MKMapTypeStandard) {
        _mapView.mapType = MKMapTypeHybrid;
    } else {
        _mapView.mapType = MKMapTypeStandard;
    }
}

- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
    [_mapView removeAnnotations:[_mapView annotations]];
    [self performSearch];
}



#pragma Search

- (void)performSearch {
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    request.naturalLanguageQuery = _searchText.text;
    request.region = _mapView.region;
    
    _matchingItems = [[NSMutableArray alloc]init];
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    NSLog(@"MKLocalSearch array created");
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0) {
            NSLog(@"No Matches Found");
        } else {
            for (MKMapItem *item in response.mapItems) {
                [_matchingItems addObject:item];
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                [_mapView addAnnotation:annotation];
            }
        }
    }];
}


#pragma MKMapViewDelegate methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    // Check authorization status (with class method)
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // User has never been asked to decide on location authorization
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Requesting when in use auth");
        [self.locationManager requestWhenInUseAuthorization];
    }
    // User has denied location use (either for this app or for all apps
    else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"Location services denied");
        // Alert the user and send them to the settings to turn on location
    }
}

@end