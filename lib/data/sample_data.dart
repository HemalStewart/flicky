import '../models/media_item.dart';

const dummyVideoUrl =
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

const trendingItems = [
  MediaItem(
    title: 'Cruella',
    year: '2021',
    duration: '2h 14m',
    category: 'Drama',
    imageUrl: 'https://image.tmdb.org/t/p/w500/6MKr3KgOLmzOP6MSuZERO41Lpkt.jpg',
    rating: 4.5,
    description:
        'A live-action prequel feature film following a young Cruella de Vil.',
    cast: ['Emma Stone', 'Emma Thompson', 'Paul Walter Hauser'],
    director: 'Craig Gillespie',
    tags: ['Drama', 'Crime', 'Fashion'],
    trailerUrl: dummyVideoUrl,
    videoUrl: dummyVideoUrl,
  ),
  MediaItem(
    title: 'Red Notice',
    year: '2021',
    duration: '1h 58m',
    category: 'Action',
    imageUrl: 'https://image.tmdb.org/t/p/w500/rktDFPbfHfUbArZ6OOOKsXcv0Bm.jpg',
    rating: 4.2,
    description:
        'An FBI profiler is forced to partner with the world’s greatest art thief.',
    cast: ['Dwayne Johnson', 'Ryan Reynolds', 'Gal Gadot'],
    director: 'Rawson Marshall Thurber',
    tags: ['Action', 'Comedy', 'Heist'],
    trailerUrl: dummyVideoUrl,
    videoUrl: dummyVideoUrl,
  ),
  MediaItem(
    title: 'Avatar',
    year: '2009',
    duration: '2h 42m',
    category: 'Sci-Fi',
    imageUrl: 'https://image.tmdb.org/t/p/w500/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg',
    rating: 4.7,
    description:
        'A paraplegic Marine dispatched to the moon Pandora on a unique mission.',
    cast: ['Sam Worthington', 'Zoe Saldana', 'Sigourney Weaver'],
    director: 'James Cameron',
    tags: ['Sci-Fi', 'Adventure'],
    trailerUrl: dummyVideoUrl,
    videoUrl: dummyVideoUrl,
  ),
];

const movieItems = [
  MediaItem(
    title: 'Joker',
    year: '2019',
    duration: '2h 2m',
    category: 'Crime',
    imageUrl: 'https://image.tmdb.org/t/p/w500/78lPtwv72eTNqFW9COBYI0dWDJa.jpg',
    rating: 4.8,
    description:
        'In Gotham City, mentally troubled comedian Arthur Fleck embarks on a downward spiral.',
    cast: ['Joaquin Phoenix', 'Robert De Niro', 'Zazie Beetz'],
    director: 'Todd Phillips',
    tags: ['Crime', 'Drama', 'DC'],
    trailerUrl: dummyVideoUrl,
    videoUrl: dummyVideoUrl,
  ),
  MediaItem(
    title: 'Interstellar',
    year: '2014',
    duration: '2h 49m',
    category: 'Sci-Fi',
    imageUrl: 'https://image.tmdb.org/t/p/w500/2TeJfUZMGolfDdW6DKhfIWqvq8y.jpg',
    rating: 4.6,
    description:
        'A team of explorers travel through a wormhole in space in an attempt to ensure humanity’s survival.',
    cast: ['Matthew McConaughey', 'Anne Hathaway', 'Jessica Chastain'],
    director: 'Christopher Nolan',
    tags: ['Sci-Fi', 'Drama', 'Space'],
    trailerUrl: dummyVideoUrl,
    videoUrl: dummyVideoUrl,
  ),
  MediaItem(
    title: 'Oppenheimer',
    year: '2023',
    duration: '3h 0m',
    category: 'Drama',
    imageUrl: 'https://image.tmdb.org/t/p/w500/rzdPqYx7Um4FUZeD8wpXqjAUcEm.jpg',
    rating: 4.7,
    description:
        'The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb.',
    cast: ['Cillian Murphy', 'Emily Blunt', 'Robert Downey Jr.'],
    director: 'Christopher Nolan',
    tags: ['Drama', 'Biography', 'History'],
    trailerUrl: dummyVideoUrl,
    videoUrl: dummyVideoUrl,
  ),
];

const seriesItems = [
  MediaItem(
    title: 'Game of Thrones',
    year: '2019',
    duration: '8 Seasons',
    category: 'Fantasy',
    imageUrl: 'https://image.tmdb.org/t/p/w500/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg',
    description:
        'Nine noble families fight for control over the lands of Westeros.',
    trailerUrl: dummyVideoUrl,
    videoUrl: dummyVideoUrl,
    isSeries: true,
  ),
  MediaItem(
    title: 'Stranger Things',
    year: '2023',
    duration: '4 Seasons',
    category: 'Thriller',
    imageUrl: 'https://image.tmdb.org/t/p/w500/x2LSRK2Cm7MZhjluni1msVJ3wDF.jpg',
    description:
        'A group of young friends witness supernatural forces and secret government exploits.',
    trailerUrl: dummyVideoUrl,
    videoUrl: dummyVideoUrl,
    isSeries: true,
  ),
  MediaItem(
    title: 'The Boys',
    year: '2024',
    duration: '4 Seasons',
    category: 'Action',
    imageUrl: 'https://image.tmdb.org/t/p/w500/od22ftNnyag0TTxcnJhlsu3aLoU.jpg',
    description:
        'A group of vigilantes set out to take down corrupt superheroes who abuse their superpowers.',
    trailerUrl: dummyVideoUrl,
    videoUrl: dummyVideoUrl,
    isSeries: true,
  ),
];
