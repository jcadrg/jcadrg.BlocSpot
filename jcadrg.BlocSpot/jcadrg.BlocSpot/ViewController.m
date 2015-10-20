//
//  ViewController.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/17/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ViewController.h"
#import "UIBarButtonItem+FlatUI.h"
#import "NSString+Icons.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "FlatUIKit.h"
#import "UIPopoverController+FlatUI.h"


#import "POITableViewController.h"
#import "SearchViewController.h"

#import "Annotation.h"
#import "AnnotationView.h"


#import "POI.h"
#import "FPPopoverController.h"
#import "SMCalloutView.h"

#import "CustomIOSAlertView.h"
#import "WYPopoverController.h"

#import "CategoryViewController.h"

#import "CallOutView.h"
#import "CallOutInnerView.h"

#import "PopUpCategoriesViewController.h"





typedef NS_ENUM(NSInteger, ViewControllerState){
    ViewControllerStateMapContent, ViewControllerStateAddPOI
};




@interface ViewController () <MKMapViewDelegate, UIViewControllerTransitioningDelegate, UISearchBarDelegate, UISearchControllerDelegate, UITabBarControllerDelegate, UIGestureRecognizerDelegate, AnnotationViewDelegate, WYPopoverControllerDelegate, CategoryViewControllerDelegate, SMCalloutViewDelegate, CallOutInnerViewDelegate, PopUpCategoriesViewControllerDelegate, POITableViewControllerDelegate>{
    
    CallOutView *_callOutView;
}



@property(nonatomic, strong) POITableViewController *poiTableVC;
@property(nonatomic, strong) SearchViewController *searchVC;
@property(nonatomic, strong) NSMutableArray *matchingItems;


@property(nonatomic, strong) UISearchController *searchController;


@property(nonatomic, strong) CLLocation *location;
@property(nonatomic, strong) UIBarButtonItem *searchButton;
@property(nonatomic, strong) UIBarButtonItem *filterButton;
@property(nonatomic, strong) UIBarButtonItem *listButton;
@property(nonatomic, strong) UIBarButtonItem *labelButton;

@property(nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic, strong) UILongPressGestureRecognizer *longTapRecognizer;


@property(nonatomic, strong) POI *poi;
@property(nonatomic, strong) NSMutableDictionary *parameters;
@property(nonatomic, assign) CLLocationCoordinate2D coordinates;
@property(nonatomic, assign) CGPoint point;
@property(nonatomic, strong) MKAnnotationView *annotationView;


@property(nonatomic, assign) ViewControllerState state;

@property(nonatomic, strong) CategoryViewController *categoryVC;
@property(nonatomic, strong) PopUpCategoriesViewController *categoryPopupVC;
@property(nonatomic, strong) WYPopoverController *popover;

@property(nonatomic, strong) Categories *category;
@property(nonatomic, strong) UINavigationController *navVC;


@property (nonatomic, strong) NSMutableArray *annotationArray;
@property (nonatomic, strong) UIColor *chosenColor;


@property(nonatomic, strong) NSMutableArray *poiTemporaryArray;
@property(nonatomic, strong) NSMutableDictionary *categoryDictionary;

@property(nonatomic, strong) SMCalloutView *calloutView;

@property(nonatomic, assign) CGFloat currentLocationLatitude;
@property(nonatomic, assign) CGFloat currentLocationLongitude;


@end

static NSString *viewID = @"LikeAnnotation";

@implementation ViewController


-(instancetype)init {
    self = [super init];
    if (self)
    {
        
    }
    return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    // set the tab bar color
    self.poiTableVC =[[POITableViewController alloc]init];
    self.poiTableVC.tableDelegate = self;
    self.navigationItem.hidesBackButton = YES;
    
    // create a mapview
    self.mapView = [[MKMapView alloc]init];
    self.mapView.userInteractionEnabled =YES;
    [self.mapView setDelegate:self];
    [self.view addSubview:self.mapView ];
    //    [self loadAnnotations];
    self.mapView.showsUserLocation = YES;
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    self.tapRecognizer.delegate = self;
    self.tapRecognizer.numberOfTapsRequired = 1;
    
    self.longTapRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(createAnnotation:)];
    self.longTapRecognizer.delegate = self;
    self.longTapRecognizer.minimumPressDuration = 0.5;
    [self.mapView addGestureRecognizer:self.longTapRecognizer];
    
    [self.mapView addGestureRecognizer:self.tapRecognizer];
    
    self.category = [[Categories alloc]init];
    [self updateLocation];
    [self createConstraints];
    
    [self createTabBarButtons];
    [self createListViewBarButton];
    
    if(!_categoryVC){
        self.categoryVC = [[CategoryViewController alloc]init];
        self.categoryVC.delegate = self;
        self.categoryVC.navigationItem.title = @"Add a Category";
    }
    self.navVC = [[UINavigationController alloc]initWithRootViewController:self.categoryVC];
    
    if(!_categoryPopupVC){
        self.categoryPopupVC = [[PopUpCategoriesViewController alloc]init];
        self.categoryPopupVC.popupDelegate = self;
    }
    UINavigationController *navVCPopup =[[UINavigationController alloc]initWithRootViewController:self.categoryPopupVC];
    UIBarButtonItem *leftBarButtonPopup = [[UIBarButtonItem alloc]initWithTitle:@"Filter" style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(popupBarButtonItemDonePressed:)];
    UIBarButtonItem *rightBarButtonPopup = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancelFilterCategoryPressed:)];
    
    self.categoryPopupVC.navigationItem.leftBarButtonItem = leftBarButtonPopup;
    self.categoryPopupVC.navigationItem.rightBarButtonItem = rightBarButtonPopup;
    
    self.categoryPopupVC.navigationItem.title = @"Filter by Category";
    
    
    if (!_popover){
        self.popover = [[WYPopoverController alloc]initWithContentViewController:navVCPopup];
        self.popover.delegate = self;
        self.popover.popoverContentSize = CGSizeMake(self.popover.contentViewController.view.frame.size.width, 44*7 + 20);
        
    }
    [self.mapView addAnnotations:[self createAnnotations]];
    
    
    //View that will create a new POI
    if (!_createAnnotationView) {
        self.createAnnotationView = [[AnnotationView alloc]init];
        self.createAnnotationView.delegate = self;
        
    }
    if (!_category){
        self.category = [[Categories alloc]init];
    }
    
    
    self.state = ViewControllerStateMapContent;
    if(!self.parameters){
        self.parameters = [NSMutableDictionary new];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[DataSource sharedInstance] addDictionary:[self calculateDistanceFromCurrentLoaction:self.locationManager.location.coordinate.latitude andLongitude:self.locationManager.location.coordinate.longitude]];
        NSLog(@"[BLCDataSource sharedInstance].distanceValuesDic : %@", [DataSource sharedInstance].distanceValuesDictionary);
        
    });
    
    
    
    
}

- (NSMutableArray *)createAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for (POI *poi in [DataSource sharedInstance].annotations)
    {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(poi.annotation.latitude, poi.annotation.longitude);
        poi.annotation = [[Annotation alloc]initWithCoordinate:coord];
        [annotations addObject:poi.annotation];
    }
    return annotations;
    
}


-(void)layoutViews {
    switch (self.state) {
        case ViewControllerStateMapContent: {
            
            [self.createAnnotationView setHidden:YES];
            [self.createAnnotationView resignFirstResponder];
            self.mapView.scrollEnabled = YES;
            [self.navigationController.navigationBar setHidden:NO];
            
            
        } break;
        case ViewControllerStateAddPOI: {
            [self.createAnnotationView removeGestureRecognizer:self.tapRecognizer];
            [self.mapView addSubview:self.createAnnotationView];
            self.createAnnotationView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.createAnnotationView setHidden:NO];
            self.mapView.scrollEnabled = NO;
            [self setLayoutOfCreateAnnotationView];
            [self.navigationController.navigationBar setHidden:YES];
            
            
        } break;
    }
    
    
}



-(void) setLayoutOfCreateAnnotationView
{
    [self.mapView addConstraints:({
        @[ [NSLayoutConstraint
            constraintWithItem:_createAnnotationView
            attribute:NSLayoutAttributeCenterX
            relatedBy:NSLayoutRelationEqual
            toItem:self.mapView
            attribute:NSLayoutAttributeCenterX
            multiplier:1.f constant:0.f],
           
           [NSLayoutConstraint
            constraintWithItem:_createAnnotationView
            attribute:NSLayoutAttributeCenterY
            relatedBy:NSLayoutRelationEqual
            toItem:self.mapView
            attribute:NSLayoutAttributeCenterY
            multiplier:1.f constant:0] ];
    })];
    NSLayoutConstraint *viewHeightConstraint = [NSLayoutConstraint constraintWithItem:_createAnnotationView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0
                                                                             constant:(44*4)+ 100];
    [self.mapView addConstraint:viewHeightConstraint ];
    NSLayoutConstraint *viewWidthConstraint = [NSLayoutConstraint constraintWithItem:_createAnnotationView
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:CGRectGetWidth(self.view.bounds)- 20];
    [self.mapView addConstraint:viewWidthConstraint];
}

-(void) setLayoutCategoriesVC
{
    [self.mapView addConstraints:({
        @[ [NSLayoutConstraint
            constraintWithItem:_categoryVC
            attribute:NSLayoutAttributeCenterX
            relatedBy:NSLayoutRelationEqual
            toItem:self.mapView
            attribute:NSLayoutAttributeCenterX
            multiplier:1.f constant:0.f],
           
           [NSLayoutConstraint
            constraintWithItem:_categoryVC
            attribute:NSLayoutAttributeCenterY
            relatedBy:NSLayoutRelationEqual
            toItem:self.mapView
            attribute:NSLayoutAttributeCenterY
            multiplier:1.f constant:0] ];
    })];
    NSLayoutConstraint *viewHeightConstraint = [NSLayoutConstraint constraintWithItem:_categoryVC
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0
                                                                             constant:(44*4)+ 100];
    [self.mapView addConstraint:viewHeightConstraint ];
    NSLayoutConstraint *viewWidthConstraint = [NSLayoutConstraint constraintWithItem:_categoryVC
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:CGRectGetWidth(self.view.bounds)- 20];
    [self.mapView addConstraint:viewWidthConstraint];
}


-(void)createListViewBarButton {
    UILabel *label = [[UILabel alloc]init];
    label.attributedText = [self titleLabelString];
    
    
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGFLOAT_MAX);
    CGSize labelMaxSize = [label sizeThatFits:maxSize];
    
    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, labelMaxSize.width, labelMaxSize.height)];
    label.frame = CGRectMake(0, 0, labelMaxSize.width, labelMaxSize.height);
    
    [customView addSubview:label];
    //    _labelBarButton = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
    UIImage *listImage = [UIImage imageNamed:@"list_filled"];
    self.listButton = [[UIBarButtonItem alloc]initWithImage:listImage
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(listViewPressed:)];
    [_listButton setTintColor:[UIColor cloudsColor]];
    self.navigationItem.leftBarButtonItem = _listButton;
    self.navigationItem.titleView = customView;
    
    [_listButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                                    highlightedColor:[UIColor wetAsphaltColor]
                                        cornerRadius:3];
    
}





#pragma mark - Overrides

-(void)setState:(ViewControllerState)state animated:(BOOL)animated {
    _state = state;
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self layoutViews];
                         }];
    } else {
        [self layoutViews];
    }
    
}
-(void)setState:(ViewControllerState)state{
    [self setState:state animated:NO];
}

#pragma Location delegate methods call


- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        self.locationManager=[[CLLocationManager alloc] init];
        self.locationManager.delegate=self;
        
        self.locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
        [self.locationManager requestWhenInUseAuthorization];
    }
    return _locationManager;
}

-(void)updateLocation {
    [self.locationManager startUpdatingLocation];
    
    
}
// TO DO
-(void)fetchVenuesForLocation:(CLLocation *)location {
    
}

-(void)zoomToLocation:(CLLocation *)location radius:(CGFloat)radius {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, radius*2, radius*2);
    [self.mapView setRegion:region];
    
}
-(void)zoomToCoordinate:(CLLocationCoordinate2D )coordinate radius:(CGFloat)radius {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, radius*2, radius*2);
    [self.mapView setRegion:region];
    
}

#pragma mark CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = [locations lastObject];
    self.currentLocationLatitude = self.location.coordinate.latitude;
    self.currentLocationLongitude = self.location.coordinate.longitude;
    
    
    [self fetchVenuesForLocation:_location];
    [self zoomToLocation:_location radius:2000];
    [self.locationManager stopUpdatingLocation];
    NSDate* eventDate = _location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              _location.coordinate.latitude,
              _location.coordinate.longitude);
        
        
    }
}

// HELPER METHOD

-(NSDictionary *)calculateDistanceFromCurrentLoaction:(CGFloat )latitude andLongitude:(CGFloat )longitude
{
    
    NSMutableDictionary *tempDic = [NSMutableDictionary new];
    
    for (POI *poi in [DataSource sharedInstance].annotations)
    {
        CGFloat poiLatitude = poi.annotation.latitude;
        CGFloat poiLongitude = poi.annotation.longitude;
        NSLog(@"POI LATITUDE: %f", poiLatitude);
        NSLog(@"POI LONGITUDE: %f", poiLongitude);
        
        CLLocation *desiredLocation = [[CLLocation alloc] initWithLatitude:poiLatitude longitude:poiLongitude];
        NSLog(@"LOCATION LATITUDE: %f",latitude);
        NSLog(@"LOCATION LONGITUDE: %f",longitude);
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        CLLocationDistance distance = [currentLocation distanceFromLocation:desiredLocation];
        
        NSLog(@"DISTANCE %f", distance);
        
        NSNumber *distanceNumber = [NSNumber numberWithFloat:distance];
        [tempDic setObject:distanceNumber forKey:poi.locationName];
    }
    NSLog(@"TEMP DIC: %@", tempDic);
    return tempDic;
}


#pragma mark Attributed String
-(NSAttributedString *)titleLabelString  {
    
    NSString *baseString = @"Create a BlocSpot";
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont boldFlatFontOfSize:20]}];
    
    return mutAttString;
    
}

#pragma mark creat TabBar buttons
-(void) createTabBarButtons {
    
    UIImage *filterImage=[UIImage imageNamed:@"sorting_answers_filled"];
    
    
    self.filterButton = [[UIBarButtonItem alloc]initWithImage:filterImage
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(filterButtonPressed:)];
    
    [_filterButton setTintColor:[UIColor clearColor]];
    [_filterButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                               highlightedColor:[UIColor wetAsphaltColor]
                                   cornerRadius:3];
    
    
    [self.navigationItem setRightBarButtonItem:_filterButton];
}


// Setting auto Layout constraints


#pragma mark create constraints
-(void)createConstraints {
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_mapView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mapView]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapView]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.locationManager = nil;
    
}

-(void)dealloc {
    self.locationManager = nil;
    [self.locationManager stopMonitoringSignificantLocationChanges];
}


#pragma mark BLCCustomAnnotationsViewDelegate

-(void)customView:(AnnotationView *)view
didPressDoneButton:(FUIButton *)button
    withTitleText:(NSString *)titleText
withDescriptionText:(NSString *)descriptionText
{
    
    [self.parameters setObject:titleText forKey:@"locationName"];
    [self.parameters setObject:descriptionText forKey:@"notes"];
    [self.parameters setObject:self forKey:NSStringFromSelector(@selector(buttonState))];
    Annotation *annotation = [[Annotation alloc]initWithCoordinate:_coordinates];
    [self.parameters setObject:annotation forKey:@"annotation"];
    self.poi = [[POI alloc] initWithDictionary:self.parameters];
    [[DataSource sharedInstance] addPOI:self.poi];
    [[DataSource sharedInstance] addPOI:self.poi toCategoryArray:self.parameters[@"category"]];
    [self setState:ViewControllerStateMapContent animated:YES];
    
    [self.mapView addAnnotation:annotation];
    self.createAnnotationView.titleLabel.attributedText = [self titleLabelString];
    
    
    
}

-(void)customViewDidPressAddCategoriesView:(UIView *)categoryView
{
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:.75
          initialSpringVelocity:10
                        options:kNilOptions
                     animations:^{
                         
                         [self.navigationController presentViewController:self.navVC animated:NO completion:nil];
                         
                     } completion:^(BOOL finished) {
                         
                         
                         
                     }];
}

#pragma mark BLCCategoriesViewControllerDelegate

-(void)controllerDidDismiss:(CategoryViewController *)controller{
    
    [self.navVC dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)category:(Categories *)categories {
    _category = categories;
    
    [self.parameters setObject:categories forKey:@"category"];
    
    
    self.createAnnotationView.titleLabel.attributedText = [self.createAnnotationView titleLabelStringWithCategory:categories.categoryName withColor:categories.color];
    
    [self.categoryVC dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark BLCPopUpCategoriesTableViewControllerDelegate

-(void)getSelectedCategories:(NSArray *)categories andProceed:(BOOL)proceed
{
    if (proceed)
    {
        self.catArray = [NSMutableArray new];
        self.catArray = [NSMutableArray arrayWithArray:[self filterAnnotationsFromCategories:categories]];
    }
}

-(NSMutableArray *)filterAnnotationsFromCategories:(NSArray *)categories
{
    NSMutableArray *mutArray = [NSMutableArray new];
    
    for (Categories *category in categories)
    {
        
        [mutArray addObjectsFromArray:category.poi];
        
    }
    NSMutableArray *annotationArray =[NSMutableArray new];
    
    for (POI *poi in mutArray)
    {
        for (POI *dataPOI in [DataSource sharedInstance].annotations)
        {
            if ([poi.locationName isEqualToString:[NSString stringWithFormat:@"%@", dataPOI.locationName]] && [poi.note isEqualToString:[NSString stringWithFormat:@"%@", dataPOI.note]])
            {
                Annotation *annotation = [[Annotation alloc]initWithCoordinate:CLLocationCoordinate2DMake(poi.annotation.latitude, poi.annotation.longitude)];
                
                
                CallOutView *view = [[CallOutView alloc] initWithAnnotation:annotation reuseIdentifier:@"LikeAnnotation"];
                [view setTintColor:poi.category.color];
                
                [annotationArray addObject:view];
                
                
            }
        }
        
    }
    
    
    return annotationArray;
    
    
}
#pragma mark BLCPoiTableViewControllerDelegate


-(void)didSelectPOI:(POI *)poi
{
    NSMutableArray *mutArray = [NSMutableArray new];
    
    for (POI *dataPOI in [DataSource sharedInstance].annotations)
    {
        
        if ([poi.locationName isEqualToString:[NSString stringWithFormat:@"%@",dataPOI.locationName]] &&[poi.note isEqualToString:[NSString stringWithFormat:@"%@",dataPOI.note]])
        {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(dataPOI.annotation.latitude, dataPOI.annotation.longitude);
            Annotation *annotation = [[Annotation alloc]initWithCoordinate:coordinate];
            CallOutView *calloutView = [[CallOutView alloc]initWithAnnotation:annotation reuseIdentifier:viewID];
            [mutArray addObject:calloutView];
        }
        
        
    }
    
    [self.mapView showAnnotations:mutArray animated:YES];
    
}

#pragma mark tap gesture recognizer

-(void)tapFired:(UITapGestureRecognizer *)sender
{
    
    [self setState:ViewControllerStateMapContent animated:NO];
}


-(void) createAnnotation: (UILongPressGestureRecognizer *)sender
{
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self setState:ViewControllerStateAddPOI animated:YES];
        
        self.point = [sender locationInView:self.mapView];
        self.coordinates = [self.mapView convertPoint:self.point toCoordinateFromView:self.mapView];
        
        
        
    }
}

#pragma mark UITabBar button actions

-(void)popupBarButtonItemDonePressed:(id)sender
{
    if (self.catArray)
    {
        [self.mapView showAnnotations:self.catArray animated:YES];
        [self.popover dismissPopoverAnimated:YES];
        [self.catArray removeAllObjects];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
        
    }
}
-(void)cancelFilterCategoryPressed:(id)sender
{
    [self.popover dismissPopoverAnimated:YES];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    
    
}
-(void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController
{
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    
}
-(void)listViewPressed:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromLeft;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:self.poiTableVC animated:YES];
    
}
-(void)filterButtonPressed:(id)sender
{
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:.75
          initialSpringVelocity:10
                        options:kNilOptions
                     animations:^{
                         [self.navigationItem.leftBarButtonItem setEnabled:NO];
                         [self.popover presentPopoverFromBarButtonItem:self.filterButton
                                              permittedArrowDirections:WYPopoverArrowDirectionDown
                                                              animated:NO];
                         
                     } completion:^(BOOL finished) {
                         
                         
                         
                     }];
}






#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    [mapView.userLocation setTitle:@"I am here"];
    
    CallOutView *annotationView  = (CallOutView *)[mapView dequeueReusableAnnotationViewWithIdentifier:viewID];
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if([annotation isKindOfClass:[Annotation class]])
        
    {
        if (!annotationView){
            annotationView = [[CallOutView alloc]
                              initWithAnnotation:annotation reuseIdentifier:viewID];
        }else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        [annotationView setTintColor:_category.color];
        annotationView.canShowCallout = NO;
        
        [annotationView addSubview:[self returnImageColored]];
        
        
    }
    return annotationView;
}


-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views   {
    for (MKAnnotationView *view in views)
    {
        id <MKAnnotation> annotation = [view annotation];
        for (POI *poi in [DataSource sharedInstance].annotations)
        {
            if (poi.annotation == annotation){
                [view setTintColor:poi.category.color];
            }
        }
    }
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"ViewWidth %f", CGRectGetWidth(self.view.bounds));
    
    mapView.scrollEnabled =NO;
    
    for (POI *poi in [DataSource sharedInstance].annotations)
    {
        if (poi.annotation == view.annotation){
            CallOutInnerView *innerView = [[CallOutInnerView alloc]init];
            innerView.delegate = self;
            innerView.poi  = poi;

            //            innerView.visitIndicatorButton.vistButtonState = poi.buttonState;
            innerView.frame = CGRectMake(0, 0, 280, 188);
            self.calloutView = [[SMCalloutView alloc]init];
            self.calloutView.contentView =innerView; ;
            
            
            NSLog(@"poi.buttonState coming from the database %i", poi.buttonState);
            
            [self.calloutView presentCalloutFromRect:view.frame inView:mapView constrainedToView:mapView animated:YES];
        }
        
        
        
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    mapView.scrollEnabled = YES;
    [self.calloutView dismissCalloutAnimated:YES];
    
}



// helper function
-(UIImageView *)returnImageColored
{
    UIImageView *imageView = [UIImageView new];
    UIImage *image = [UIImage imageNamed:@"hearts_filled"];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.image = image;
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    return imageView;
    
}




#pragma mark BLCCallOutInnerViewDelegate

-(void)calloutView:(CallOutInnerView *)view didPressVisitedButton:(CategoryButton *)button
{
    if (view.visitIndicatorButton.visitButtonState == VisitButtonSelectedYES)
    {
        [[DataSource sharedInstance] toggleVisitedOnPOI:view.poi];
        
        view.visitIndicatorButton.visitButtonState = VisitButtonSelectedNO;
    } else
    {
        [[DataSource sharedInstance] toggleVisitedOnPOI:view.poi];
        view.visitIndicatorButton.visitButtonState = VisitButtonSelectedYES;
    }
    
}

-(void)callOutViewDidPressDeleteButton:(CallOutInnerView *)view
{
    [[DataSource sharedInstance] deletePOI:view.poi];
    [self.mapView removeAnnotation:view.poi.annotation];
    [self.calloutView dismissCalloutAnimated:YES];
    
}
-(void)callOutViewDidPressShareButton:(CallOutInnerView *)view
{
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[view.poi.locationName, view.poi.note, view.poi.annotation] applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}


-(void)callOutViewDidPressMapDirectionsButton:(CallOutInnerView *)view
{
    
    
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake(view.poi.annotation.latitude,view.poi.annotation.longitude);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:view.poi.locationName];
        
        // Set the directions mode to "Driving"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
    
}

@end