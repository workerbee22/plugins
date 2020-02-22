// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.GroundOverlayOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;

class GroundOverlayBuilder implements GroundOverlayOptionsSink {
  private final GroundOverlayOptions groundOverlayOptions;

  GroundOverlayBuilder() {
    this.groundOverlayOptions = new GroundOverlayOptions();
  }

  GroundOverlayOptions build() {
    return groundOverlayOptions;
  }

  @Override
  public void setImage(BitmapDescriptor image) {
    groundOverlayOptions.image(image);
  }

  @Override
  public void setBearing(float bearing) {
    groundOverlayOptions.bearing(bearing);
  }

  @Override
  public void setPositionFromBounds(LatLngBounds bounds)  { groundOverlayOptions.positionFromBounds(bounds); }

  /// setPosition has two versions; one with LatLng location and width, the other with width and height
  @Override
  public void setPosition(LatLng location, float width)  {
    groundOverlayOptions.position(location, width);
  }

  @Override
  public void setPosition(LatLng location, float width, float height)  {
    groundOverlayOptions.position(location, width, height);
  }

  @Override
  public void setVisible(boolean visible) {
    groundOverlayOptions.visible(visible);
  }

  @Override
  public void setTransparency(float transparency) {
    groundOverlayOptions.transparency(transparency);
  }

  @Override
  public void setZIndex(float zIndex) {
    groundOverlayOptions.zIndex(zIndex);
  }
}
