//
//  ViewController.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/17/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

// Location properties
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

// Interface properties
@property (strong, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) NSMutableArray *matchingItems;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)zoomIn:(id)sender;
- (IBAction)changeMapType:(id)sender;
- (IBAction)textFieldReturn:(id)sender;

@end

