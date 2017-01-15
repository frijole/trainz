//
//  FirstViewController.m
//  TrainzApp
//
//  Created by Ian Meyer on 1/14/17.
//  Copyright © 2017 Ian Meyer. All rights reserved.
//

#import "TrainListViewController.h"
#import "TrainDetailViewController.h"
#import <TrainzKit/TrainzKit.h>

@interface TrainListViewController ()

@property (nonatomic, strong) NSArray *subwayLines;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation TrainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *tmpStatus = [[TransitHandler defaultHandler] subwayLineStatus];
    if ( tmpStatus.count > 0 ) {
        // wat
        [self setSubwayLines:tmpStatus];
        [self.statusLabel setText:[NSString stringWithFormat:@"Last Updated:\n%@", [self.dateFormatter stringFromDate:[[TransitHandler defaultHandler] lastUpdated]]]];
        [self.tableView reloadData];
    } else {
        // fetch
        [[TransitHandler defaultHandler] updateDataWithCompletion:^(NSArray<SubwayLine *> *subwayLineStatus, NSError *error) {
            // wat
            [self setSubwayLines:subwayLineStatus];
            [self.statusLabel setText:[NSString stringWithFormat:@"Last Updated:\n%@", [self.dateFormatter stringFromDate:[[TransitHandler defaultHandler] lastUpdated]]]];
            [self.tableView reloadData];
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( self.tableView.indexPathForSelectedRow ) {
        NSIndexPath *tmpIndexPath = self.tableView.indexPathForSelectedRow;
        SubwayLine *tmpSubwayLine = [self.subwayLines objectAtIndex:tmpIndexPath.row];
        if ( [segue.destinationViewController respondsToSelector:@selector(setSubwayLine:)] ) {
            [(TrainDetailViewController *)segue.destinationViewController setSubwayLine:tmpSubwayLine];
        }
    }
}

- (IBAction)exitToTrainList:(UIStoryboardSegue *)unwindSegue {
    //wat
}

- (NSDateFormatter *)dateFormatter {
    if ( !_dateFormatter ) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_dateFormatter setDoesRelativeDateFormatting:YES];
    }
    return _dateFormatter;
}

#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subwayLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *rtnCell = [tableView dequeueReusableCellWithIdentifier:@"trainCell" forIndexPath:indexPath];
    
    // configure
    SubwayLine *tmpLine = [self.subwayLines objectAtIndex:indexPath.row];
    [rtnCell.textLabel setText:[TransitHandler formattedNameFromString:tmpLine.name]];
    [rtnCell.detailTextLabel setText:tmpLine.status];
    
    if ( [tmpLine.status caseInsensitiveCompare:@"good service"] == NSOrderedSame ) {
        [rtnCell.imageView setImage:[UIImage imageNamed:@"train-ok"]];
        [rtnCell.imageView setTintColor:[UIColor blackColor]]; // for "normal" appearance
    } else if ( [tmpLine.status caseInsensitiveCompare:@"planned work"] == NSOrderedSame ) {
        [rtnCell.imageView setImage:[UIImage imageNamed:@"train-alert"]];
        [rtnCell.imageView setTintColor:[UIColor orangeColor]];
    } else {
        [rtnCell.imageView setImage:[UIImage imageNamed:@"train-alert"]];
        [rtnCell.imageView setTintColor:[UIColor redColor]];
    }
    
    return rtnCell;
}

@end
