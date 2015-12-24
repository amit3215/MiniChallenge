//
//  ViewController.m
//  DictionaryTest
//
//  Created by chetu on 12/24/15.
//  Copyright © 2015 com.chetudeveloper.Test. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSArray *allWords;
}

@property (weak, nonatomic) IBOutlet UITextField *textfieldEnter;

- (IBAction)checkForWordExistance:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

// Method to check the word  from  apple native libraray iOS


-(BOOL) isDictionaryWord:(NSString*) word
{
    UITextChecker *checker = [[UITextChecker alloc] init];
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *currentLanguage = [currentLocale objectForKey:NSLocaleLanguageCode];
    NSRange searchRange = NSMakeRange(0, [word length]);
    NSRange misspelledRange = [checker rangeOfMisspelledWordInString:word range: searchRange startingAt:0 wrap:NO language: currentLanguage ];
    return misspelledRange.location == NSNotFound;
}

@end
