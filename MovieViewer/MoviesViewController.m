#import "MoviesViewController.h"
#import "DetailViewController.h"
#import "MovieCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.movies = @[];
    self.filteredMovies = @[];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    NSURLSessionDataTask *task = self.handleAPIRequest;
    [task resume];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.tableView reloadData];
}

- (NSURLSessionDataTask *)handleAPIRequest {
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=%@", self.endpoint, apiKey];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse*  _Nullable response, NSError*  _Nullable error) {
        if (!error) {
            NSError *jsonError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            // NSLog(@"Response: %@", responseDictionary);
            self.movies = responseDictionary[@"results"];
            [self.tableView reloadData];
        }
        else {
            NSLog(@"An error occurred: %@", error.description);
        }
    }];
    
    return task;
}

- (NSURLSessionDataTask *)refreshControlAction: (UIRefreshControl *)refreshControl {
    NSURLSessionDataTask *task = self.handleAPIRequest;
    [refreshControl endRefreshing];
    return task;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = self.navigationController.tabBarItem.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    MovieCell *movieCell = (MovieCell *) cell;
    NSDictionary *movie = self.movies[indexPath.row];
    
    movieCell.titleLabel.text = [NSString stringWithFormat:@"%@", movie[@"title"]];
    movieCell.overviewLabel.text = [NSString stringWithFormat:@"%@", movie[@"overview"]];
    movieCell.ratingLabel.text = [NSString stringWithFormat:@"🌟 %@", movie[@"vote_average"]];
    movieCell.releaseDateLabel.text = [NSString stringWithFormat:@"🎬 %@", movie[@"release_date"]];
    
    if (movie[@"poster_path"]) {
        NSString *posterPath = movie[@"poster_path"];
        NSString *baseURLString = @"http://image.tmdb.org/t/p/w500";
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", baseURLString, posterPath]];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url];
        
        [movieCell.posterView setImageWithURLRequest:imageRequest
                                    placeholderImage:nil
                                             success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
             if (response) {
                 // Response will be nil if the image is cached
                 // Image was not cached, fade in image
                 movieCell.posterView.alpha = 0.0;
                 movieCell.posterView.image = image;
                 [UIView animateWithDuration:0.3 animations:^{
                     movieCell.posterView.alpha = 1.0;
                 }];
             }
             else {
                 // Image was cached, so jsut update the image
                 movieCell.posterView.image = image;
             }
         }
         failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
             // Do nothing!
         }];
    }
    
    return cell;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = _tableView.indexPathForSelectedRow;
    NSDictionary *movie = _movies[indexPath.row];
    UIViewController  *viewController = segue.destinationViewController;
    DetailViewController  *detailViewController = (DetailViewController *) viewController;
    detailViewController.movie = movie;

}

@end
