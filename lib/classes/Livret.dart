class Livret {
  final String name;
  final double? interet;
  final double? plafond;
  final bool decouvert;

  Livret(
      {required this.name,
      required this.interet,
      required this.plafond,
      required this.decouvert});

  static Livret compteCourant() {
    return Livret(
        name: 'Compte Courant', interet: 0, plafond: null, decouvert: true);
  }

  static Livret livretA() {
    return Livret(
        name: 'Livret A', interet: 0.0050, plafond: 22950, decouvert: false);
  }

  static Livret livretJeune() {
    return Livret(
        name: 'Livret Jeune', interet: 0.005, plafond: 1600, decouvert: false);
  }

  static Livret lep() {
    return Livret(name: 'LEP', interet: 0.01, plafond: 7700, decouvert: false);
  }

  static Livret ldds() {
    return Livret(
        name: 'LDDS', interet: 0.005, plafond: 12000, decouvert: false);
  }

  static Livret cel() {
    return Livret(
        name: 'CEL', interet: 0.0025, plafond: 15300, decouvert: false);
  }

  static Livret pel() {
    return Livret(name: 'PEL', interet: 0.01, plafond: 61200, decouvert: false);
  }
}
