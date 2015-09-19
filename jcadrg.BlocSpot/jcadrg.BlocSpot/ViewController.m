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



- (void)viewWillAppear:(BOOL)animated {

    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;

    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    self.searchTextField.delegate =self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Current location is %@", _location);
    _mapView.delegate = self;

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

#pragma mark - searching methods

-(IBAction)searhTextFieldReturn:(id)sender{
    
    NSLog(@"TextFieldReturns");
    [sender resignFirstResponder];
    [_mapView removeAnnotations:[_mapView annotations]];
    [self doSearch];
}

-(void) doSearch{
    MKLocalSearchRequest *localSearchRequest = [[MKLocalSearchRequest alloc] init];
    localSearchRequest.naturalLanguageQuery = _searchTextField.text;
    localSearchRequest.region = _mapView.region;
    
    _matchingItems = [[NSMutableArray alloc] init];
    
    MKLocalSearch *localSearch =[[MKLocalSearch alloc] initWithRequest:localSearchRequest];
    NSLog(@"Local search created!");
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *searchResponse, NSError *error){
        if (searchResponse.mapItems.count == 0) {
            NSLog(@"No matching elements found");
        }else{
            for (MKMapItem *mapItem in searchResponse.mapItems) {
                [_matchingItems addObject:mapItem];
                MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
                pointAnnotation.coordinate = mapItem.placemark.coordinate;
                pointAnnotation.title = mapItem.name;
                [_mapView addAnnotation:pointAnnotation];
            }
        }
            
    
    }];
    
}



#pragma MKMapViewDelegate methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    _mapView.centerCoordinate = userLocation.location.coordinate;
    
}

#pragma mark - User Location

-(void) mapViewWillStartLocatingUser:(MKMapView *)mapView{
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    
    
    if (authStatus == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Requesting always authorization");
        [self.locationManager requestAlwaysAuthorization];
    
    }else if (authStatus ==kCLAuthorizationStatusDenied){
        NSLog(@"Location services denied");
    }
    
}


@end