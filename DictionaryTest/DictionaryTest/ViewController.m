//
//  ViewController.m
//  DictionaryTest
//
//  Created by chetu on 12/24/15.
//  Copyright © 2015 com.chetudeveloper.Test. All rights reserved.
//

#import "ViewController.h"
#include <stdio.h>
#include <string.h>

@interface ViewController (){
    NSArray *allWords;
    
    BOOL isGridValid;
    
}

@property (weak, nonatomic) IBOutlet UITextField *textfieldEnter;

- (IBAction)checkForWordExistance:(id)sender;
- (IBAction)testGrid:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isGridValid = NO;
    
    
    NSString *pathName = [[NSBundle mainBundle] pathForResource:@"WordBank" ofType:@"csv"];  /// fill in the file's pathname
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:pathName]) {
        // read the file contents, see below
        NSError *error;
        NSString *lines = [NSString stringWithContentsOfFile:pathName  encoding:NSUTF8StringEncoding error: &error];
        
        allWords = [lines componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkForWordExistance:(id)sender {
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like[cd] %@", _textfieldEnter.text];
    NSArray *results = [allWords filteredArrayUsingPredicate:predicate];
    
    NSLog(@"result => %@", results);
    NSString *message = (results.count == 0)?@"No match found" : [NSString stringWithFormat:@"%lu matches found", (unsigned long)results.count ];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([UIAlertController class])
        {
            // use UIAlertController
            UIAlertController *alert= [UIAlertController
                                       alertControllerWithTitle:@"Result"
                                       message:message
                                       preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                           //Do Some action here
                                                           _textfieldEnter.text = @"";
                                                           
                                                       }];
            
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else
        {
            
            
        }
        
    });
    
}

- (IBAction)testGrid:(id)sender {
    
//    NSString *gridText = @"tacfredft";
    
    if (_textfieldEnter.text.length == 0) {
        return;
    }

    NSString *gridText = _textfieldEnter.text;
    NSString * subString;
    NSUInteger toTestLength = gridText.length ;
    
    
    for (int j = 0 ; j < gridText.length; j++) {
        
        
        for (int i = 0; i <= toTestLength; i++ ) {
            
            
            subString = [gridText substringWithRange:NSMakeRange(j, i)];
            const char* utf8String = [subString UTF8String];
            size_t len = strlen(utf8String) + 1;
            char mac [len];
            memcpy(mac, utf8String, len);
            NSInteger n = strlen(mac);
            
            if (!isGridValid) {
                [self getAllPossibleStrings:mac length:0 range:n-1];
            }
            
        }
        toTestLength --;
    }
}




-(void)getAllPossibleStrings:(char *)a length:(int)l range:(NSInteger)r {
    
    int i;
    if (l == r){
        printf("%s\n", a);
        NSString *wordToCheck = [NSString stringWithFormat:@"%s", a];
        if (wordToCheck.length > 1) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like[cd] %@", [NSString stringWithFormat:@"%@", wordToCheck]];
            NSArray *results = [allWords filteredArrayUsingPredicate:predicate];
            
            if (results.count > 0) {
                NSLog(@"Grid Is Valid !!!!!!");
                isGridValid = YES;
                return;
            }
        }
    }
    
    else
    {
        for (i = l; i <= r; i++)
        {
            swap((a+l), (a+i));
            
            [self getAllPossibleStrings:a length:l+1 range:r];
            swap((a+l), (a+i)); //backtrack
        }
    }
    
}

void swap(char *x, char *y)
{
    char temp;
    temp = *x;
    *x = *y;
    *y = temp;
}



@end
