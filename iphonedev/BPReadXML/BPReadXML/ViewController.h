//
//  ViewController.h
//  BPReadXML
//
//  Created by Patel, Bhavesh on 1/27/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "plants.h"

@interface ViewController : UITableViewController <NSXMLParserDelegate>
{
    NSMutableArray *_plants;
}

@end
