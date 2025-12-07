class Shelter {
  final String name;
  final double lat;
  final double lng;

  const Shelter({
    required this.name,
    required this.lat,
    required this.lng,
  });
}

const List<Shelter> shelters = [
  Shelter(
    name: '건대입구역 대피소',
    lat: 37.540786,
    lng: 127.074658,
  ),
  Shelter(
    name: '군자역 대피소',
    lat: 37.5572,
    lng: 127.0795,
  ),
];

// class Shelter {
//   final String name;
//   final double lat;
//   final double lng;
//
//   const Shelter({
//     required this.name,
//     required this.lat,
//     required this.lng,
//   });
// }
//
// const List<Shelter> shelters = [
//   Shelter(
//     name: '강남역',
//     lat: 37.498095,
//     lng: 127.027610,
//   ),
//   Shelter(
//     name: '서초역',
//     lat: 37.4918461,
//     lng: 127.0077042,
//   ),
// ];