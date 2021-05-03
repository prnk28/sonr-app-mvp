import 'dart:convert';

class GeoIP {
  String ip;
  String type;
  String continentCode;
  String continentName;
  String countryCode;
  String countryName;
  String regionCode;
  String regionName;
  String city;
  String zip;
  double latitude;
  double longitude;
  IPLocation location;

  GeoIP(
      {this.ip,
      this.type,
      this.continentCode,
      this.continentName,
      this.countryCode,
      this.countryName,
      this.regionCode,
      this.regionName,
      this.city,
      this.zip,
      this.latitude,
      this.longitude,
      this.location});

  GeoIP.fromResponse(dynamic respBody) {
    Map<String, dynamic> json = jsonDecode(respBody);
    ip = json['ip'];
    type = json['type'];
    continentCode = json['continent_code'];
    continentName = json['continent_name'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    regionCode = json['region_code'];
    regionName = json['region_name'];
    city = json['city'];
    zip = json['zip'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    location = json['location'] != null ? IPLocation.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ip'] = this.ip;
    data['type'] = this.type;
    data['continent_code'] = this.continentCode;
    data['continent_name'] = this.continentName;
    data['country_code'] = this.countryCode;
    data['country_name'] = this.countryName;
    data['region_code'] = this.regionCode;
    data['region_name'] = this.regionName;
    data['city'] = this.city;
    data['zip'] = this.zip;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    return data;
  }
}

class IPLocation {
  int geonameId;
  String capital;
  List<IPLanguages> languages;
  String countryFlag;
  String countryFlagEmoji;
  String countryFlagEmojiUnicode;
  String callingCode;
  bool isEu;

  IPLocation(
      {this.geonameId,
      this.capital,
      this.languages,
      this.countryFlag,
      this.countryFlagEmoji,
      this.countryFlagEmojiUnicode,
      this.callingCode,
      this.isEu});

  IPLocation.fromJson(Map<String, dynamic> json) {
    geonameId = json['geoname_id'];
    capital = json['capital'];
    if (json['languages'] != null) {
      languages = <IPLanguages>[];
      json['languages'].forEach((v) {
        languages.add(IPLanguages.fromJson(v));
      });
    }
    countryFlag = json['country_flag'];
    countryFlagEmoji = json['country_flag_emoji'];
    countryFlagEmojiUnicode = json['country_flag_emoji_unicode'];
    callingCode = json['calling_code'];
    isEu = json['is_eu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['geoname_id'] = this.geonameId;
    data['capital'] = this.capital;
    if (this.languages != null) {
      data['languages'] = this.languages.map((v) => v.toJson()).toList();
    }
    data['country_flag'] = this.countryFlag;
    data['country_flag_emoji'] = this.countryFlagEmoji;
    data['country_flag_emoji_unicode'] = this.countryFlagEmojiUnicode;
    data['calling_code'] = this.callingCode;
    data['is_eu'] = this.isEu;
    return data;
  }
}

class IPLanguages {
  String code;
  String name;
  String native;

  IPLanguages({this.code, this.name, this.native});

  IPLanguages.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    native = json['native'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['native'] = this.native;
    return data;
  }
}
