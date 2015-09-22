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

@interface POITableViewCell()

@property (nonatomic, strong) NSLayoutConstraint *nextViewImageHeight;
@property (nonatomic, strong) NSLayoutConstraint *categoryButtonHeight;
@property (nonatomic, strong) NSLayoutConstraint *categoryButtonWidth;
@property (nonatomic, strong) NSLayoutConstraint *distanceWidth;

@property (nonatomic, strong) UILabel *locationName;
@property (nonatomic, strong) UILabel *locationNotes;
@property (nonatomic, strong) UILabel *distance;

@property (nonatomic, strong) UIButton *categoryButton;

@property (nonatomic, strong) UIImageView *nextViewImage;

@property (nonatomic, strong) POI *poi;

@end

static UIFont *lightFont;
static UIFont *regularFont;
static UIFont *boldFont;
static UIColor *backgroundColor;
static UIColor *fontColor;


@implementation POITableViewCell


+(void) load{
    lightFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
    regularFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    boldFont = [UIFont fontWithName:@"HelveticaNeue" size:11];
    
    backgroundColor = [UIColor cloudsColor];
    fontColor = [UIColor midnightBlueColor];
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor =backgroundColor;
        
        [self addLocationName];
        [self addLocationNotes];
        [self addDistance];
        [self addCategory];
        [self addNextView];
        [self createConstraints];
        
        
    }
    
    return self;
}

-(void) addLocationName{
    self.locationName = [[UILabel alloc] init];
    self.locationName.textAlignment = NSTextAlignmentLeft;
    self.locationName.numberOfLines =0;
    [self.contentView addSubview:self.locationName];
    self.locationName.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.locationName.attributedText = [self locationNameString];
    
}

-(void) addLocationNotes{
    self.locationNotes = [[UILabel alloc] init];
    self.locationNotes.textAlignment = NSTextAlignmentLeft;
    self.locationNotes.numberOfLines = 0;
    [self.contentView addSubview:self.locationNotes];
    self.locationNotes.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.locationNotes.attributedText = [self locationNotesString];
    
}

-(void) addDistance{
    
    self.distance = [[UILabel alloc] init];
    self.distance.textAlignment = NSTextAlignmentLeft;
    self.distance.numberOfLines = 0;
    [self.contentView addSubview:self.distance];
    self.distance.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.distance.attributedText = [self distanceString];
    
}

-(void) addCategory{
    self.categoryButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [self.categoryButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self.categoryButton addTarget:self action:@selector(categoryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.categoryButton];
    self.categoryButton.translatesAutoresizingMaskIntoConstraints = NO;
    
}

-(void) addNextView{
    
    self.nextViewImage = [[UIImageView alloc] init];
    self.nextViewImage.image = [UIImage imageNamed:@"right"];
    [self.contentView addSubview:self.nextViewImage];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
}

#pragma mark - Strings

-(NSAttributedString *) locationNameString{
    CGFloat locationNameFontSize = 15;
    NSString *string = @"Some good place";
    
    NSMutableAttributedString *locationAttributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName :[regularFont fontWithSize:locationNameFontSize]}];
    NSRange stringRange = [string rangeOfString:string];
    [locationAttributedString addAttribute:NSForegroundColorAttributeName value:fontColor range:stringRange];
    
    return locationAttributedString;
}

-(NSAttributedString *) locationNotesString{
    
    CGFloat locationNotesFontSize = 12;
    NSString *string = @"Some guy told me that is a fun place to be";
    
    NSMutableAttributedString *locationNoteAttributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName :[lightFont fontWithSize:locationNotesFontSize]}];
    NSRange stringRange = [string rangeOfString:string];
    [locationNoteAttributedString addAttribute:NSForegroundColorAttributeName value:fontColor range:stringRange];
    
    return locationNoteAttributedString;
}

-(NSAttributedString *) distanceString{
    CGFloat distanceFontSize = 10;
    NSString *string = @"1 km";
    
    NSMutableAttributedString *distanceAttributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: [lightFont fontWithSize:distanceFontSize]}];
    NSRange stringRange = [string rangeOfString:string];
    [distanceAttributedString addAttribute:NSForegroundColorAttributeName value:fontColor range:stringRange];
    
    return distanceAttributedString;
}

-(void) createConstraints{
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_locationName, _locationNotes, _distance, _categoryButton, _nextViewImage);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_categoryButton][_locationName][_nextViewImage]|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_categoryButton][_locationNotes][_nextViewImage(==25)]]"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_categoryButton][_distance]|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_locationName][_locationNotes]|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    //Next View constraints
    self.nextViewImageHeight = [NSLayoutConstraint constraintWithItem:_nextViewImage
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:100];
    
    NSLayoutConstraint *midConstraint =[NSLayoutConstraint constraintWithItem:_nextViewImage
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1
                                                                     constant:0];
    
    [self.contentView addConstraints:@[self.nextViewImageHeight, midConstraint]];
    
    
    //Category Button Constraints
    
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
    
    [self.contentView addConstraints:@[self.categoryButtonWidth, self.categoryButtonHeight]];
    
    //Distance Label Constraints
    
    self.distanceWidth = [NSLayoutConstraint constraintWithItem:_distance
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1
                                                       constant:100];
    
    [self.contentView addConstraints:@[self.distanceWidth]];
}


-(void) layoutSubviews{
    [super layoutSubviews];
    
    CGSize max = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
    CGSize distanceLabelSize = [self.distance sizeThatFits:max];
    
    self.nextViewImageHeight.constant = 25;
    self.categoryButtonHeight.constant = 30;
    self.categoryButtonWidth.constant = 30;
    
    self.distanceWidth.constant = distanceLabelSize.width;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
