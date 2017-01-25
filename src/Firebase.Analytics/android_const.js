// Constants

// RegExp: ^// public static final String (\w+)[\S\s]+?Constant Value: (\"\w+\")
// Param.$1 = $2;\n
var Param = {};

Param.ACHIEVEMENT_ID = "achievement_id";
Param.CHARACTER = "character";
Param.CONTENT_TYPE = "content_type";
Param.COUPON = "coupon";
Param.CURRENCY = "currency";
Param.DESTINATION = "destination";
Param.END_DATE = "end_date";
Param.FLIGHT_NUMBER = "flight_number";
Param.GROUP_ID = "group_id";
Param.ITEM_CATEGORY = "item_category";
Param.ITEM_ID = "item_id";
Param.ITEM_LOCATION_ID = "item_location_id";
Param.ITEM_NAME = "item_name";
Param.LEVEL = "level";
Param.LOCATION = "location";
Param.NUMBER_OF_NIGHTS = "number_of_nights";
Param.NUMBER_OF_PASSENGERS = "number_of_passengers";
Param.NUMBER_OF_ROOMS = "number_of_rooms";
Param.ORIGIN = "origin";
Param.PRICE = "price";
Param.QUANTITY = "quantity";
Param.SCORE = "score";
Param.SEARCH_TERM = "search_term";
Param.SHIPPING = "shipping";
Param.SIGN_UP_METHOD = "sign_up_method";
Param.START_DATE = "start_date";
Param.TAX = "tax";
Param.TRANSACTION_ID = "transaction_id";
Param.TRAVEL_CLASS = "travel_class";
Param.VALUE = "value";
Param.VIRTUAL_CURRENCY_NAME = "virtual_currency_name";


// Constants
// 

var Event = {};

Event.ADD_PAYMENT_INFO = "add_payment_info";
Event.ADD_TO_CART = "add_to_cart";
Event.ADD_TO_WISHLIST = "add_to_wishlist";
Event.APP_OPEN = "app_open";
Event.BEGIN_CHECKOUT = "begin_checkout";
Event.EARN_VIRTUAL_CURRENCY = "earn_virtual_currency";
Event.ECOMMERCE_PURCHASE = "ecommerce_purchase";
Event.GENERATE_LEAD = "generate_lead";
Event.JOIN_GROUP = "join_group";
Event.LEVEL_UP = "level_up";
Event.LOGIN = "login";
Event.POST_SCORE = "post_score";
Event.PRESENT_OFFER = "present_offer";
Event.PURCHASE_REFUND = "purchase_refund";
Event.SEARCH = "search";
Event.SELECT_CONTENT = "select_content";
Event.SHARE = "share";
Event.SIGN_UP = "sign_up";
Event.SPEND_VIRTUAL_CURRENCY = "spend_virtual_currency";
Event.TUTORIAL_BEGIN = "tutorial_begin";
Event.TUTORIAL_COMPLETE = "tutorial_complete";
Event.UNLOCK_ACHIEVEMENT = "unlock_achievement";
Event.VIEW_ITEM = "view_item";
Event.VIEW_ITEM_LIST = "view_item_list";
Event.VIEW_SEARCH_RESULTS = "view_search_results";
// 

module.exports = {
     Param: Param,
     Event: Event
};

// 
// public static final String ACHIEVEMENT_ID
// 
// Also: Google Play services
// Game achievement ID (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.ACHIEVEMENT_ID, "10_matches_won");
//  
// Constant Value: "achievement_id"
// public static final String CHARACTER
// 
// Also: Google Play services
// Character used in game (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.CHARACTER, "beat_boss");
//  
// Constant Value: "character"
// public static final String CONTENT_TYPE
// 
// Also: Google Play services
// Type of content selected (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.CONTENT_TYPE, "news article");
//  
// Constant Value: "content_type"
// public static final String COUPON
// 
// Also: Google Play services
// Coupon code for a purchasable item (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.COUPON, "zz123");
//  
// Constant Value: "coupon"
// public static final String CURRENCY
// 
// Also: Google Play services
// Purchase currency in 3 letter ISO_4217 format (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.CURRENCY, "USD");
//  
// Constant Value: "currency"
// public static final String DESTINATION
// 
// Also: Google Play services
// Flight or Travel destination (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.DESTINATION, "Mountain View, CA");
//  
// Constant Value: "destination"
// public static final String END_DATE
// 
// Also: Google Play services
// The arrival date, check-out date, or rental end date for the item (String). The parameter expects a date formatted as YYYY-MM-DD and set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.END_DATE, "2015-09-14");
//  
// Constant Value: "end_date"
// public static final String FLIGHT_NUMBER
// 
// Also: Google Play services
// Flight number for travel events (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.FLIGHT_NUMBER, "ZZ800");
//  
// Constant Value: "flight_number"
// public static final String GROUP_ID
// 
// Also: Google Play services
// Group/clan/guild id (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.GROUP_ID, "g1");
//  
// Constant Value: "group_id"
// public static final String ITEM_CATEGORY
// 
// Also: Google Play services
// Item category (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.ITEM_CATEGORY, "t-shirts");
//  
// Constant Value: "item_category"
// public static final String ITEM_ID
// 
// Also: Google Play services
// Item ID (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.ITEM_ID, "p7654");
//  
// Constant Value: "item_id"
// public static final String ITEM_LOCATION_ID
// 
// Also: Google Play services
// The Google Place ID that corresponds to the associated item (String). Alternatively, you can supply your own custom Location ID. The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.ITEM_LOCATION_ID, "ChIJiyj437sx3YAR9kUWC8QkLzQ");
//  
// Constant Value: "item_location_id"
// public static final String ITEM_NAME
// 
// Also: Google Play services
// Item name (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.ITEM_NAME, "abc");
//  
// Constant Value: "item_name"
// public static final String LEVEL
// 
// Also: Google Play services
// Level in game (long). The parameter expects a long value set with putLong(String, long):
// 
// 
//      Bundle params = new Bundle();
//      params.putLong(Param.LEVEL, 42);
//  
// Constant Value: "level"
// public static final String LOCATION
// 
// Also: Google Play services
// Location (String). The Google Place ID that corresponds to the associated event. Alternatively, you can supply your own custom Location ID. The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.LOCATION, "Mountain View, CA");
//  
// Constant Value: "location"
// public static final String NUMBER_OF_NIGHTS
// 
// Also: Google Play services
// Number of nights staying at hotel (long). The parameter expects a long value set with putLong(String, long):
// 
// 
//      Bundle params = new Bundle();
//      params.putLong(Param.NUMBER_OF_NIGHTS, 3);
//  
// Constant Value: "number_of_nights"
// public static final String NUMBER_OF_PASSENGERS
// 
// Also: Google Play services
// Number of passengers traveling (long). The parameter expects a long value set with putLong(String, long):
// 
// 
//      Bundle params = new Bundle();
//      params.putLong(Param.NUMBER_OF_PASSENGERS, 11);
//  
// Constant Value: "number_of_passengers"
// public static final String NUMBER_OF_ROOMS
// 
// Also: Google Play services
// Number of rooms for travel events (long). The parameter expects a long value set with putLong(String, long):
// 
// 
//      Bundle params = new Bundle();
//      params.putLong(Param.NUMBER_OF_ROOMS, 2);
//  
// Constant Value: "number_of_rooms"
// public static final String ORIGIN
// 
// Also: Google Play services
// Flight or Travel origin (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.ORIGIN, "Mountain View, CA");
//  
// Constant Value: "origin"
// public static final String PRICE
// 
// Also: Google Play services
// Purchase price (double). Expecting a double value set with putDouble(String, double):
// 
// 
//      Bundle params = new Bundle();
//      params.putDouble(Param.PRICE, 1.0);
//      params.putString(Param.CURRENCY, "USD"); // e.g. $1.00 USD
//  
// Constant Value: "price"
// public static final String QUANTITY
// 
// Also: Google Play services
// Purchase quantity (long). The parameter expects a long value set with putLong(String, long):
// 
// 
//      Bundle params = new Bundle();
//      params.putLong(Param.QUANTITY, 1);
//  
// Constant Value: "quantity"
// public static final String SCORE
// 
// Also: Google Play services
// Score in game (long). The parameter expects a long value set with putLong(String, long):
// 
// 
//      Bundle params = new Bundle();
//      params.putLong(Param.SCORE, 4200);
//  
// Constant Value: "score"
// public static final String SEARCH_TERM
// 
// Also: Google Play services
// The search string/keywords used (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.SEARCH_TERM, "periodic table");
//  
// Constant Value: "search_term"
// public static final String SHIPPING
// 
// Also: Google Play services
// Shipping cost (double). Expecting a double value set with putDouble(String, double):
// 
// 
//      Bundle params = new Bundle();
//      params.putDouble(Param.SHIPPING, 9.50);
//      params.putString(Param.CURRENCY, "USD"); // e.g. $9.50 USD
//  
// Constant Value: "shipping"
// public static final String SIGN_UP_METHOD
// 
// Also: Google Play services
// Signup method (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.SIGN_UP_METHOD, "google");
//  
// Constant Value: "sign_up_method"
// public static final String START_DATE
// 
// Also: Google Play services
// The departure date, check-in date, or rental start date for the item (String). The parameter expects a date formatted as YYYY-MM-DD and set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.START_DATE, "2015-09-14");
//  
// Constant Value: "start_date"
// public static final String TAX
// 
// Also: Google Play services
// Tax amount (double). Expecting a double value set with putDouble(String, double):
// 
// 
//      Bundle params = new Bundle();
//      params.putDouble(Param.TAX, 1.0);
//      params.putString(Param.CURRENCY, "USD" );  // e.g. $1.00 USD
//  
// Constant Value: "tax"
// public static final String TRANSACTION_ID
// 
// Also: Google Play services
// A single ID for a ecommerce group transaction (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.TRANSACTION_ID, "ab7236dd9823");
//  
// Constant Value: "transaction_id"
// public static final String TRAVEL_CLASS
// 
// Also: Google Play services
// Travel class (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.TRAVEL_CLASS, "business");
//  
// Constant Value: "travel_class"
// public static final String VALUE
// 
// Also: Google Play services
// A context-specific numeric value which is accumulated automatically for each event type. Value should be specified with putLong(String, long) or putDouble(String, double). This is a general purpose parameter that is useful for accumulating a key metric that pertains to an event. Examples include revenue, distance, time, and points. Notes: Currency-related values should be supplied using type double and should be accompanied by a CURRENCY param. The valid range of accumulated values is [-9,223,372,036,854.77, 9,223,372,036,854.77].
// 
// 
//      Bundle params = new Bundle();
//      params.putDouble(Param.VALUE, 3.99);
//      params.putString(Param.CURRENCY, "USD" );  // e.g. $3.99 USD
//  
// Constant Value: "value"
// public static final String VIRTUAL_CURRENCY_NAME
// 
// Also: Google Play services
// Name of virtual currency type (String). The parameter expects a string value set with putString(String, String):
// 
// 
//      Bundle params = new Bundle();
//      params.putString(Param.VIRTUAL_CURRENCY_NAME, "gems");
//  
// Constant Value: "virtual_currency_name"
// 


// Constants
// 
// public static final String ADD_PAYMENT_INFO
// 
// Also: Google Play services
// Add Payment Info event. This event signifies that a user has submitted their payment information to your app.
// 
// Constant Value: "add_payment_info"
// public static final String ADD_TO_CART
// 
// Also: Google Play services
// E-Commerce Add To Cart event. This event signifies that an item was added to a cart for purchase. Add this event to a funnel with ECOMMERCE_PURCHASE to gauge the effectiveness of your checkout process. Note: If you supply the VALUE parameter, you must also supply the CURRENCY parameter so that revenue metrics can be computed accurately. Params:
// 
// ITEM_ID (String)
// ITEM_NAME (String)
// ITEM_CATEGORY (String)
// QUANTITY (long)
// PRICE (double) (optional)
// VALUE (double) (optional)
// CURRENCY (String) (optional)
// ORIGIN (String) (optional)
// ITEM_LOCATION_ID (String) (optional)
// DESTINATION (String) (optional)
// START_DATE (String) (optional)
// END_DATE (String) (optional)
// Constant Value: "add_to_cart"
// public static final String ADD_TO_WISHLIST
// 
// Also: Google Play services
// E-Commerce Add To Wishlist event. This event signifies that an item was added to a wishlist. Use this event to identify popular gift items in your app. Note: If you supply the VALUE parameter, you must also supply the CURRENCY parameter so that revenue metrics can be computed accurately. Params:
// 
// ITEM_ID (String)
// ITEM_NAME (String)
// ITEM_CATEGORY (String)
// QUANTITY (long)
// PRICE (double) (optional)
// VALUE (double) (optional)
// CURRENCY (String) (optional)
// ITEM_LOCATION_ID (String) (optional)
// Constant Value: "add_to_wishlist"
// public static final String APP_OPEN
// 
// Also: Google Play services
// App Open event. By logging this event when an App is moved to the foreground, developers can understand how often users leave and return during the course of a Session. Although Sessions are automatically reported, this event can provide further clarification around the continuous engagement of app-users.
// 
// Constant Value: "app_open"
// public static final String BEGIN_CHECKOUT
// 
// Also: Google Play services
// E-Commerce Begin Checkout event. This event signifies that a user has begun the process of checking out. Add this event to a funnel with your ECOMMERCE_PURCHASE event to gauge the effectiveness of your checkout process. Note: If you supply the VALUE parameter, you must also supply the CURRENCY parameter so that revenue metrics can be computed accurately. Params:
// 
// VALUE (double) (optional)
// CURRENCY (String) (optional)
// TRANSACTION_ID (String) (optional)
// NUMBER_OF_NIGHTS (long) (optional) for hotel bookings
// NUMBER_OF_ROOMS (long) (optional) for hotel bookings
// NUMBER_OF_PASSENGERS (long) (optional) for travel bookings
// ORIGIN (String) (optional) for travel bookings
// DESTINATION (String) (optional) for travel bookings
// START_DATE (String) (optional) for travel bookings
// END_DATE (String) (optional) for travel bookings
// TRAVEL_CLASS (String) (optional) for travel bookings
// Constant Value: "begin_checkout"
// public static final String EARN_VIRTUAL_CURRENCY
// 
// Also: Google Play services
// Earn Virtual Currency event. This event tracks the awarding of virtual currency in your app. Log this along with SPEND_VIRTUAL_CURRENCY to better understand your virtual economy. Params:
// 
// VIRTUAL_CURRENCY_NAME (String)
// VALUE (long or double)
// Constant Value: "earn_virtual_currency"
// public static final String ECOMMERCE_PURCHASE
// 
// Also: Google Play services
// E-Commerce Purchase event. This event signifies that an item was purchased by a user. Note: This is different from the in-app purchase event, which is reported automatically for Google Play-based apps. Note: If you supply the VALUE parameter, you must also supply the CURRENCY parameter so that revenue metrics can be computed accurately. Params:
// 
// CURRENCY (String) (optional)
// VALUE (double) (optional)
// TRANSACTION_ID (String) (optional)
// TAX (double) (optional)
// SHIPPING (double) (optional)
// COUPON (String) (optional)
// LOCATION (String) (optional)
// NUMBER_OF_NIGHTS (long) (optional) for hotel bookings
// NUMBER_OF_ROOMS (long) (optional) for hotel bookings
// NUMBER_OF_PASSENGERS (long) (optional) for travel bookings
// ORIGIN (String) (optional) for travel bookings
// DESTINATION (String) (optional) for travel bookings
// START_DATE (String) (optional) for travel bookings
// END_DATE (String) (optional) for travel bookings
// TRAVEL_CLASS (String) (optional) for travel bookings
// Constant Value: "ecommerce_purchase"
// public static final String GENERATE_LEAD
// 
// Also: Google Play services
// Generate Lead event. Log this event when a lead has been generated in the app to understand the efficacy of your install and re-engagement campaigns. Note: If you supply the VALUE parameter, you must also supply the CURRENCY parameter so that revenue metrics can be computed accurately. Params:
// 
// CURRENCY (String) (optional)
// VALUE (double) (optional)
// Constant Value: "generate_lead"
// public static final String JOIN_GROUP
// 
// Also: Google Play services
// Join Group event. Log this event when a user joins a group such as a guild, team or family. Use this event to analyze how popular certain groups or social features are in your app. Params:
// 
// GROUP_ID (String)
// Constant Value: "join_group"
// public static final String LEVEL_UP
// 
// Also: Google Play services
// Level Up event. This event signifies that a player has leveled up in your gaming app. It can help you gauge the level distribution of your userbase and help you identify certain levels that are difficult to pass. Params:
// 
// LEVEL (long)
// CHARACTER (String) (optional)
// Constant Value: "level_up"
// public static final String LOGIN
// 
// Also: Google Play services
// Login event. Apps with a login feature can report this event to signify that a user has logged in.
// 
// Constant Value: "login"
// public static final String POST_SCORE
// 
// Also: Google Play services
// Post Score event. Log this event when the user posts a score in your gaming app. This event can help you understand how users are actually performing in your game and it can help you correlate high scores with certain audiences or behaviors. Params:
// 
// SCORE (long)
// LEVEL (long) (optional)
// CHARACTER (String) (optional)
// Constant Value: "post_score"
// public static final String PRESENT_OFFER
// 
// Also: Google Play services
// Present Offer event. This event signifies that the app has presented a purchase offer to a user. Add this event to a funnel with the ADD_TO_CART and ECOMMERCE_PURCHASE to gauge your conversion process. Note: If you supply the VALUE parameter, you must also supply the CURRENCY parameter so that revenue metrics can be computed accurately. Params:
// 
// ITEM_ID (String)
// ITEM_NAME (String)
// ITEM_CATEGORY (String)
// QUANTITY (long)
// PRICE (double) (optional)
// VALUE (double) (optional)
// CURRENCY (String) (optional)
// ITEM_LOCATION_ID (String) (optional)
// Constant Value: "present_offer"
// public static final String PURCHASE_REFUND
// 
// Also: Google Play services
// E-Commerce Purchase Refund event. This event signifies that an item purchase was refunded. Note: If you supply the VALUE parameter, you must also supply the CURRENCY parameter so that revenue metrics can be computed accurately. Params:
// 
// CURRENCY (String) (optional)
// VALUE (double) (optional)
// TRANSACTION_ID (String) (optional)
// Constant Value: "purchase_refund"
// public static final String SEARCH
// 
// Also: Google Play services
// Search event. Apps that support search features can use this event to contextualize search operations by supplying the appropriate, corresponding parameters. This event can help you identify the most popular content in your app. Params:
// 
// SEARCH_TERM (String)
// NUMBER_OF_NIGHTS (long) (optional) for hotel bookings
// NUMBER_OF_ROOMS (long) (optional) for hotel bookings
// NUMBER_OF_PASSENGERS (long) (optional) for travel bookings
// ORIGIN (String) (optional) for travel bookings
// DESTINATION (String) (optional) for travel bookings
// START_DATE (String) (optional) for travel bookings
// END_DATE (String) (optional) for travel bookings
// TRAVEL_CLASS (String) (optional) for travel bookings
// Constant Value: "search"
// public static final String SELECT_CONTENT
// 
// Also: Google Play services
// Select Content event. This general purpose event signifies that a user has selected some content of a certain type in an app. The content can be any object in your app. This event can help you identify popular content and categories of content in your app. Params:
// 
// CONTENT_TYPE (String)
// ITEM_ID (String)
// Constant Value: "select_content"
// public static final String SHARE
// 
// Also: Google Play services
// Share event. Apps with social features can log the Share event to identify the most viral content. Params:
// 
// CONTENT_TYPE (String)
// ITEM_ID (String)
// Constant Value: "share"
// public static final String SIGN_UP
// 
// Also: Google Play services
// Sign Up event. This event indicates that a user has signed up for an account in your app. The parameter signifies the method by which the user signed up. Use this event to understand the different behaviors between logged in and logged out users. Params:
// 
// SIGN_UP_METHOD (String)
// Constant Value: "sign_up"
// public static final String SPEND_VIRTUAL_CURRENCY
// 
// Also: Google Play services
// Spend Virtual Currency event. This event tracks the sale of virtual goods in your app and can help you identify which virtual goods are the most popular objects of purchase. Params:
// 
// ITEM_NAME (String)
// VIRTUAL_CURRENCY_NAME (String)
// VALUE (long or double)
// Constant Value: "spend_virtual_currency"
// public static final String TUTORIAL_BEGIN
// 
// Also: Google Play services
// Tutorial Begin event. This event signifies the start of the on-boarding process in your app. Use this in a funnel with TUTORIAL_COMPLETE to understand how many users complete this process and move on to the full app experience.
// 
// Constant Value: "tutorial_begin"
// public static final String TUTORIAL_COMPLETE
// 
// Also: Google Play services
// Tutorial End event. Use this event to signify the user's completion of your app's on-boarding process. Add this to a funnel with TUTORIAL_BEGIN to gauge the completion rate of your on-boarding process.
// 
// Constant Value: "tutorial_complete"
// public static final String UNLOCK_ACHIEVEMENT
// 
// Also: Google Play services
// Unlock Achievement event. Log this event when the user has unlocked an achievement in your game. Since achievements generally represent the breadth of a gaming experience, this event can help you understand how many users are experiencing all that your game has to offer. Params:
// 
// ACHIEVEMENT_ID (String)
// Constant Value: "unlock_achievement"
// public static final String VIEW_ITEM
// 
// Also: Google Play services
// View Item event. This event signifies that some content was shown to the user. This content may be a product, a webpage or just a simple image or text. Use the appropriate parameters to contextualize the event. Use this event to discover the most popular items viewed in your app. Note: If you supply the VALUE parameter, you must also supply the CURRENCY parameter so that revenue metrics can be computed accurately. Params:
// 
// ITEM_ID (String)
// ITEM_NAME (String)
// ITEM_CATEGORY (String)
// ITEM_LOCATION_ID (String) (optional)
// PRICE (double) (optional)
// QUANTITY (long) (optional)
// CURRENCY (String) (optional)
// VALUE (double) (optional)
// FLIGHT_NUMBER (String) (optional) for travel bookings
// NUMBER_OF_PASSENGERS (long) (optional) for travel bookings
// NUMBER_OF_NIGHTS (long) (optional) for travel bookings
// NUMBER_OF_ROOMS (long) (optional) for travel bookings
// ORIGIN (String) (optional) for travel bookings
// DESTINATION (String) (optional) for travel bookings
// START_DATE (String) (optional) for travel bookings
// END_DATE (String) (optional) for travel bookings
// SEARCH_TERM (String) (optional) for travel bookings
// TRAVEL_CLASS (String) (optional) for travel bookings
// Constant Value: "view_item"
// public static final String VIEW_ITEM_LIST
// 
// Also: Google Play services
// View Item List event. Log this event when the user has been presented with a list of items of a certain category. Params:
// 
// ITEM_CATEGORY (String)
// Constant Value: "view_item_list"
// public static final String VIEW_SEARCH_RESULTS
// 
// Also: Google Play services
// View Search Results event. Log this event when the user has been presented with the results of a search. Params:
// 
// SEARCH_TERM (String)
// Constant Value: "view_search_results"
// 