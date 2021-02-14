import 'package:sonr_app/data/social_medium.dart';
import 'package:sonr_app/data/social_twitter.dart';
import 'package:sonr_app/data/social_youtube.dart';
import 'package:sonr_app/data/tuple.dart';
import 'package:sonr_app/service/sql_service.dart';
import 'package:sonr_core/sonr_core.dart';

// ****************************************** //
// ** Class For TransferCard Query Results ** //
// ****************************************** //
class QueryCardResult {
  // Query Utility
  static Map<String, String> categories = {
    "Payload": cardColumnPayload,
    "Platform": cardColumnPlatform,
    "FirstName": cardColumnFirstName,
    "LastName": cardColumnLastName,
    "UserName": cardColumnUserName,
  };

  // Properties
  final int count;
  final String query;

  // Setter References
  List<TransferCard> _payload = [];
  List<TransferCard> _platform = [];
  List<TransferCard> _firstName = [];
  List<TransferCard> _lastName = [];
  List<TransferCard> _userName = [];

  // Properties
  List<TransferCard> get payload => _payload;
  List<TransferCard> get platform => _platform;
  List<TransferCard> get firstName => _firstName;
  List<TransferCard> get lastName => _lastName;
  List<TransferCard> get userName => _userName;

  // ** Constructer ** //
  QueryCardResult(this.count, this.query);

  // ^ Method to Set Result by Category ^ //
  List<TransferCard> getResult(String category) {
    // Update by Category
    switch (category) {
      case "Payload":
        return _payload;
        break;
      case "Platform":
        return _platform;
        break;
      case "FirstName":
        return _firstName;
        break;
      case "LastName":
        return _lastName;
        break;
      case "UserName":
        return _userName;
        break;
    }
    return [];
  }

  // ^ Method to Set Result by Category ^ //
  setResult(String type, List<TransferCard> result) {
    // Update by Category
    switch (type) {
      case "Payload":
        _payload = result;
        break;
      case "Platform":
        _platform = result;
        break;
      case "FirstName":
        _firstName = result;
        break;
      case "LastName":
        _lastName = result;
        break;
      case "UserName":
        _userName = result;
        break;
    }
  }

  // ^ GETTER: Returns Total Map ^
  Map<String, List<TransferCard>> get total {
    var map = Map<String, List<TransferCard>>();
    QueryCardResult.categories.keys.forEach((element) {
      map[element] = getResult(element);
    });
    return map;
  }

  // ^ GETTER: Returns Suggestion ^ //
  Tuple<String, TransferCard> get suggestion {
    // @ Initialize
    int mostInstances = 0;
    String category = "";

    // @ Validate
    if (hasSuggestion) {
      // Find List to Query
      total.forEach((type, result) {
        // Find Instances
        var instances = _findInstances(type, result);

        // Update Cards
        if (instances > mostInstances) {
          category = type;
          mostInstances = instances;
        }
      });

      // Return Card
      return Tuple(category, getResult(category).first);
    }

    // @ No Suggestion
    else {
      return Tuple("None", TransferCard());
    }
  }

  // ^ GETTER: Checks if Suggestion has been found ^ //
  bool get hasSuggestion {
    total.forEach((type, result) {
      if (result.length > 0) {
        return true;
      }
    });
    return false;
  }

  // @ Helper: Finds Instances of Search Query in List
  int _findInstances(String category, List<TransferCard> list) {
    list.forEach((card) {
      switch (category) {
        case "Payload":
          return card.payload.toString().allMatches(query).length;
          break;
        case "Platform":
          return card.platform.toString().allMatches(query).length;
          break;
        case "FirstName":
          return card.firstName.toString().allMatches(query).length;
          break;
        case "LastName":
          return card.lastName.toString().allMatches(query).length;
          break;
        case "UserName":
          return card.username.toString().allMatches(query).length;
          break;
      }
    });
    return 0;
  }
}

// ************************************** //
// ** Class For Username Query Results ** //
// ************************************** //
class QueryUsernameResult {
  // Properties
  final String query;
  final Contact_SocialTile_Provider provider;
  final bool isPrivate;

  // Setter References
  MediumModel _medium;
  TwitterUserModel _twitter;
  YoutubeModel _youtube;

  // ** Constructer ** //
  QueryUsernameResult(this.query, this.provider, this.isPrivate, dynamic data) {
    switch (provider) {
      // case Contact_SocialTile_Provider.Facebook:
      //   break;
      // case Contact_SocialTile_Provider.Github:
      //   break;
      // case Contact_SocialTile_Provider.Instagram:
      //   break;
      case Contact_SocialTile_Provider.Medium:
        _medium = data;
        break;
      // case Contact_SocialTile_Provider.Snapchat:
      //   break;
      // case Contact_SocialTile_Provider.TikTok:
      //   break;
      case Contact_SocialTile_Provider.Twitter:
        _twitter = data;
        break;
      case Contact_SocialTile_Provider.YouTube:
        _youtube = data;
        break;
    }
  }
  // ^ GETTER: Returns Result of Provider - (Username, UserLink, Provider, IsPrivate)  ^ //
  dynamic get resultData {
    switch (provider) {
      // case Contact_SocialTile_Provider.Facebook:
      //   break;
      // case Contact_SocialTile_Provider.Github:
      //   break;
      // case Contact_SocialTile_Provider.Instagram:
      //   break;
      case Contact_SocialTile_Provider.Medium:
        return _medium;
        break;
      // case Contact_SocialTile_Provider.Snapchat:
      //   break;
      // case Contact_SocialTile_Provider.TikTok:
      //   break;
      case Contact_SocialTile_Provider.Twitter:
        return _twitter;
        break;
      case Contact_SocialTile_Provider.YouTube:
        return _youtube;
        break;
      default:
        break;
    }
    return null;
  }

  // ^ GETTER: Returns User - (Username, UserLink, Provider, IsPrivate) ^ //
  Quadruple<String, String, Contact_SocialTile_Provider, bool> get userData {
    switch (provider) {
      // case Contact_SocialTile_Provider.Facebook:
      //   break;
      // case Contact_SocialTile_Provider.Github:
      //   break;
      // case Contact_SocialTile_Provider.Instagram:
      //   break;
      case Contact_SocialTile_Provider.Medium:
        return Quadruple(query, "https://medium.com/@$query", provider, isPrivate);
        break;
      // case Contact_SocialTile_Provider.Snapchat:
      //   break;
      // case Contact_SocialTile_Provider.TikTok:
      //   break;
      case Contact_SocialTile_Provider.Twitter:
        return Quadruple(query, "https://twitter.com/$query", provider, isPrivate);
        break;
      case Contact_SocialTile_Provider.YouTube:
        return Quadruple(query, "", provider, isPrivate);
        break;
      default:
        break;
    }
    return null;
  }

  // ^ GETTER: Returns If Data is Valid ^ //
  bool get isValid {
    switch (provider) {
      // case Contact_SocialTile_Provider.Facebook:
      //   break;
      // case Contact_SocialTile_Provider.Github:
      //   break;
      // case Contact_SocialTile_Provider.Instagram:
      //   break;
      case Contact_SocialTile_Provider.Medium:
        return _medium.status == "ok";
        break;
      // case Contact_SocialTile_Provider.Snapchat:
      //   break;
      // case Contact_SocialTile_Provider.TikTok:
      //   break;
      case Contact_SocialTile_Provider.Twitter:
        return _twitter.errors == null;
        break;
      case Contact_SocialTile_Provider.YouTube:
        return _youtube.items.isNotEmpty;
        break;
      default:
        break;
    }
    return null;
  }
}
