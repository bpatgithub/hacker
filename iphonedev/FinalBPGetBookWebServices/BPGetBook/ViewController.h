//
//  ViewController.h
//  BPGetBook
//
//  Created by Patel, Bhavesh on 1/27/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSURLConnectionDataDelegate>
{
    IBOutlet UITextView *_uiTextView;
    IBOutlet UIActivityIndicatorView *_spinner;
    
    NSMutableData *_textData;
    NSString *_bookData;
}

- (IBAction)getChristmasCarole;
- (IBAction)getTaleofTwo;

@end
