//
//  ViewController.m
//  BPGetBook
//
//  Created by Patel, Bhavesh on 1/27/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _bookData = [[NSString alloc] init];
    _textData = [[NSMutableData alloc] init];
}

- (IBAction)getChristmasCarole
{
    
    [_spinner startAnimating];
    _textData = [[NSMutableData alloc] init];

    
    NSURL *url = [NSURL URLWithString:@"http://georgepolak.com/book1.txt"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (IBAction)getTaleofTwo
{
    [_spinner startAnimating];
    _textData = [[NSMutableData alloc] init];

    
    NSURL *url = [NSURL URLWithString:@"http://georgepolak.com/book2.txt"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Got chunk");
    [_textData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSString *bookData;
    _bookData = [[NSString alloc] initWithData:_textData encoding:NSUTF8StringEncoding];
    
    _uiTextView.text = _bookData;
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR: %@", [error description]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
