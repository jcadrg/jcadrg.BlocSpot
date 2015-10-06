//
//  CallOutInnerView.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 10/1/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "CallOutInnerView.h"
#import "FlatUIKit.h"

@interface CallOutInnerView()

@property(nonatomic, strong) UIView *backButtonView;
@property(nonatomic, strong) UIButton *mapDirections;
@property(nonatomic, strong) UIButton *share;
@property(nonatomic, strong) UIButton *deleteButton;

@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIView *div1;

//@property(nonatomic, strong) UIButton *visitedIndicatorButton;



@end

@implementation CallOutInnerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        //        self.buttonState = poi.buttonState;
        //        self.frame = CGRectMake(0, 0, 300, 80);
        self.topView = [UIView new];
        //        self.topView.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor cloudsColor];
        [self addSubview:self.topView];
        
        
        self.div1 = [UIView new];
        self.div1.backgroundColor = [UIColor silverColor];
        //        self.lineDivide.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.div1];
        
        
        
        
        self.visitIndicatorButton =[[CategoryButton alloc]init];
        //        [self.visitIndicatorButton setImage:self.visitIndicatorImage.image forState:UIControlStateNormal];
        [self.visitIndicatorButton addTarget:self action:@selector(visitIndicatorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:self.visitIndicatorButton];
        //        self.visitIndicatorButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        // start with the labels - > the background UIView - > then the UIButtons
        self.titleLabel = [UILabel new];
        self.titleLabel.numberOfLines = 0;
        //        self.titleLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self.topView addSubview:self.titleLabel];
        
        self.descriptionLabel = [UILabel new];
        self.descriptionLabel.numberOfLines = 0;
        //        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.descriptionLabel];
        
        
        self.categoryLabel = [UILabel new];
        self.categoryLabel.numberOfLines = 0;
        self.categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.categoryLabel];
        
        
        
        self.backButtonView = [UIView new];
        //        self.backButtonsView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.backButtonView];
        
        // CREATE 3 buttons and add them as subview of backButtonsView
        // 1- MAP DIRECTIONS
        self.mapDirections =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.mapDirections setImage:[UIImage imageNamed:@"near_me"] forState:UIControlStateNormal];
        [self.mapDirections addTarget:self action:@selector(mapDirectionsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.backButtonView addSubview:self.mapDirections];
        //        self.mapDirections.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        
        // 2- SHARE
        self.share =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.share setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [self.share addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.backButtonView addSubview:self.share];
        //        self.share.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        
        // 3- DELETE BUTTON
        self.deleteButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.backButtonView addSubview:self.deleteButton];
        //        self.deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        //        [self createConstraints];
        [self layoutIfNeeded];
        
        
        
    }
    return self;
}
#pragma mark NSAttributedStrings
- (NSAttributedString *)categoryLabelAttributedString{
    NSString *aString = [NSString stringWithFormat:@"%@", self.poi.category.categoryName];
    
    NSString *baseString = NSLocalizedString([aString uppercaseString], @"Label of category");
    NSRange range = [baseString rangeOfString:baseString];
    
    NSMutableAttributedString *baseAttributedString = [[NSMutableAttributedString alloc] initWithString:baseString];
    UIColor *color = [UIColor new];
    color = self.poi.category.color;
    [baseAttributedString addAttribute:NSFontAttributeName value:[UIFont boldFlatFontOfSize:16] range:range];
    [baseAttributedString addAttribute:NSKernAttributeName value:@1.3 range:range];
    [baseAttributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    return baseAttributedString;
    
    
}

-(NSAttributedString *)calloutTtitleString {
    NSString *aString = [NSString stringWithFormat:@"%@", self.poi.locationName];
    UIColor *color = [UIColor new];
    color = self.poi.category.color;
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:aString attributes:@{NSForegroundColorAttributeName:color ,NSFontAttributeName:[UIFont boldFlatFontOfSize:20]}];
    
    return mutAttString;
    
}

-(NSAttributedString *)descriptionString  {
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.headIndent = 20.0;
    mutableParagraphStyle.firstLineHeadIndent = 20.0;
    mutableParagraphStyle.tailIndent = -20.0;
    mutableParagraphStyle.paragraphSpacingBefore = 5;
    NSString *aString = [NSString stringWithFormat:@"%@", self.poi.note];
    
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:aString
                                                                                     attributes:@{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont flatFontOfSize:16],NSParagraphStyleAttributeName : mutableParagraphStyle}];
    
    return mutAttString;
    
}


-(void)setPoi:(POI *)poi
{
    _poi = poi;
    _visitIndicatorButton.visitButtonState = _poi.buttonState;
    self.titleLabel.attributedText = [self calloutTtitleString];
    self.descriptionLabel.attributedText = [self descriptionString];
    self.categoryLabel.attributedText = [self categoryLabelAttributedString];
    [self.visitIndicatorButton setTintColor:poi.category.color];
    
}

//-(void)setVisitIndicatorImage:(UIImageView *)visitIndicatorImage withColor:(UIColor *)color
//{
//    _visitIndicatorImage = visitIndicatorImage;
//    self.visitIndicatorImage = [UIImageView new];
//    UIImage *image = [UIImage imageNamed:@"heart"];
//    _visitIndicatorImage.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//    _visitIndicatorImage.image = image;
//    _visitIndicatorImage.image = [_visitIndicatorImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [visitIndicatorImage setTintColor:color];
//
//}
-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 10;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:maxSize];
    CGSize descriptionLabelMaxSize = [self.descriptionLabel sizeThatFits:maxSize];
    CGSize categoryLabelMaxSize = [self.categoryLabel sizeThatFits:maxSize];
    
    CGFloat topHeight = 44;
    CGFloat halfTitlaLabelX = width/2 -  titleLabelSize.width/2;
    self.topView.frame = CGRectMake(0, 0, width, topHeight);
    
    
    self.titleLabel.frame = CGRectMake(padding, topHeight/2 - titleLabelSize.height/2, titleLabelSize.width, titleLabelSize.height);
    self.visitIndicatorButton.frame = CGRectMake(width - topHeight, CGRectGetMinY(self.titleLabel.frame) - 10 , 44, 44);
    
    
    self.div1.frame = CGRectMake(padding, CGRectGetMaxY(self.topView.frame), width - padding*2, 0.5);
    
    self.descriptionLabel.frame = CGRectMake(padding, CGRectGetMaxY(self.div1.frame)+ padding, width - padding*2, 88);
    
    self.categoryLabel.frame = CGRectMake(padding, CGRectGetMaxY(self.descriptionLabel.frame) + padding, categoryLabelMaxSize.width, categoryLabelMaxSize.height);
    
    
    CGFloat buttonSize = 30;
    
    self.backButtonView.frame = CGRectMake(CGRectGetMaxX(self.categoryLabel.frame) + 2*padding, CGRectGetMinY(self.categoryLabel.frame)- 5 , buttonSize *3 +padding +5, buttonSize );
    
    self.mapDirections.frame = CGRectMake(5, 0, buttonSize , buttonSize);
    self.share.frame = CGRectMake(CGRectGetMaxX(self.mapDirections.frame)+5, 0, buttonSize, buttonSize);
    self.deleteButton.frame = CGRectMake(CGRectGetMaxX(self.share.frame) +5, 0, buttonSize, buttonSize);
    
    
    
}

#pragma mark UIButton Actions

-(void)visitIndicatorButtonPressed:(UIButton *)sender
{
    [self.delegate calloutView:self didPressVisitedButton:self.visitIndicatorButton];
    
    
}
-(void)mapDirectionsButtonPressed:(UIButton *)sender
{
    
}

-(void)shareButtonPressed:(UIButton *)sender
{
    
}

-(void)deleteButtonPressed:(UIButton *)sender
{
    
}

@end



