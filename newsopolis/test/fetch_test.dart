import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:newsopolis/ui/pages/authentication/login/login_logic_testing/main_example.dart';

import 'fetch_test.mocks.dart';

// Se genera un cliente mock (MockClient) usando el paquete Mockito.
// Y se crea una nueva instancia de esta clase para cada prueba.
@GenerateMocks([http.Client])
void main() {
  group('fetchAlbum', () {
    test('Devuelve una conexion exitosa si la llamada http se completa exitosamente', () async {
      final client = MockClient();

      // utilizacion de Mockito para retornar una respuesta exitosa cuando 
      // se llama al http.Client.
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async =>
              http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

      expect(await fetchConnection(client), isA<Connection>());
    });

    test('Arroja una excepcion si la llamada http se completa con un error', () {
      final client = MockClient();

      // utilizacion de Mockito para retornar una respuesta erronea cuando 
      // se llama al http.Client.
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchConnection(client), throwsException);
    });
  });
}