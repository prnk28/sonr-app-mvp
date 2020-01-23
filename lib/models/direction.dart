class Direction {
  //  Variables
  final double degrees;
  final double antipodalDegrees;
  final String compassDesignation;

  // Constructor
  Direction(this.degrees, this.compassDesignation, this.antipodalDegrees);

  // JSON Generation
  toJSON() {
    return {
      'antipodal_degrees': antipodalDegrees.toString(),
      'compass_designation': compassDesignation,
      'degrees': degrees.toString()
    };
  }
}
