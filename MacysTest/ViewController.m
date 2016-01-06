//
//  ViewController.m
//  MacysTest
//
//  Created by Akhil Tirumalasetty on 1/5/16.
//  Copyright © 2016 Akhil Tirumalasetty. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
{
    NSMutableArray *keyValues;
    NSMutableArray *years;
    NSMutableArray *vars;
    NSMutableArray *array;
    NSMutableArray *tempArray;
}
@property (weak, nonatomic) IBOutlet UITableView *getData;
@property (weak, nonatomic) IBOutlet UITextField *wordField;

@end

@implementation ViewController
//@synthesize wordField;

- (IBAction)loadData:(UIButton *)sender {
    [self.wordField resignFirstResponder];
    
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
    [self.view addSubview:HUD];
   // HUD.delegate = self.view;
    HUD.labelFont = [UIFont fontWithName:@"Helvetica" size:16];
    HUD.labelText = @"Please wait Loading";
    [HUD showWhileExecuting:@selector(self) onTarget:self withObject:Nil animated:YES];
    HUD.removeFromSuperViewOnHide = YES;
    HUD = nil;
    HUD.delegate = nil;

    [keyValues removeAllObjects];
    [years removeAllObjects];
    [vars removeAllObjects];

#pragma AfnetWorking
    NSString *URLString = [NSString stringWithFormat:@"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=%@",_wordField.text];
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
   
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // if our searching element is not found at our url.
        if([responseObject count] == 0){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Data"
                                                                message:@""
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
     
        //if our searching element is found at our url.
       else{
           //NSLog(@"%@",responseObject);
           
         tempArray  = [[responseObject objectAtIndex:0] objectForKey:@"lfs"];
         for(int i = 0; i < [tempArray count] ; i++){
            [vars  addObject:[[tempArray objectAtIndex:i]valueForKey:@"vars"]];
            array = [vars objectAtIndex:i];
            for (int j = 0; j < array.count; j++) {
                [keyValues addObject:[[array objectAtIndex:j] valueForKey:@"lf"]];
                [years     addObject:[[array objectAtIndex:j] valueForKey:@"since"]];
            }
         }
       }
      [_getData reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error == %@", error);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    [operation start];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    keyValues = [[NSMutableArray alloc]init];
    years     = [[NSMutableArray alloc]init];
    vars      = [[NSMutableArray alloc]init];
    array     = [[NSMutableArray alloc]init];
    tempArray = [[NSMutableArray alloc]init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return keyValues.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text =[keyValues objectAtIndex:indexPath.row];
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",[years objectAtIndex:indexPath.row]];
    return cell;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing :YES];
}


//Key Board dissmiss after press return key

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
//    return NO;
//}


@end











