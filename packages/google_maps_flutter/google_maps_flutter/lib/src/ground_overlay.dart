/// Ground Overlay
/// Flutter side of the google_maps_flutter plugin for ground overlays.
/// Event thought only one ground overlay per map shown at a time, have followed the circles pattern throughout
/// which passes a list/set of circle objects. This is bt design because multiple ground overlays may be required
/// event though only one per map at a time. For example a ground overlay for a may in dark and light modes may be
/// a different image.

part of google_maps_flutter;

/// Converts a LatLngBounds type in Dart to a dynamic List of two items; one for the LatLng of the southWest bound
/// the other for the northEast bound. Then for each bound that is a LatLng type in Dart, convert to a list of two
/// items; one for the latitude and th other for longitude.
dynamic _latLngBoundsToJson(LatLngBounds latLngBounds) {
  if (latLngBounds == null) {
    return null;
  }
//  print("***** ground_overly.dart: LatLngBounds conversion of northeast: ${latLngBounds.northeast}, southwest: "
//      "${latLngBounds.northeast}");
  /// Note Android requirement is that southwest Latlong should be first + northwest should be 2nd parameter.
  return <dynamic>[
    [latLngBounds.southwest.latitude, latLngBounds.southwest.longitude],
    [latLngBounds.northeast.latitude, latLngBounds.northeast.longitude]
  ];
}

/// Converts a Position type in Dart to a dynamic List of two or three items; one for the LatLng of the location
/// the other(s) for the width and optionally height if it is present
dynamic _positionToJson(Position position) {
  if (position == null) {
    return null;
  }
//  print("***** ground_overly.dart: LatLngBounds conversion of northeast: ${latLngBounds.northeast}, southwest: "
//      "${latLngBounds.northeast}");
  /// Construct the Json as follows ...
  return (position.height == null)
    ? <dynamic>[[position.location.latitude, position.location.longitude], position.width]
    : <dynamic>[[position.location.latitude, position.location.longitude], position.width, position.height];
}

/// The position of the anchor for the ground overlay, the point which anchors the ground overlay image.
///
/// Comprises of a LatLng, a width in meters and an optional height
///
class Position {
  /// Creates a immutable representation of the [GoogleMap] camera.
  ///
  /// [AssertionError] is thrown if [location], or [width] are null.
  const Position({
    @required this.location,
    @required this.width,
    this.height,
  })  : assert(location != null),
        assert(width != null);

  /// Specifies the position for this ground overlay using an anchor point (a LatLng).
  /// The location on the map LatLng to which the anchor point in the given image will remain fixed. The anchor will
  /// remain fixed to the position on the ground when transformations are applied to the ground overlay.
  final LatLng location;

  /// The width of the overlay (in meters). The height will be determined automatically based on the image aspect
  /// ratio if it is not provided.
  final double width;

  /// The height of the overlay (in meters). When rendered, the ground overlay image will be scaled to fit the
  /// dimensions specified by width and height.
  final double height;

  /// Serializes [Position].
  ///
  dynamic toMap() => <String, dynamic>{
    'location': location._toJson(),
    'width': width,
    'height': height,
  };

  /// Deserializes [Position] from a map.
  ///
  static Position fromMap(dynamic json) {
    if (json == null) {
      return null;
    }
    return Position(
      location: LatLng._fromJson(json['location']),
      width: json['width'],
      height: json['height'],
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Position typedOther = other;
    return location == typedOther.location &&
        width == typedOther.width &&
        height == typedOther.height;
  }

  @override
  int get hashCode => hashValues(location, width, height);

  @override
  String toString() =>
      'Position(location: $location, width: $width, height: $height)';
}

/// Uniquely identifies a [GroundOverlay] among [GoogleMap] ground overlays, but there should only ever be one.
///
/// This does not have to be globally unique, only unique among the list.
@immutable
class GroundOverlayId {

  /// Creates an immutable identifier for a [GroundOverlay] and stores in in the single property of value
  /// Using .hashCode method, see https://api.dart.dev/stable/2.7.1/dart-core/Object/hashCode.html
  /// Uses the .value of the instance and calls .hashCode on it
  GroundOverlayId(this.value) : assert(value != null);

  /// value of the [GroundOverlayId].
  final String value;

  /// Overrides == operator to allow comparing two GroundOverlayId object to see if they are the same, if so return true
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GroundOverlayId typedOther = other;
    return value == typedOther.value;
  }

  /// Overrides getter for .hashCode to use the value property of this object, rather than the object's hashCode
  @override
  int get hashCode => value.hashCode;

  /// Overrides .toString method to return a String using name as well as unique id e.g.'GroundOverlayId{value: 12345}'
  @override
  String toString() {
    return 'GroundOverlayId{value: $value}';
  }
}

/// Draws a ground overlay on the map.
@immutable
class GroundOverlay {

  /// Creates an immutable representation of a [GroundOverlay] to draw on [GoogleMap].
  const GroundOverlay({
    @required this.groundOverlayId,
    this.positionFromBounds,
    this.position,
    this.image,
    this.bearing = 0,
    this.visible = true,
    this.transparency = 0.0,
    this.zIndex = 0,
  });

  /// Uniquely identifies a [GroundOverlay].
  final GroundOverlayId groundOverlayId;

  /// True if the [GroundOverlay] consumes tap events.
  ///
  /// If this is false, [onTap] callback will not be triggered.
  //final bool consumeTapEvents;   // consume tap events not yet implemented

  /// Positioning of the [GroundOverlay] using bounds - positionFromBounds(LatLngBounds bounds)
  final LatLngBounds positionFromBounds;

  /// Positioning of the [GroundOverlay] using center location - position(LatLng location, float width)
  /// Composed of a LatLng to which the anchor will be fixed and the width of the overlay (in meters). The anchor is,
  /// by default, 50% from the top of the image and 50% from the left of the image, so centered.
  final Position position;

  /// The [GroundOverlay] image
  final BitmapDescriptor image;

  /// The [GroundOverlay] bearing
  final double bearing;

  /// True if the [GroundOverlay] is visible.
  final bool visible;

  /// The transparency of the image
  final double transparency;

  /// The z-index of the circle, used to determine relative drawing order of
  /// map overlays.
  ///
  /// Overlays are drawn in order of z-index, so that lower values means drawn
  /// earlier, and thus appearing to be closer to the surface of the Earth.
  final int zIndex;

//  /// Callbacks to receive tap events for circle placed on this map.
//  final VoidCallback onTap;   // consume tap events not yet implemented

  /// Creates a new [GroundOverlay] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  GroundOverlay copyWith({
    //bool consumeTapEventsParam,
    LatLng positionFromBoundsParam,
    Position positionParam,
    BitmapDescriptor imageParam,
    double bearingParam,
    bool visibleParam,
    double transparencyParam,
    int zIndexParam,
    //VoidCallback onTapParam,
  }) {
    /// Creating new [GroundOverlay] object includes a groundOverlayId
    /// if no new param, then use existing value
    return GroundOverlay(
      groundOverlayId: groundOverlayId,
      positionFromBounds: positionFromBoundsParam ?? positionFromBounds,
      position: positionParam ?? position,
      image: imageParam ?? image,
      bearing: bearingParam ?? bearing,
      visible: visibleParam ?? visible,
      transparency: transparencyParam ?? transparency,
      zIndex: zIndexParam ?? zIndex,
    );
  }

  /// Creates a new [GroundOverlay] object whose values are the same as this instance.
  GroundOverlay clone() => copyWith();

  /// Method to convert the [GroundOverlay] object to JSON of keys as Strings and values as dynamic
  dynamic _toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('groundOverlayId', groundOverlayId.value);
    addIfPresent('positionFromBounds', _latLngBoundsToJson(positionFromBounds));
    addIfPresent('position', _positionToJson(position));
    addIfPresent('image', image?._toJson());
    addIfPresent('bearing', bearing);
    addIfPresent('visible', visible);
    addIfPresent('transparency', transparency);
    addIfPresent('zIndex', zIndex);

    return json;
  }

  /// Override equality operator to check if all properties match
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GroundOverlay typedOther = other;
    return groundOverlayId == typedOther.groundOverlayId &&
        positionFromBounds == typedOther.positionFromBounds &&
        position == typedOther.position &&
        image == typedOther.image &&
        bearing == typedOther.bearing &&
        visible == typedOther.visible &&
        transparency == typedOther.transparency &&
        zIndex == typedOther.zIndex;
  }

  @override
  int get hashCode => groundOverlayId.hashCode;

}

/// Take multiple ground overlays and create Map made up of the id: groundOverlay
Map<GroundOverlayId, GroundOverlay> _keyByGroundOverlayId(Iterable<GroundOverlay> groundOverlays) {

  print("***** ground_overly.dart: Inside _keyByGroundOverlayId !!!");

  if (groundOverlays == null) {
    return <GroundOverlayId, GroundOverlay>{};
  }
  return Map<GroundOverlayId, GroundOverlay>.fromEntries(groundOverlays.map((GroundOverlay groundOverlay) =>
      MapEntry<GroundOverlayId, GroundOverlay>(groundOverlay.groundOverlayId, groundOverlay.clone())));
}

/// Take set of multiple ground overlays and create List of ground overlays converted to JSON
List<Map<String, dynamic>> _serializeGroundOverlaySet(Set<GroundOverlay> groundOverlays) {

  print("***** ground_overly.dart: Inside _serializeGroundOverlaySet !!!");

  if (groundOverlays == null) {
    return null;
  }
  return groundOverlays.map<Map<String, dynamic>>((GroundOverlay p) => p._toJson()).toList();
}
