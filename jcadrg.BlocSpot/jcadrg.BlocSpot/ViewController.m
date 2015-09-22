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

#import "POITableViewController.h"
#import "SearchViewController.h"



@interface ViewController () <MKMapViewDelegate, UIViewControllerTransitioningDelegate, UISearchBarDelegate, UISearchControllerDelegate, UITabBarControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@property(nonatomic, strong) POITableViewController *poiTableVC;
@property(nonatomic, strong) SearchViewController *searchVC;
@property(nonatomic, strong) NSMutableArray *matchingItems;

@property(nonatomic, strong) UISearchController *searchController;
@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic, strong) CLLocation *currentLocation;
@property(nonatomic, strong) UIBarButtonItem *searchButton;
@property(nonatomic, strong) UIBarButtonItem *filterButton;
@property(nonatomic, strong) UIBarButtonItem *listButton;
@property(nonatomic, strong) UIBarButtonItem *labelButton;

@property(nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic, strong) UILongPressGestureRecognizer *longTapRecognizer;



@end

@implementation ViewController


-(instancetype) init{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.poiTableVC = [[POITableViewController alloc] init];
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.userInteractionEnabled=YES;
    [self.mapView setDelegate:self];
    [self.view addSubview:self.mapView];
    self.mapView.showsUserLocation=YES;
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    self.tapRecognizer.delegate = self;
    self.tapRecognizer.numberOfTapsRequired = 1;
    
    self.longTapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapFired:)];
    self.longTapRecognizer.delegate=self;
    [self.view addGestureRecognizer:self.longTapRecognizer];
    [self.view addGestureRecognizer:self.tapRecognizer];
    
    [self setUpSearchBar];
    [self addButtons];
    [self addListViewButton];
    [self createConstraints];
    self.searchVC = [[SearchViewController alloc] init];

    
    /*UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"location"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonFired:)];
    UIBarButtonItem *listBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"align_justify_filled"] style:UIBarButtonItemStylePlain target:self action:@selector(listButtonFired:)];
    
    self.navigationItem.rightBarButtonItem =searchBarButton;
    self.navigationItem.leftBarButtonItem = listBarButton;
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];*/

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.015, 0.015);
    [mapView setRegion:mapRegion animated: YES];
}

-(void) setUpSearchBar{
    self.searchBar = [[UISearchBar alloc] init];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
}

-(void) addListViewButton{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [self titleString];
    
    CGSize max = CGSizeMake(CGRectGetWidth(self.view.bounds),CGFLOAT_MAX);
    CGSize labelMax = [label sizeThatFits:max];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, labelMax.width, labelMax.height)];
    
    label.frame = CGRectMake(0, 0, labelMax.width, labelMax.height);
    
    [customView addSubview:label];
    _labelButton = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
    UIImage *listImage = [UIImage imageNamed:@"list_filled"];
    self.listButton = [[UIBarButtonItem alloc]initWithImage:listImage
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(listPressed:)];
    [_listButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItems = @[_listButton, _labelButton];
    
    [_listButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                                    highlightedColor:[UIColor wetAsphaltColor]
                                        cornerRadius:3];
    
}

-(NSAttributedString *)titleString  {
    
    NSString *baseString = @"BlocSpot";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont boldFlatFontOfSize:20]}];
    
    return attributedString;
    
}

-(void) addButtons {
    UIImage *searchImage =[UIImage imageNamed:@"quest"];
    
    self.searchButton   = [[UIBarButtonItem alloc]initWithImage:searchImage
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(searchButtonPressed:)];
    
    UIImage *filterImage=[UIImage imageNamed:@"sorting_answers_filled"];
    
    
    self.filterButton = [[UIBarButtonItem alloc]initWithImage:filterImage
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(filterButtonPressed:)];
    
    [_filterButton setTintColor:[UIColor whiteColor]];
    [_searchButton setTintColor:[UIColor whiteColor]];
    [_filterButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                               highlightedColor:[UIColor wetAsphaltColor]
                                   cornerRadius:3];
    [_searchButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                               highlightedColor:[UIColor wetAsphaltColor]
                                   cornerRadius:3];
    
    [self.navigationItem setRightBarButtonItems:@[_filterButton, _searchButton]];
}

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
}


-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    
    
    
}

#pragma mark tap gesture recognizer

-(void)tapFired:(UITapGestureRecognizer *)sender {
    [_searchBar resignFirstResponder];
    _searchBar.alpha = 0.0;
    self.navigationItem.titleView = nil;
    self.navigationItem.leftBarButtonItems = @[_listButton, _labelButton];
    self.navigationItem.rightBarButtonItems =@[_filterButton, _searchButton];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.isEditing == NO;
}

-(void) longTapFired: (UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        
    }
    
}

#pragma mark UITabBar button actions
-(void)searchButtonPressed:(id)sender{
    
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:.75
          initialSpringVelocity:10
                        options:kNilOptions
                     animations:^{
                         _searchBar.alpha = 1.0;
                         // remove other buttons
                         
                         self.navigationItem.rightBarButtonItems = nil;
                         self.navigationItem.leftBarButtonItems = nil;
                         self.navigationItem.titleView = _searchBar;
                         [_searchBar becomeFirstResponder];
                         
                         
                         
                     } completion:^(BOOL finished) {
                         
                         // add the search bar (which will start out hidden).
                         
                         
                     }];
}




-(void)listPressed:(id)sender{
    /*
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromLeft;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    */
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:self.poiTableVC animated:YES];
    
}
-(void)filterButtonPressed:(id)sender {
    
}


#pragma mark UISearchBarDelegate methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.9
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0
                        options:kNilOptions
                     animations:^{
                         
                         
                     } completion:^(BOOL finished) {
                         _searchBar.alpha = 0.0;
                         
                         self.navigationItem.titleView = nil;
                         self.navigationItem.leftBarButtonItems = @[_listButton, _labelButton];
                         self.navigationItem.rightBarButtonItems =@[_filterButton, _searchButton];
                         
                     }];
    
    
}


@end