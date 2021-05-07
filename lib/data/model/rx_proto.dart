import 'dart:typed_data';
import 'package:sonr_app/service/client/sonr.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

/// ^ Contact Protobuf ^ //
/// Extension Manages Contact Protobof as Rx Type
extension RxContact on Rx<Contact> {
  /// Add Address for Rx<Contact>
  void addAddress(
          {required String street,
          required String city,
          required String state,
          String streetTwo = "",
          String zipcode = "",
          String country = "",
          String countryCode = "",
          String label = ContactUtils.K_DEFAULT_LABEL}) =>
      this.update((val) {
        val?.addAddress(Contact_Address(
          label: label,
          street: street,
          state: state,
          streetTwo: streetTwo,
          zipcode: zipcode,
          country: country,
          countryCode: countryCode,
        ));
      });

  /// Add Date for Rx<Contact>
  void addDate(DateTime data, {String label = ContactUtils.K_DEFAULT_DATE_LABEL}) => this.update((val) {
        val?.addDate(data, label: label);
      });

  /// Add Email for Rx<Contact>
  void addEmail(String data) => this.update((val) {
        val?.addEmail(data);
      });

  /// Add Name for Rx<Contact>
  void addName(String data, String label) => this.update((val) {
        val?.addName(data, label);
      });

  /// Add Phone for Rx<Contact>
  void addPhone(String data, {String label = ContactUtils.K_DEFAULT_PHONE_LABEL}) => this.update((val) {
        val?.addPhone(data, label: label);
      });

  /// Add a Social Media Provider
  void addSocial(Contact_Social data) => this.update((val) {
        val?.addSocial(data);
      });

  /// Add Website for Rx<Contact>
  void addWebsite(String data, {String label = ContactUtils.K_DEFAULT_LABEL}) => this.update((val) async {
        // Get URL Link
        var link = await SonrService.getURL(data);

        // Set Website
        val?.addWebsite(link, label: label);
      });

  /// Delete a Social Media Provider
  void deleteSocial(Contact_Social data) => this.update((val) {
        val?.deleteSocial(data);
      });

  /// Set FirstName for Rx<Contact>
  void setFirstName(String data) => this.update((val) {
        val?.setFirstName(data);
      });

  /// Set LastName for Rx<Contact>
  void setLastName(String data) => this.update((val) {
        val?.setLastName(data);
      });

  /// Set Picture for Rx<Contact>
  void setPicture(Uint8List data) => this.update((val) {
        val?.setPicture(data);
      });

  /// Delete a Social Media Provider
  void updateSocial(Contact_Social data) => this.update((val) {
        val?.updateSocial(data);
      });
}

/// ^ InviteRequest Protobuf ^ //
/// Extension Manages InviteRequest Protobuf as Rx Type
extension RxInviteRequest on Rx<InviteRequest> {
  /// Checks if InviteRequest Payload is Media
  bool get isMedia => this.value.payload == Payload.MEDIA;

  /// `Init()` sets Invite Request Parameters with TransferArguments
  void init(TransferArguments args) {
    switch (args.payload) {
      case Payload.CONTACT:
        if (args.contact != null) {
          addContact(args.contact!);
        }
        break;
      case Payload.URL:
        if (args.url != null) {
          addUrl(args.url!);
        }
        break;
      default:
        if (args.file != null) {
          addFile(args.file!);
        }
    }
  }

  /// Method Adds Contact for InviteRequest
  void addContact(Contact data) {
    this.update((val) {
      if (val != null) {
        val.contact = data;
        val.payload = Payload.CONTACT;
      }
    });
  }

  /// Method Adds SonrFile for InviteRequest
  void addFile(SonrFile data) {
    this.update((val) {
      if (val != null) {
        val.file = data;
        val.payload = data.payload;
      }
    });
  }

  /// Method Adds URL String for InviteRequest
  void addUrl(String data) {
    this.update((val) {
      if (val != null) {
        val.url = data;
        val.payload = Payload.URL;
      }
    });
  }

  /// Method Sets Peer for InviteRequest
  void setPeer(Peer peer) {
    this.update((val) {
      if (val != null) {
        val.to = peer;
      }
    });
  }
}
