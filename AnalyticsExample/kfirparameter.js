var kFIRParameter = {};
module.exports = kFIRParameter;

/// @file FIRParameterNames.h
///
/// Predefined event parameter names.
///
/// Params supply information that contextualize Events. You can associate up to 25 unique Params
/// with each Event type. Some Params are suggested below for certain common Events, but you are
/// not limited to these. You may supply extra Params for suggested Events or custom Params for
/// Custom events. Param names can be up to 24 characters long, may only contain alphanumeric
/// characters and underscores ("_"), and must start with an alphabetic character. Param values can
/// be up to 36 characters long. The "firebase_" prefix is reserved and should not be used.

/// Game achievement ID (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterAchievementID : "10_matches_won",
///       // ...
///     };
/// </pre>
kFIRParameter.AchievementID = "achievement_id";

/// Character used in game (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterCharacter : "beat_boss",
///       // ...
///     };
/// </pre>
kFIRParameter.Character = "character";

/// Type of content selected (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterContentType : "news article",
///       // ...
///     };
/// </pre>
kFIRParameter.ContentType = "content_type";

/// Coupon code for a purchasable item (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterCoupon : "zz123",
///       // ...
///     };
/// </pre>
kFIRParameter.Coupon = "coupon";

/// Purchase currency in 3-letter <a href="http://en.wikipedia.org/wiki/ISO_4217#Active_codes">
/// ISO_4217</a> format (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterCurrency : "USD",
///       // ...
///     };
/// </pre>
kFIRParameter.Currency = "currency";

/// Flight or Travel destination (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterDestination : "Mountain View, CA",
///       // ...
///     };
/// </pre>
kFIRParameter.Destination = "destination";

/// The arrival date, check-out date or rental end date for the item. This should be in
/// YYYY-MM-DD format (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterEndDate : "2015-09-14",
///       // ...
///     };
/// </pre>
kFIRParameter.EndDate = "end_date";

/// Flight number for travel events (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterFlightNumber : "ZZ800",
///       // ...
///     };
/// </pre>
kFIRParameter.FlightNumber = "flight_number";

/// Group/clan/guild ID (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterGroupID : "g1",
///       // ...
///     };
/// </pre>
kFIRParameter.GroupID = "group_id";

/// Item category (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterItemCategory : "t-shirts",
///       // ...
///     };
/// </pre>
kFIRParameter.ItemCategory = "item_category";

/// Item ID (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterItemID : "p7654",
///       // ...
///     };
/// </pre>
kFIRParameter.ItemID = "item_id";

/// The Google <a href="https://developers.google.com/places/place-id">Place ID</a> (NSString) that
/// corresponds to the associated item. Alternatively, you can supply your own custom Location ID.
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterItemLocationID : "ChIJiyj437sx3YAR9kUWC8QkLzQ",
///       // ...
///     };
/// </pre>
kFIRParameter.ItemLocationID = "item_location_id";

/// Item name (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterItemName : "abc",
///       // ...
///     };
/// </pre>
kFIRParameter.ItemName = "item_name";

/// Level in game (signed 64-bit integer as NSNumber).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterLevel : @(42),
///       // ...
///     };
/// </pre>
kFIRParameter.Level = "level";

/// Location (NSString). The Google <a href="https://developers.google.com/places/place-id">Place ID
/// </a> that corresponds to the associated event. Alternatively, you can supply your own custom
/// Location ID.
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterLocation : "ChIJiyj437sx3YAR9kUWC8QkLzQ",
///       // ...
///     };
/// </pre>
kFIRParameter.Location = "location";

/// Number of nights staying at hotel (signed 64-bit integer as NSNumber).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterNumberOfNights : @(3),
///       // ...
///     };
/// </pre>
kFIRParameter.NumberOfNights = "number_of_nights";

/// Number of passengers traveling (signed 64-bit integer as NSNumber).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterNumberOfPassengers : @(11),
///       // ...
///     };
/// </pre>
kFIRParameter.NumberOfPassengers = "number_of_passengers";

/// Number of rooms for travel events (signed 64-bit integer as NSNumber).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterNumberOfRooms : @(2),
///       // ...
///     };
/// </pre>
kFIRParameter.NumberOfRooms = "number_of_rooms";

/// Flight or Travel origin (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterOrigin : "Mountain View, CA",
///       // ...
///     };
/// </pre>
kFIRParameter.Origin = "origin";

/// Purchase price (double as NSNumber).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterPrice : @(1.0),
///       kFIRParameterCurrency : "USD",  // e.g. $1.00 USD
///       // ...
///     };
/// </pre>
kFIRParameter.Price = "price";

/// Purchase quantity (signed 64-bit integer as NSNumber).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterQuantity : @(1),
///       // ...
///     };
/// </pre>
kFIRParameter.Quantity = "quantity";

/// Score in game (signed 64-bit integer as NSNumber).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterScore : @(4200),
///       // ...
///     };
/// </pre>
kFIRParameter.Score = "score";

/// The search string/keywords used (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterSearchTerm : "periodic table",
///       // ...
///     };
/// </pre>
kFIRParameter.SearchTerm = "search_term";

/// Shipping cost (double as NSNumber).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterShipping : @(9.50),
///       kFIRParameterCurrency : "USD",  // e.g. $9.50 USD
///       // ...
///     };
/// </pre>
kFIRParameter.Shipping = "shipping";

/// Sign up method (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterSignUpMethod : "google",
///       // ...
///     };
/// </pre>
kFIRParameter.SignUpMethod = "sign_up_method";

/// The departure date, check-in date or rental start date for the item. This should be in
/// YYYY-MM-DD format (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterStartDate : "2015-09-14",
///       // ...
///     };
/// </pre>
kFIRParameter.StartDate = "start_date";

/// Tax amount (double as NSNumber).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterTax : @(1.0),
///       kFIRParameterCurrency : "USD",  // e.g. $1.00 USD
///       // ...
///     };
/// </pre>
kFIRParameter.Tax = "tax";

/// A single ID for a ecommerce group transaction (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterTransactionID : "ab7236dd9823",
///       // ...
///     };
/// </pre>
kFIRParameter.TransactionID = "transaction_id";

/// Travel class (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterTravelClass : "business",
///       // ...
///     };
/// </pre>
kFIRParameter.TravelClass = "travel_class";

/// A context-specific numeric value which is accumulated automatically for each event type. This is
/// a general purpose parameter that is useful for accumulating a key metric that pertains to an
/// event. Examples include revenue, distance, time and points. Value should be specified as signed
/// 64-bit integer or double as NSNumber. Notes: Currency-related values should be supplied using
/// double as NSNumber and must be accompanied by a {@link kFIRParameterCurrency} parameter. The
/// valid range of accumulated values is [-9,223,372,036,854.77, 9,223,372,036,854.77].
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterValue : @(3.99),
///       kFIRParameterCurrency : "USD",  // e.g. $3.99 USD
///       // ...
///     };
/// </pre>
kFIRParameter.Value = "value";

/// Name of virtual currency type (NSString).
/// <pre>
///     NSDictionary *params = @{
///       kFIRParameterVirtualCurrencyName : "virtual_currency_name",
///       // ...
///     };
/// </pre>
kFIRParameter.VirtualCurrencyName = "virtual_currency_name";
