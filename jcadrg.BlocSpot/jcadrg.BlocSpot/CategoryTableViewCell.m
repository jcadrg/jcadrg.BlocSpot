//
//  CategoryTableViewCell.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/28/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "FlatUIKit.h"


@interface CategoryTableViewCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer* singleTapRecognizer;

@property (nonatomic, strong) NSLayoutConstraint *categoryLabelHeight;




@end
@implementation CategoryTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        // LABEL
        self.categoryLabel = [UILabel new];
        self.categoryLabel.numberOfLines = 0;
        self.categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
        //self.categoryLabel.attributedText = [self categoryLabelAttributedString];
        [self.contentView addSubview:self.categoryLabel];
        
        // CELL
        
        [self configureFlatCellWithColor:[UIColor cloudsColor]
                           selectedColor:[UIColor cloudsColor]
                         roundingCorners:UIRectCornerAllCorners];
        
        self.cornerRadius = 5.0f; // optional
        self.separatorHeight = 2.0f; // optional
        
        
        //TAG IMAGE
        /*self.tagImageView = [[UIImageView alloc]init];
        self.image = [UIImage imageNamed:@"like"];
        self.tagImageView.image = self.image ;*/
        
        self.tagImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.tagImageView];
        self.tagImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        /*self.tagImageView.image = [_tagImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.tagImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_tagImageView];*/
        
        /*self.tagImageViewFull = [[UIImageView alloc]init];
        self.image1 = [UIImage imageNamed:@"hearts_filled"];
        self.tagImageViewFull.image = self.image1 ;
        
        self.tagImageViewFull.image = [_tagImageViewFull.image imageWithRenderingMode:  UIImageRenderingModeAlwaysTemplate];
        
        self.tagImageViewFull.translatesAutoresizingMaskIntoConstraints = NO;*/
        
        
        //[self.contentView addSubview:_tagImageViewFull];
        //            [self.tagImageView1 setHidden:YES];
        
        self.state = CategoryTableViewCellStateUnSelectedNOT;
        
        
        [self createConstraints];
        
    }
    
    return self;
}

#pragma Attributed String

- (NSAttributedString *) categoryLabelAttributedStringWithColor:(UIColor *) color {
    NSString *categoryName = [NSString stringWithFormat:@"%@", self.category.categoryName];
    
    NSString *baseString = NSLocalizedString([categoryName uppercaseString], @"Label of category");
    NSRange range = [baseString rangeOfString:baseString];
    
    if (categoryName) {
        
        NSMutableAttributedString *baseAttributedString = [[NSMutableAttributedString alloc] initWithString:baseString];
        
        [baseAttributedString addAttribute:NSFontAttributeName value:[UIFont boldFlatFontOfSize:16] range:range];
        [baseAttributedString addAttribute:NSKernAttributeName value:@1.3 range:range];
        
        [baseAttributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
        
        return baseAttributedString;
        
    }else return nil;
    
    
}

-(void) setCategory:(Categories *)category{
    _category = category;
    self.categoryLabel.attributedText = [self categoryLabelAttributedStringWithColor:category.color];
    [self.tagImageView setTintColor:category.color];
}



-(void)createConstraints

{
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(  _categoryLabel,_tagImageView);
    
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tagImageView(==44)]|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    ;
    
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tagImageView(==44)]|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    /*[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tagImageViewFull(==44)]|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    ;
    
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tagImageViewFull(==44)]|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    
    */
    
    
    
    [self.contentView addConstraints:({
        @[ [NSLayoutConstraint
            constraintWithItem:_categoryLabel
            attribute:NSLayoutAttributeCenterX
            relatedBy:NSLayoutRelationEqual
            toItem:self.contentView
            attribute:NSLayoutAttributeCenterX
            multiplier:1.f constant:0.f],
           
           [NSLayoutConstraint
            constraintWithItem:_categoryLabel
            attribute:NSLayoutAttributeCenterY
            relatedBy:NSLayoutRelationEqual
            toItem:self.contentView
            attribute:NSLayoutAttributeCenterY
            multiplier:1.f constant:0] ];
    })];
}

//-(void)setSelected:(BOOL)selected {
//    [super setSelected:selected];
//
//    if (selected){
//        [self.delegate didSelectCell:self];
//
//    }
//
//}

-(UIImageView *) returnImageColoredWithName:(NSString *)name{
    
    UIImageView *imageView = [UIImageView new];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *image = [UIImage imageNamed:name];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width -10, self.frame.size.height -10);
    imageView.image = image;
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    return imageView;
}

-(void)setState:(CategoryTableViewCellState)state {
    _state = state;
    
    NSString *imageName;
    
    switch (self.state) {
            
        case CategoryTableViewCellStateUnSelectedNOT:
            
            imageName = @"like";
            
        break;
        case CategoryTableViewCellStateSelectedYES:
            imageName = @"hearts_filled";
            
            
        
    }
    
    [self.tagImageView setImage:[self returnImageColoredWithName:imageName].image];
    
}




@end