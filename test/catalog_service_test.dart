import 'dart:convert';
import 'package:cat_go/app/data/services/catalog_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('CatalogService Tests', () {
    test(
      '1. fetchCatalog berhasil membaca format index.json katalog',
      () async {
        final mockClient = MockClient((request) async {
          if (request.url.path.endsWith('index.json')) {
            final body = json.encode({
              'paket': [
                {
                  'packId': 'tbs-2026',
                  'nama': 'TBS 2026',
                  'packVersion': 1,
                  'url': 'https://example.com/tbs.json',
                  'ukuranKb': 45,
                },
              ],
            });
            return http.Response(body, 200);
          }
          return http.Response('Not Found', 404);
        });

        final service = CatalogService(client: mockClient);
        final items = await service.fetchCatalog();

        expect(items.length, equals(1));
        expect(items.first.packId, equals('tbs-2026'));
        expect(items.first.nama, equals('TBS 2026'));
        expect(items.first.packVersion, equals(1));
        expect(items.first.ukuranKb, equals(45));
      },
    );

    test(
      '2. fetchCatalog melempar CatalogException jika status bukan 200 atau format salah',
      () async {
        final mockClient = MockClient((request) async {
          return http.Response('Internal Server Error', 500);
        });

        final service = CatalogService(client: mockClient);
        expect(
          () => service.fetchCatalog(),
          throwsA(
            isA<CatalogException>().having(
              (e) => e.message,
              'message',
              contains('Server merespons kode: 500'),
            ),
          ),
        );
      },
    );

    test('3. downloadPackJson berhasil mengunduh string JSON', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"sample": "data"}', 200);
      });

      final service = CatalogService(client: mockClient);
      final content = await service.downloadPackJson(
        'https://example.com/pack.json',
      );
      expect(content, equals('{"sample": "data"}'));
    });

    test(
      '4. downloadPackJson menolak file yang melebihi batas ukuran maksimal',
      () async {
        final mockClient = MockClient((request) async {
          // Respons dengan byte dummy melebihi batas 100 bytes (untuk pengujian batas)
          final largeData = List.filled(200, 65);
          return http.Response.bytes(largeData, 200);
        });

        final service = CatalogService(client: mockClient);
        expect(
          () => service.downloadPackJson(
            'https://example.com/large.json',
            maxSizeBytes: 100,
          ),
          throwsA(
            isA<CatalogException>().having(
              (e) => e.message,
              'message',
              contains('melebihi batas maksimal'),
            ),
          ),
        );
      },
    );
  });
}
