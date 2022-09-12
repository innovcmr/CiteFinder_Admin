class Config {
  // Here, input any variables deemed necessary. This file should be made global to avoid import everytime before usage i.e
  // Uncomment lines below and customize if needed
  // static final apiUrl = "http://192.168.43.49:5000/";
  static final keys = _Keys();
  static final assets = _Assets();
  static final firebaseKeys = _firebaseKeys();
  static final appName = "Cite Finder Admin";
  // static final countryCode = "+237";
  // static final appKeyAndroid = "j8V634F9f0x8DGkqj4HkT6bELJWd0mBt";
}

class _Keys {
  // Here, all getStorage keys will be stored. preferrable to make two atrributes andvalues the same (in nomenclature) i.e.
  // final token = "token";
  // final user = "user";
  // uncomment if needed
  final fisrtOpen = 'firstOpen';
  final userIsLogIn = "userIsLogIn";
  final selectedUser = "selectedUser";
  final selectedHome = "selectedHome";
  final selectedAgent = "selectedAgent";
}

class _Assets {
  // here, input all assets to be used and links to them i.e
  // final logo = "assets/images/logo.png";
  // final english = "assets/images/english.svg";
  // final french = "assets/images/french.svg";
  final loginBg = "assets/images/loginBg.jpeg";
  final logo = "assets/images/logo.png";
}

class _firebaseKeys {
  final String id = "id";
  final String username = "username";
  final String password = "password";
  final String email = "email";
  final String birthDate = "birth_date";
  final String firstName = "first_name";
  final String lastName = "last_name";
  final String isActive = "is_active";
  final String code = "code";
  final String country = "country";
  final String phoneNumber = "phoneNumber";
  final String status = "status";
  final String message = "message";
  final String otp = "OTP";
  final String accessToken = "access_token";
  final String refreshToken = "refresh_token";
  final String preferedTheme = "prefered_theme";
  final String preferredLanguage = "preferred_language";
  final String body = "body";
  final String access = "access";
  final String refresh = "refresh";
  final String detail = "detail";
  final String isNotFirstLogin = "isNotFirstLogin";
  final String signup = "signup";
  final String login = "login";
  final String authorization = "Authorization";
  final String jwt = "JWT";
  final String tenant = "tenant";
  final String landlord = "landlord";
  final String users = 'users';
  final String user = "user";
  final String fullName = "fullName";
  final String location = "location";
  final String role = "role";
  final String photoURL = "photoURL";
  final String isVerified = "isVerified";
  final String isGoogleUser = "isGoogleUser";
  final String isFacebookUser = "isFacebookUser";
  final String description = "description";
  final String home = "home";
  final String homes = "homes";
  final String name = "name";
  final String type = "type";
  final String mainImage = "mainImage";
  final String shortVideo = "shortVideo";
  final String rating = "rating";
  final String ratings = "ratings";
  final String dateAdded = "dateAdded";
  final String dateModified = "dateModified";
  final String waterAvailability = "waterAvailability";
  final String electricityAvailability = "electricityAvailability";
  final String security = "security";
  final String images = "images";
  final String numberAvailable = "numberAvailable";
  final String price = "price";
  final String homeRooms = 'home_rooms';
  final String homeComments = 'home_comments';
  final String text = "text";
  final String replyingTo = "replyingTo";
  final String favorites = "favorites";
  final String facilities = "facilities";
  final String geoCoordinates = "geoCoordinates";
  final String city = "city";
  final String quarter = "quarter";
  final String town = "town";
  final String locations = "locations";
  final String basePrice = "basePrice";

  final String HomePage = "HomePage";
  final String ProfilePage = "ProfilePage";
  final String FavoritesPage = "FavoritesPage";
  final String AllChatsPage = "AllChatsPage";
  final String MyHomes = "MyHomes";

  final String userA = "userA";
  final String userB = "userB";
  final String usersAB = "usersAB";
  final String lastMessage = "lastMessage";
  final String lastMessageSeenBy = "lastMessageSeenBy";
  final String lastMessageSentBy = "lastMessageSentBy";
  final String lastMessageTime = "lastMessageTime";
  final String chats = "chats";
  final String chat_messages = "chat_messages";
  final String chat = "chat";
  final String timestamp = "timestamp";
  final String image = "image";
  final String isRead = "isRead";
  final String source = "source";
  final String isApproved = "isApproved";

  //list of cities

  final List<String> availableCities = [
    'Bamenda',
    'Buea',
    'Yaounde',
    'Douala',
    'Bafoussam',
    'Bambili',
    'Limbe',
    'Kumba',
    'Muyuka',
    'Edea',
    'Soa',
  ];

  final List<String> categories = [
    "All",
    "Recent",
    "Popular",
    "Trending",
    "Recommended",
    "Luxury"
  ];

  final List<String> availableAccomodations = [
    "ALL",
    "HOSTEL",
    "APPARTMENT",
    "STUDIO",
    "HOTEL",
    "MOTEL",
    "HOUSE"
  ];

  final List<String> roomTypes = [
    "Single Room",
    "Modern Room",
  ];

  final List<String> availableFacilities = [
    'water',
    'electricity',
    'parking',
    'bar',
    'swimming pool',
    'wifi',
    'generator',
    'restaurant'
  ];
  final List<String> userRole = [
    'tenant',
    'landlord',
    'agent',
    'admin',
  ];
}
