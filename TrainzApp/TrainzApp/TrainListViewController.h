//
//  FirstViewController.h
//  TrainzApp
//
//  Created by Ian Meyer on 1/14/17.
//  Copyright © 2017 Ian Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainListViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;

- (IBAction)exitToTrainList:(UIStoryboardSegue *)unwindSegue;

@end

