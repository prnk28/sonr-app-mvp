enum LobbyFilter { All, Phones, Desktops }

extension LobbyFilterUtils on LobbyFilter {
  static LobbyFilter fromEnabled(bool phones, bool desktops) {
    if (phones && !desktops) {
      return LobbyFilter.Phones;
    } else if (desktops && !phones) {
      return LobbyFilter.Desktops;
    } else {
      return LobbyFilter.All;
    }
  }
}
