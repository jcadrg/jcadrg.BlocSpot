//
//  POITableViewCell.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/20/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "POITableViewCell.h"
#import "UIFont+FlatUI.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import "FlatUIKit.h"


@interface POITableViewCell()

@property (nonatomic, strong) NSLayoutConstraint *nextViewImageHeight;
@property (nonatomic, strong) NSLayoutConstraint *categoryButtonHeight;
@property (nonatomic, strong) NSLayoutConstraint *categoryButtonWidth;
@property (nonatomic, strong) NSLayoutConstraint *distanceWidth;


@property (nonatomic, strong) UIImageView *nextViewImage;

@property (nonatomic, strong) UILabel *locationName;
@property (nonatomic, strong) UILabel *locationNotes;

@end

static UIFont *lightFont;
static UIFont *regularFont;
static UIFont *boldFont;
static UIColor *backgroundColor;
static UIColor *fontColor;


@implementation POITableViewCell


+ (void) load {
    
    lightFont =[UIFont lightFlatFontOfSize:11];
    
    regularFont =[UIFont flatFontOfSize:11];
    boldFont = [UIFont boldFlatFontOfSize:11];
    //lightFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
    //normalFont = [UIFont fontWithName:@"HelveticaNeue" size:11];
    //boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    
    backgroundColor = [UIColor cloudsColor];
    //backgroundColor = [UIColor wetAsphaltColor];
    fontColor  = [UIColor midnightBlueColor];
    //standardLetterCollors = [UIColor buttsColor];
}

#pragma mark Initialization

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {
        self.contentView.backgroundColor = backgroundColor;
        [self addlocationNameLabel];
        [self addLocationNotes];
        [self addDistanceLabel];
        [self addCategoryButton];
        [self addNextViewImage];
        [self createConstraints];
        
        
    }
    
    return self;
    
}


-(void)addlocationNameLabel {
    self.locationName = [UILabel new];
    self.locationName.textAlignment = NSTextAlignmentLeft;
    self.locationName.numberOfLines  =0;
    [self.contentView addSubview: self.locationName];
    //    self.nameOfPlace.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.locationName.translatesAutoresizingMaskIntoConstraints = NO;
    //    self.nameOfPlace.clipsToBounds = NO;
    
    
}

-(void)addLocationNotes{
    self.locationNotes = [UILabel new];
    self.locationNotes.textAlignment = NSTextAlignmentLeft;
    self.locationNotes.numberOfLines  =0;
    //    self.notesAboutPlace.clipsToBounds = NO;
    //    self.notesAboutPlace.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview: self.locationNotes];
    self.locationNotes.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
}
-(void)addDistanceLabel {
    self.distance = [UILabel new];
    self.distance.textAlignment = NSTextAlignmentLeft;
    self.distance.numberOfLines  =0;
    [self.contentView addSubview: self.distance];
    self.distance.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}

// Category button going to be a Model button itself
-(void)addCategoryButton {
    self.categoryButton =  [[CategoryButton alloc]init];
    [self.categoryButton addTarget:self action:@selector(categoryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.categoryButton];
    self.categoryButton.translatesAutoresizingMaskIntoConstraints = NO;
    
}

-(void)addNextViewImage{
    self.nextViewImage = [[UIImageView alloc]init];
    
    self.nextViewImage.image = [UIImage imageNamed:@"right"];
    [self.contentView addSubview:self.nextViewImage];
    self.nextViewImage.translatesAutoresizingMaskIntoConstraints = NO;
    
}


-(void)createConstraints {
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_locationName, _locationNotes, _distance, _categoryButton, _nextViewImage);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_categoryButton]-[_locationName]-[_nextViewImage]-|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_categoryButton]-[_locationNotes][_nextViewImage(==28)]-|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_categoryButton][_distance]-|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_distance]"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_locationName]-[_locationNotes]-|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    //Arrow Image Constraints
    self.nextViewImageHeight = [NSLayoutConstraint constraintWithItem:_nextViewImage
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:100];
    
    NSLayoutConstraint *centerConstraint = [NSLayoutConstraint constraintWithItem:_nextViewImage
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1
                                                                         constant:0];
    
    [self.contentView addConstraints:@[self.nextViewImageHeight,centerConstraint]];
    
    //Category Button
    
    self.categoryButtonHeight = [NSLayoutConstraint constraintWithItem:_categoryButton
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:100];
    self.categoryButtonWidth = [NSLayoutConstraint constraintWithItem:_categoryButton
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:100];
    [self.contentView addConstraints:@[self.categoryButtonHeight, self.categoryButtonWidth]];
    
    // How far is it label Width
    self.distanceWidth =[NSLayoutConstraint constraintWithItem:_distance
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1
                                                        constant:100];
    [self.contentView addConstraint:self.distanceWidth];
    
}

#pragma mark Attributed Strings

-(NSAttributedString *)placeNameString{
    
    CGFloat locationNameFontSize = 18;
    NSString *baseString = [NSString stringWithFormat:@"%@", _poi.locationName];
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.headIndent = 20.0;
    mutableParagraphStyle.firstLineHeadIndent = 10.0;
    mutableParagraphStyle.tailIndent = -20.0;
    mutableParagraphStyle.paragraphSpacingBefore = 5;
    //    if (baseString)
    //    {
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName :[UIFont boldFlatFontOfSize:18],NSParagraphStyleAttributeName : mutableParagraphStyle}];
    
    NSRange stringRange = [baseString rangeOfString:baseString];
    [mutAttString addAttribute:NSForegroundColorAttributeName value:[UIColor midnightBlueColor] range:stringRange];
    return mutAttString;
    //    } else
    //    {
    //        return nil;
    //    }
    
}


-(NSAttributedString *)notesAboutPlaceString{
    
    
    NSString *baseString = [NSString stringWithFormat:@"%@", _poi.note];
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.headIndent = 20.0;
    mutableParagraphStyle.firstLineHeadIndent = 20.0;
    mutableParagraphStyle.tailIndent = -20.0;
    mutableParagraphStyle.paragraphSpacingBefore = 5;
    if (baseString){
        NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName :[UIFont flatFontOfSize:14],NSParagraphStyleAttributeName : mutableParagraphStyle }];
        NSRange stringRange = [baseString rangeOfString:baseString];
        [mutAttString addAttribute:NSForegroundColorAttributeName value:[UIColor midnightBlueColor] range:stringRange];
        
        return mutAttString;
    }else return nil;
    
}


-(NSAttributedString *)howFarIsItString {
    
    NSString *baseString = @"< 1 min.";
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName :[UIFont flatFontOfSize:11] }];
    NSRange stringRange = [baseString rangeOfString:baseString];
    [mutAttString addAttribute:NSForegroundColorAttributeName value:[UIColor midnightBlueColor] range:stringRange];
    
    return mutAttString;
    
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
    CGSize distanceLabelSize = [self.distance sizeThatFits:maxSize];
    
    self.nextViewImageHeight.constant = 20;
    self.categoryButtonHeight.constant = 44;
    self.categoryButtonWidth.constant = 44;
    
    self.distanceWidth.constant = distanceLabelSize.width ;
}

#pragma mark Over-Rides

-(void)setPoi:(POI *)poi
{
    _poi = poi;
    self.categoryButton.visitButtonState = poi.buttonState;
    self.locationName.attributedText = [self placeNameString];
    self.locationNotes.attributedText = [self notesAboutPlaceString];
    //    self.howFarIsIt.attributedText = [self howFarIsItString];
    [self.categoryButton setTintColor:poi.category.color];
    
}
#pragma mark UIButton Actions
-(void)categoryButtonPressed:(UIButton *)sender
{
    [self.delegate cellDidPressOnButton:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
