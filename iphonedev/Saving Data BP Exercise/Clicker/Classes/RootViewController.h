//
//  RootViewController.h
//  Clicker
//
//  Created by George Polak on 8/16/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clicker.h"
#import "AddClickerViewController.h"


@interface RootViewController : UITableViewController<AddClickerViewControllerDelegate>
{
    NSMutableArray *_clickers;
}


@end
