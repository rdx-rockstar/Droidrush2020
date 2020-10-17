class User {
  final int id;
  final String name;
  final String imageUrl;
  final bool isOnline;
  final String uid;

  User({
    this.id,
    this.name,
    this.imageUrl,
    this.isOnline,
    this.uid,
  });
}

// YOU - current user
final User currentUser = User(
  id: 0,
  name: 'Nick Fury',
  imageUrl: 'assets/images/nick-fury.jpg',
  isOnline: true,
);

// USERS
final User ironMan = User(
  id: 1,
  name: 'Iron Man',
  imageUrl: 'assets/images/ironman.jpeg',
  isOnline: true,
);
