#import('dart:html');
#import('../../../gmaps.dart', prefix:'gmaps');

const IMAGE_URL = "https://google-developers.appspot.com/maps/documentation/javascript/examples";

void main() {
  // Set up Street View and initially set it visible. Register the
  // custom panorama provider function. Set the StreetView to display
  // the custom panorama 'reception' which we check for below.
  final panoOptions = new gmaps.StreetViewPanoramaOptions()
    ..pano = 'reception'
    ..visible = true
    ..panoProvider = getCustomPanorama
    ;

  final panorama = new gmaps.StreetViewPanorama(query('#pano_canvas'), panoOptions);
}

// Return a pano image given the panoID.
String getCustomPanoramaTileUrl(String pano, num tileZoom, num tileX, num tileY) {
  // Note: robust custom panorama methods would require tiled pano data.
  // Here we're just using a single tile, set to the tile size and equal
  // to the pano "world" size.
  return '${IMAGE_URL}/images/panoReception1024-0.jpg';
}

// Construct the appropriate StreetViewPanoramaData given
// the passed pano IDs.
gmaps.StreetViewPanoramaData getCustomPanorama(String pano) { // TODO bad parameters
  if (pano == 'reception') {
    return new gmaps.StreetViewPanoramaData()
      ..location = (new gmaps.StreetViewLocation()
        ..pano = 'reception'
        ..description = 'Google Sydney - Reception'
      )
      ..links = []
      // The text for the copyright control.
      ..copyright = 'Imagery (c) 2010 Google'
      // The definition of the tiles for this panorama.
      ..tiles = (new gmaps.StreetViewTileData()
        ..tileSize = new gmaps.Size(1024, 512)
        ..worldSize = new gmaps.Size(1024, 512)
        // The heading in degrees at the origin of the panorama
        // tile set.
        ..centerHeading = 105
        ..["getTileUrl"] = (List args) => getCustomPanoramaTileUrl(args[0], args[1], args[2], args[3])
      )
      ;
  }
}
