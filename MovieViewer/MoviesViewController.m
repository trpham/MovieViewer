//
//  MoviesViewController.m
//  MovieViewer
//
//  Created by nathan on 6/24/17.
//  Copyright © 2017 Nathan Pham. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "DetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@end


@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.movies = @[];
    
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=%@", self.endpoint, apiKey];
    NSURL *url = [NSURL URLWithString:urlString];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSError *jsonError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
//            NSLog(@"Response: %@", responseDictionary);
            self.movies = responseDictionary[@"results"];
            [self.tableView reloadData];
        } else {
            NSLog(@"An error occurred: %@", error.description);
        }
    }];
    
    [task resume];
    
}

- (void)viewWillAppear:(BOOL)animated {
//    NSLog(@"Navigation bar title: %@",self.navigationItem.title);
//    NSLog(@"Tab bar title: %@",self.navigationController.tabBarItem.title);
    self.navigationItem.title = self.navigationController.tabBarItem.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_movies) {
            return _movies.count;
    } else {
        return 0;
    }
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    MovieCell* movieCell = (MovieCell *) cell;
    NSDictionary* movie = self.movies[indexPath.row];
    
    movieCell.titleLabel.text = [NSString stringWithFormat:@"%@", movie[@"title"]];
    movieCell.overviewLabel.text = [NSString stringWithFormat:@"%@", movie[@"overview"]];
    movieCell.ratingLabel.text = [NSString stringWithFormat:@"%@", movie[@"vote_average"]];
    movieCell.releaseDateLabel.text = [NSString stringWithFormat:@"%@", movie[@"release_date"]];
    
    if (movie[@"poster_path"]) {
        NSString *posterPath = movie[@"poster_path"];
        NSString *baseURLString = @"http://image.tmdb.org/t/p/w500";
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", baseURLString, posterPath]];
        NSURLRequest* imageRequest = [NSURLRequest requestWithURL:url];
        
        [movieCell.posterView
         setImageWithURLRequest:imageRequest
         placeholderImage:nil
         success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
             if (response != nil) {
                 // Response will be nil if the image is cached
                 // Image was not cached, fade in image
                 movieCell.posterView.alpha = 0.0;
                 movieCell.posterView.image = image;
                 [UIView animateWithDuration:0.3 animations:^{
                     movieCell.posterView.alpha = 1.0;
                 }];
             } else {
                 // Image was cached, so jsut update the image
                 movieCell.posterView.image = image;
             }
         }
         
         failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
             // Do nothing!
         }];
    }
    
//    Build-in textLabel
//    cell.textLabel.text = title;
//    NSLog(@"row %ld", indexPath.row);
    return cell;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //     Get the new view controller using [segue destinationViewController].
    //     Pass the selected object to the new view controller.
//    UITableViewCell *cell = (UITableViewCell *) sender;
    NSIndexPath *indexPath = _tableView.indexPathForSelectedRow;
    NSDictionary* movie = _movies[indexPath.row];
    UIViewController * viewController = segue.destinationViewController;
    DetailViewController * detailViewController = (DetailViewController *) viewController;
    detailViewController.movie = movie;
//    NSLog(@"%@", movie);
}

@end
