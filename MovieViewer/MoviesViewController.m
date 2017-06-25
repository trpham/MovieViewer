//
//  MoviesViewController.m
//  MovieViewer
//
//  Created by nathan on 6/24/17.
//  Copyright © 2017 Nathan Pham. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) NSArray *movies;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
    
    self.movies = @[];
    
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString = [@"https://api.themoviedb.org/3/movie/now_playing?api_key=" stringByAppendingString:apiKey];
    NSURL *url = [NSURL URLWithString:urlString];

    
//    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
//    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
//    let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
//        if let data = data {
//            if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
//                print(dataDictionary)
//            }
//        }
//    }
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSError *jsonError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            NSLog(@"Response: %@", responseDictionary);
            
            self.movies = responseDictionary[@"results"];
            [self.tableView reloadData];
        } else {
            NSLog(@"An error occurred: %@", error.description);
        }
    }];
    
    
//    task.resume()
    [task resume];
    
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
    
    NSString *posterPath = movie[@"poster_path"];
    NSString *baseURLString = @"http://image.tmdb.org/t/p/w500";
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", baseURLString, posterPath]];
    
    [movieCell.posterView setImageWithURL:url];
    movieCell.titleLabel.text = movie[@"title"];
    movieCell.overviewLabel.text = movie[@"overview"];
    
    
    
    
//    Build-in textLabel
//    cell.textLabel.text = title;
    
    NSLog(@"row %ld", indexPath.row);
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
