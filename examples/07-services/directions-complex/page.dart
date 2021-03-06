#import('dart:html');
#import('../../../gmaps.dart', prefix:'gmaps');

gmaps.GMap map;
gmaps.DirectionsRenderer directionsDisplay;
gmaps.DirectionsService directionsService;
gmaps.InfoWindow stepDisplay;
List<gmaps.Marker> markerArray;

void main() {
  markerArray = [];

  // Instantiate a directions service.
  directionsService = new gmaps.DirectionsService();

  // Create a map and center it on Manhattan.
  final manhattan = new gmaps.LatLng(40.7711329, -73.9741874);
  final mapOptions = new gmaps.MapOptions()
    ..zoom = 13
    ..mapTypeId = gmaps.MapTypeId.ROADMAP
    ..center = manhattan
    ;
  map = new gmaps.GMap(query("#map_canvas"), mapOptions);

  // Create a renderer for directions and bind it to the map.
  final rendererOptions = new gmaps.DirectionsRendererOptions()
    ..map = map
    ;
  directionsDisplay = new gmaps.DirectionsRenderer(rendererOptions);

  // Instantiate an info window to hold step text.
  stepDisplay = new gmaps.InfoWindow();

  query('#start').on.change.add((e) => calcRoute());
  query('#end').on.change.add((e) => calcRoute());
}

void calcRoute() {

  // First, remove any existing markers from the map.
  markerArray.forEach((marker) => marker.setMap(null));

  // Now, clear the array itself.
  markerArray.clear();

  // Retrieve the start and end locations and create
  // a DirectionsRequest using WALKING directions.
  final start = (query('#start') as SelectElement).value;
  final end = (query('#end') as SelectElement).value;
  final request = new gmaps.DirectionsRequest()
    ..origin = start
    ..destination = end
    ..travelMode = gmaps.TravelMode.WALKING // TODO bad object in example DirectionsTravelMode
    ;

  // Route the directions and pass the response to a
  // function to create markers for each step.
  directionsService.route(request, (gmaps.DirectionsResult response, gmaps.DirectionsStatus status) {
    if (status == gmaps.DirectionsStatus.OK) {
      final warnings = query('#warnings_panel');
      warnings.innerHTML = '<b>${response.routes[0].warnings}</b>';
      directionsDisplay.setDirections(response);
      showSteps(response);
    }
  });
}

void showSteps(gmaps.DirectionsResult directionResult) {
  // For each step, place a marker, and add the text to the marker's
  // info window. Also attach the marker to an array so we
  // can keep track of it and remove it when calculating new
  // routes.
  final myRoute = directionResult.routes[0].legs[0];

  for(final step in myRoute.steps) {
    final marker = new gmaps.Marker(new gmaps.MarkerOptions()
      ..position = step.start_location // TODO bad attribut in example "start_point"
      ..map = map
    );
    attachInstructionText(marker, step.instructions);
    markerArray.add(marker);
  }
}

void attachInstructionText(gmaps.Marker marker, String text) {
  gmaps.Events.addListener(marker, 'click', (e) {
    // Open an info window when the marker is clicked on,
    // containing the text of the step.
    stepDisplay.setContent(text);
    stepDisplay.open(map, marker);
  });
}