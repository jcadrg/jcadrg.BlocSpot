//
//  SearchResultsTableVCViewController.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 10/7/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "SearchResultsTableVCViewController.h"
#import "POI.h"
#import "POITableViewCell.h"


@implementation SearchResultsTableVCViewController

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    POITableViewCell *cell = (POITableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:@"Points"];
    
    POI *poi = self.searchResults[indexPath.row];
    cell.poi = poi;
    
    return cell;
}

@end
