#import('dart:html');
#import('../../../gmaps.dart', prefix:'gmaps');

void main() {
  final mapOptions = new gmaps.MapOptions()
    ..scaleControl = true
    ..center = new gmaps.LatLng(30.064742, 31.249509)
    ..zoom = 10
    ..mapTypeId = gmaps.MapTypeId.ROADMAP
    ;
  final map = new gmaps.GMap(query("#map_canvas"), mapOptions);

  final marker = new gmaps.Marker(new gmaps.MarkerOptions()
    ..map = map
    ..position = map.getCenter()
  );
  final infowindow = new gmaps.InfoWindow();
  infowindow.setContent('<b>القاهرة</b>');
  gmaps.Events.addListener(marker, 'click', (e) {
    infowindow.open(map, marker);
  });
}