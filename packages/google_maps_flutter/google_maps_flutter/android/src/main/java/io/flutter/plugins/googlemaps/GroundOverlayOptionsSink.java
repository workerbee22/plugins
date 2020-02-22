// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.BitmapDescriptor;

/** Receiver of GroundOverlay configuration options. */
interface GroundOverlayOptionsSink {

  void setBearing(float bearing);

  void setImage(BitmapDescriptor image);

  void setPositionFromBounds(LatLngBounds bounds);

  void setPosition(LatLng location, float width);

  void setPosition(LatLng location, float width, float height);

  void setVisible(boolean visible);

  void setTransparency(float transparency);

  void setZIndex(float zIndex);
}
