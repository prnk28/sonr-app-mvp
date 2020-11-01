<div align="center">
    <img src="assets/logos/header.png" alt="Sonr-App-Header"/>
  <br>
</div>

# Description
> Share anything to everyone and everything.

App utilizes Libp2p, WebRTC, OLC to be able to send any file to a nearby person. Also has robust contact sharing feature.

## Who is this for?
Anyone with multiple devices not running in the same ecosystem.

# Discovery
Peer Discovery Protocols in Sonr
## Ultrasonic
- https://www.electronicdesign.com/industrial-automation/article/21808186/sending-data-over-sound-how-and-why
- https://cueaudio.com/documents/16/cue-technical-overview.pdf
-  https://cueaudio.com/data-over-sound/
- https://stackoverflow.com/questions/20153280/android-transmit-a-signal-using-ultrasound


### Strategy
- Add slide to Send Feature to increase volume
- Flutter Audio as Stream: https://pub.dev/packages/sound_stream
- Implement Audio Filter: https://stackoverflow.com/questions/28291582/implementing-a-high-pass-filter-to-an-audio-signal
- Audio Watermark: http://mattmontag.com/audio-listening-test/
- Utilize library for encoding: https://pub.dev/packages/flutter_ffmpeg

Offline P2P File Sharing:
- Send Files as chunk with sound, warn user slow transfer speeds
- Implement Dual Diagonal Infusion

Market as: Rudimentary form of Human Communication

## BLE
*TODO*
## MDNS
*TODO*

# Sonr BLoC
### Events

|     Event    |                Trigger {Parameters}               |
|:------------:|:-------------------------------------------------:|
| Initialize   | Page Load `{Client, Lobby}`                        |
| ShiftMotion  | On Motion BLoC Subscription `{Motion}`           |
| Authenticate | On Button Tap `{Client, Process, Match}`         |
| Send         | Motion Change `{Client, Lobby, Direction}`          |
| Receive      | Motion Change `{Client, Lobby, Direction}`          |
| Match *(Sender Only)*       | Point for 2s  `{Client, Match, Lobby}` |
| Select *(Sender Only)*      | Tap Peer  `{Client, Match, Lobby}`     |
| Offered  *(Receiver Only)*      | Receiver Chosen `{Client, Match, Process}`       |
| Transfer     | Auth Success `{Client, Match, File}`                |
| Done         | Transfer Complete `{Match, File}`                   |
| Cancel       | Button Tap `{Client, Error}`                     |
| Reset        | On Cancel, On Done, On Zero `{Client, Lobby}`       |

## States

| State                  | Description                         | Model(s)                    |
|------------------------|-------------------------------------|-----------------------------|
| Initial **[0]**        | Preloading State                    | -                           |
| Ready **[1]**          | Connected to WS, In a Lobby         | `Client, Lobby`             |
| Sending **[2]**        | Motion Position                     | `Client, Lobby, Direction`  |
| Receiving **[3]**      | Motion Position                     | `Client, Lobby, Direction`  |
| Found **[4]**          | Match Found                         | `Client, Match`             |
| Authenticating **[5]** | Pending Transfer Confirmation       | `Client, Match, Process` |
| Transferring **[6]**   | WebRTC Transfer or Contact Transfer | `Client, Match, Process` |
| Complete **[7]**       | Transfer Succesful                  | `Client, Match, File`       |
| Failed **[8]**         | Canceled/ Declined/ Server Error    | `FailType`                  |

## Transitions

| Current State          	| Event          	| Next State             	|
|------------------------	|----------------	|------------------------	|
| Initial **[0]**        	| `Initialize`   	| Ready **[1]**          	|
| Ready **[1]**          	| `ShiftMotion`  	| Sending **[2]**        	|
| Ready **[1]**          	| `ShiftMotion`  	| Receiving **[3]**      	|
| Sending **[2]**        	| `ShiftMotion`  	| Ready **[1]**          	|
| Receiving **[3]**      	| `ShiftMotion`  	| Ready **[1]**          	|
| Sending **[2]**        	| `Send`         	| Sending **[2]**        	|
| Sending **[2]**        	| `Match`        	| Found **[4]**          	|
| Sending **[2]**        	| `Select`       	| Found **[4]**          	|
| Receiving **[3]**      	| `Receive`      	| Receiving **[3]**      	|
| Receiving **[3]**      	| `Offer`        	| Found **[4]**          	|
| Found **[4]**          	| `Authenticate` 	| Authenticating **[5]** 	|
| Found **[4]**          	| `Cancel`       	| Failed **[8]**         	|
| Authenticating **[5]** 	| `Transfer`     	| Transferring **[6]**   	|
| Authenticating **[5]** 	| `Cancel`       	| Failed **[8]**         	|
| Transferring **[6]**   	| `Done`         	| Complete **[7]**       	|
| Transferring **[6]**   	| `Cancel`       	| Failed **[8]**         	|
| Complete **[7]**       	| `Reset`        	| Ready **[1]**          	|
| Failed **[8]**         	| `Reset`        	| Ready **[1]**          	|


# Technologies
* [Flutter](https://github.com/flutter/flutter)
* [LibP2P](https://github.com/libp2p/go-libp2p)
* [OLC](https://github.com/google/open-location-code)
* [WebRTC](https://webrtc.org/)
* [LiquidCore](https://github.com/LiquidPlayer/LiquidCore)
* [GUN](https://gun.eco/)

# Contributors and Maintainers
- [Prad Nukala](https://prad.dev)
