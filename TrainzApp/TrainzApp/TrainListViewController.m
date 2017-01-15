//
//  FirstViewController.m
//  TrainzApp
//
//  Created by Ian Meyer on 1/14/17.
//  Copyright © 2017 Ian Meyer. All rights reserved.
//

#import "TrainListViewController.h"
#import <TrainzKit/TrainzKit.h>

@interface TrainListViewController ()

@property (nonatomic, strong) NSArray *subwayLines;

@end

@implementation TrainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *tmpStatus = [[TransitHandler defaultHandler] subwayLineStatus];
    if ( tmpStatus.count > 0 ) {
        // wat
        [self setSubwayLines:tmpStatus];
        [self.tableView reloadData];
    } else {
        // fetch
        [[TransitHandler defaultHandler] updateDataWithCompletion:^(NSArray<SubwayLine *> *subwayLineStatus, NSError *error) {
            // wat
            [self setSubwayLines:subwayLineStatus];
            [self.tableView reloadData];
        }];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subwayLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *rtnCell = [tableView dequeueReusableCellWithIdentifier:@"trainCell" forIndexPath:indexPath];
    
    // configure
    SubwayLine *tmpLine = [self.subwayLines objectAtIndex:indexPath.row];
    [rtnCell.textLabel setText:tmpLine.name];
    [rtnCell.detailTextLabel setText:tmpLine.status];
    
    return rtnCell;
}

@end
