//
//  DataSource.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/20/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "DataSource.h"

@interface DataSource () {
    NSMutableArray *_annotations;
    NSMutableArray *_categories;
    NSMutableDictionary *_distanceValuesDictionary;
    
}
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSDictionary *distanceValuesDictionary;




@end

@implementation DataSource


+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        
        
    }
    return self;
}


- (void)removeImage:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [removeSuccessFulAlert show];
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

-(void)addDictionary:(NSDictionary *)dic
{
    _distanceValuesDictionary =[NSMutableDictionary dictionaryWithDictionary:dic];
    
    
}
-(void) deleteCategories:(Categories *)category
{
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"categories"];
    [mutableArrayWithKVO removeObject:category];
    [self savingCategories];
    
}
-(void)addCategories:(Categories *)category
{
    if ([category isKindOfClass:[Categories class]]) {
        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"categories"];
        [mutableArrayWithKVO insertObject:category atIndex:0];
        
        
        /*
        
        // Convert this NSIndexSet to an NSArray of NSIndexPaths (which is what the table view animation methods require)
        NSMutableArray *indexPathsThatChanged = @[[NSIndexPath indexPathForItem:0 inSection:0]];
        
        // Call `beginUpdates` to tell the table view we're about to make changes
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
*/
        
        [self savingCategories];

    }
}

-(void) deletePOI:(POI *)poi
{
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"annotations"];
    //    [poi.category.pointsOfInterest removeObject:poi];
    [mutableArrayWithKVO removeObject:poi];
    [self savingAnnotations];
    //    [self savingCategories];
    
}
-(void)addPOI:(POI *)poi
{
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"annotations"];
    [mutableArrayWithKVO insertObject:poi atIndex:0];
    [self savingAnnotations];
}

-(void)addPOI:(POI *)poi toCategoryArray:(Categories *)category
{
    
    [category.poi addObject:poi];
    [self savingCategories];
    [self reloadCategories:category];
    
    
}
-(void)reloadCategories:(Categories *)category
{
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"categories"];
    NSUInteger index = [mutableArrayWithKVO indexOfObject:category];
    [mutableArrayWithKVO replaceObjectAtIndex:index withObject:category];
    
}

-(void)toggleVisitedOnPOI:(POI *)poi
{
    
    if (poi.buttonState == VisitButtonSelectedNO)
    {
        
        [poi setButtonState:VisitButtonSelectedYES];
        [self reloadAnnotation:poi];
        
        [self savingAnnotations];
        
        
    }else {
        
        [poi setButtonState:VisitButtonSelectedNO];
        [self reloadAnnotation:poi];
        
        [self savingAnnotations];
        
    }
    
    
    
}

-(void)reloadAnnotation:(POI *)poi
{
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"annotations"];
    NSUInteger index = [mutableArrayWithKVO indexOfObject:poi];
    [mutableArrayWithKVO replaceObjectAtIndex:index withObject:poi];
    
}

- (NSString *) pathForFilename:(NSString *) filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:filename];
    return dataPath;
}



-(void)savingAnnotations
{
    // Write the changes to disk
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ;
        _annotationsPath = [self pathForFilename:NSStringFromSelector(@selector(annotations))];
        NSData *annotationData = [NSKeyedArchiver archivedDataWithRootObject:self.annotations];
        
        NSError *dataError;
        BOOL wroteSuccessfully = [annotationData writeToFile:_annotationsPath options:NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUnlessOpen error:&dataError];
        
        if (!wroteSuccessfully) {
            NSLog(@"Couldn't write file: %@", dataError);
        }
        
    });
    
}

- (void)loadAnnotations {
    _annotationsPath = [self pathForFilename:NSStringFromSelector(@selector(annotations))];
    _annotations  = [NSKeyedUnarchiver unarchiveObjectWithFile:_annotationsPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *mutableAnnotations = [_annotations mutableCopy];
        
        [self willChangeValueForKey:@"annotations"];
        self.annotations = mutableAnnotations;
        [self didChangeValueForKey:@"annotations"];
        
        
    });
    if (!_annotations) {
        _annotations = [NSMutableArray array];
    }
}


- (NSArray *)annotations {
    if (!_annotations) {
        [self loadAnnotations];
    }
    return _annotations;
}

-(void)loadCategories  {
    _categoriesPath = [self pathForFilename:NSStringFromSelector(@selector(categories))];
    
    _categories  = [NSKeyedUnarchiver unarchiveObjectWithFile:_categoriesPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *mutableCategories = [_categories mutableCopy];
        
        [self willChangeValueForKey:@"categories"];
        self.categories = mutableCategories;
        [self didChangeValueForKey:@"categories"];
        
    });
    if (!_categories){
        _categories = [NSMutableArray array];
        
    }
}

-(NSArray *)categories
{
    if (!_categories) {
        [self loadCategories];
    }
    return _categories;
}

-(void)savingCategories
{
    // Write the changes to disk
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ;
        
        NSString *fullPath = [self pathForFilename:NSStringFromSelector(@selector(categories))];
        NSData *categoriesData = [NSKeyedArchiver archivedDataWithRootObject:self.categories];
        
        NSError *dataError;
        BOOL wroteSuccessfully = [categoriesData writeToFile:fullPath options:NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUnlessOpen error:&dataError];
        
        if (!wroteSuccessfully) {
            NSLog(@"Couldn't write file: %@", dataError);
        }
    });
    
}



#pragma mark - Key/Value Observing

- (NSUInteger) countOfAnnotations {
    return self.annotations.count;
}

- (id) objectInAnnotationsAtIndex:(NSUInteger)index {
    return [self.annotations objectAtIndex:index];
}

- (NSArray *) annotationsAtIndexes:(NSIndexSet *)indexes {
    return [self.annotations objectsAtIndexes:indexes];
}
- (void) insertObject:(POI *)object inAnnotationsAtIndex:(NSUInteger)index {
    [_annotations insertObject:object atIndex:index];
}

- (void) removeObjectFromAnnotationsAtIndex:(NSUInteger)index {
    [_annotations removeObjectAtIndex:index];
}

- (void) replaceObjectInAnnotationsAtIndex:(NSUInteger)index withObject:(id)object {
    [_annotations replaceObjectAtIndex:index withObject:object];
}

// Categories
- (NSUInteger) countOfCategories{
    return self.categories.count;
}

- (id) objectInCategoriesAtIndex:(NSUInteger)index {
    return [self.categories objectAtIndex:index];
}

- (NSArray *) categoriesAtIndexes:(NSIndexSet *)indexes {
    return [self.annotations objectsAtIndexes:indexes];
}
- (void) insertObject:(Categories *)object inCategoriesAtIndex:(NSUInteger)index {
    [_categories insertObject:object atIndex:index];
}

- (void) removeObjectFromCategoriesAtIndex:(NSUInteger)index {
    [_categories removeObjectAtIndex:index];
}

- (void) replaceObjectInCategoriesAtIndex:(NSUInteger)index withObject:(id)object {
    [_categories replaceObjectAtIndex:index withObject:object];
}

@end
