import 'dart:typed_data';
import 'package:sonr_app/service/client/sonr.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

/// @ Contact Protobuf
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

  /// Add Phone for Rx<Contact>
  void addPhone(String data, {String label = ContactUtils.K_DEFAULT_PHONE_LABEL}) => this.update((val) {
        if (val != null) {
          val.addPhone(data, label: label);
        }
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
        if (val != null) {
          val.setFirstName(data);
        }
      });

  /// Set LastName for Rx<Contact>
  void setLastName(String data) => this.update((val) {
        if (val != null) {
          val.setLastName(data);
        }
      });

  /// Set Picture for Rx<Contact>
  void setPicture(Uint8List data) => this.update((val) {
        if (val != null) {
          val.setPicture(data);
        }
      });

  /// Delete a Social Media Provider
  void updateSocial(Contact_Social data) => this.update((val) {
        if (val != null) {
          val.updateSocial(data);
        }
      });
}

/// @ InviteRequest Protobuf
/// Extension Manages InviteRequest Protobuf as Rx Type
extension RxInviteRequest on Rx<InviteRequest> {
  /// Checks if InviteRequest Payload is Media
  bool get isMedia => this.value.payload == Payload.MEDIA;

  /// Checks if InviteRequest Payload is Contact
  bool get isContact => this.value.payload == Payload.CONTACT;

  /// Checks if InviteRequest Payload is Url
  bool get isURL => this.value.payload == Payload.URL;

  /// Checks if InviteRequest is Transfer
  bool get isTransfer => this.value.payload == Payload.MEDIA || this.value.payload == Payload.FILE || this.value.payload == Payload.FILES;

  /// `Init()` sets Invite Request Parameters with TransferArguments
  void init(Payload payload, {String? url, Contact? contact, SonrFile? file}) {
    switch (payload) {
      case Payload.CONTACT:
        if (contact != null) {
          addContact(contact);
        }
        break;
      case Payload.URL:
        if (url != null) {
          addUrl(url);
        }
        break;
      default:
        if (file != null) {
          addFile(file);
        }
    }
  }

  /// Method Adds Contact for InviteRequest
  void addContact(Contact data) {
    this.update((val) {
      if (val != null) {
        val.setContact(data);
      }
    });
  }

  /// Method Adds SonrFile for InviteRequest
  void addFile(SonrFile data) {
    this.update((val) {
      if (val != null) {
        val.setFile(data);
      }
    });
  }

  /// Method Adds URL String for InviteRequest
  void addUrl(String data) {
    this.update((val) {
      if (val != null) {
        val.setUrl(data);
      }
    });
  }

  /// Method Sets Peer for InviteRequest
  void setPeer(Peer peer) {
    this.update((val) {
      if (val != null) {
        val.setPeer(peer);
      }
    });
  }
}
