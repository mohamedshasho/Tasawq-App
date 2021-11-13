const String ID = 'id';
const String USERNAME = 'username';
const String EMAIL = 'email';
const String NAME = 'name';
const String PRICE = 'price';
const String IMAGE = 'image';
const String DESCRIPTION = 'description';
const String DELIVERY = 'delivery';
const String USER = 'user';
const String TYPE_PERSON = 'type_person';
const String CATEGORY_NAME = 'categoryName';
const String FAVORITE = 'favorite';
const String CATEGORY = 'category';
const String PRODUCTS = 'products';
const String CATEGORIES = 'categories';
const String ALL = 'All';
const String LOCATION = 'location';
const String LAT = 'lat';
const String LONG = 'long';
const String LOCALITY = 'locality';
const String SUB_LOCALITY = 'subLocality';
const String RATING = 'rating';
const String DATA = 'data';
const String PERSON = 'person';
const String FOLLOWERS = 'followers';
const String FOLLOWING = 'following';
const String RECEIVER_ID = 'receiverID';
const String SEND_ID = 'sendID';
const String CHATS = 'chats';
const String MESSAGES = 'messages';
const String USERS = 'users';
const String TEXT = 'text';
const String READ = 'read';
const String DATE_TIME = 'dateTime';
const String TOKEN = 'token';
const String LIGHT = 'light';
const String DARK = 'dark';
const String SYSTEM = 'system';
const String THEME = 'theme';
const String LANGUAGE_CODE = 'languageCode';

const String BaseURL = 'https://tasawq-8c728-default-rtdb.firebaseio.com/';
const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
const String fcmKey =
    'AAAAyd6jR-Y:APA91bHwJpzrgUdA1XqfjUDg90EXR22jIxw2RZcdlY849vZ9yFnZT7YHBR2iKu5f00DYrboDTlxisszErLYqvuoVojGsZ21DP9cXIO4YM7mfBoiXmeMg3wtExKkmTg6WIJdc4meEHt1L';
const String URLPerson = BaseURL + PERSON + '.json';

//todo and also add more category in list on auth screen
const List<String> categoriesString = [
  'All',
  'Cars',
  'Tools',
  'Motorcycle',
  'Outlet',
  'Home Appliances',
  'Devices',
  'Real Estate',
  'Animals',
  'Furniture',
  'Personal Accessories',
];
const List<String> categoriesImage = [
  'assets/images/all.svg',
  'assets/images/car.svg',
  'assets/images/tools.svg',
  'assets/images/motorcycle.svg',
  'assets/images/outlet.svg',
  'assets/images/HomeAppliances.svg',
  'assets/images/ElectricalAppliances.svg',
  'assets/images/house.svg',
  'assets/images/Animals.svg',
  'assets/images/Furniture.svg',
  'assets/images/Personal Accessories.svg',
];
