//
//  ComposeLocationViewController.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/23/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "ComposeLocationViewController.h"
#import "AnnotationView.h"


@interface ComposeLocationViewController ()

@property (nonatomic, strong) AnnotationView *createAnnotation;
@property (nonatomic, strong) UINavigationController *navController;

@end

@implementation ComposeLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.createAnnotation = [[AnnotationView alloc] init];
    _createAnnotation.translatesAutoresizingMaskIntoConstraints = NO;
    
    //self.view.userInteractionEnabled = YES;
    
    [self.view addSubview:_createAnnotation];
    [self createConstraints];
}

-(void) createConstraints{
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_createAnnotation);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_createAnnotation]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_createAnnotation]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewDictionary]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
