//
//  DetailViewController.m
//  MovieViewer
//
//  Created by nathan on 6/25/17.
//  Copyright © 2017 Nathan Pham. All rights reserved.
//

#import "DetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // self.infoView.frame.origin.y: Start at Y axis: ~603 (== scrollView.frame.size.height)
    // self.infoView.frame.size.height: How far Y down
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.infoView.frame.origin.y + self.infoView.frame.size.height);
    
    self.titleLabel.text = self.movie[@"title"];
    self.overviewLabel.text = self.movie[@"overview"];
    [self.overviewLabel sizeToFit];
    
    if (self.movie[@"poster_path"]) {
        NSString *posterPath = self.movie[@"poster_path"];
        NSString *baseURLString = @"http://image.tmdb.org/t/p/w500";
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", baseURLString, posterPath]];
        [self.posterImageView setImageWithURL:url];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

@end
