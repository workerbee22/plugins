/// GroundOverlay
/// Contains all of the implemented methods for the Ground Overlay object. Note not all methods may be implemented.
/// Based on CircleController.java and CircleOptionsSink.java

package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.model.GroundOverlay;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.BitmapDescriptor;

/** Controller of a single GroundOverlay on the map. */
class GroundOverlayController implements GroundOverlayOptionsSink {
  private final GroundOverlay groundOverlay;
  private final String googleMapsGroundOverlayId;

  GroundOverlayController(GroundOverlay groundOverlay) {
    this.groundOverlay = groundOverlay;
    this.googleMapsGroundOverlayId = groundOverlay.getId();
  }

  void remove() {
    groundOverlay.remove();
  }

  @Override
  public void setBearing(float bearing) {
    groundOverlay.setBearing(bearing);
  }

  @Override
  public void setImage(BitmapDescriptor image) {
    groundOverlay.setImage(image);
  }

  /// setPosition has two versions; one with LatLng location and width, the other with width and height
  @Override
  public void setPosition(LatLng location, float width)  {
    groundOverlay.setPosition(location);
    groundOverlay.setDimensions(width);
  }

  @Override
  public void setPosition(LatLng location, float width, float height)  {
    groundOverlay.setPosition(location);
    groundOverlay.setDimensions(width);
    groundOverlay.setDimensions(height);
  }

  @Override
  public void setPositionFromBounds(LatLngBounds bounds) {
    groundOverlay.setPositionFromBounds(bounds);
  }

  @Override
  public void setVisible(boolean visible) {
    groundOverlay.setVisible(visible);
  }

  @Override
  public void setTransparency(float transparency) {
    groundOverlay.setTransparency(transparency);
  }

  @Override
  public void setZIndex(float zIndex) {
    groundOverlay.setZIndex(zIndex);
  }

  String getGoogleMapsGroundOverlayId() {
    return googleMapsGroundOverlayId;
  }

}
