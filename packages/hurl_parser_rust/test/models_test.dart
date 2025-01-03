// test/models_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:hurl_parser_rust/src/models/capture.dart';
import 'package:hurl_parser_rust/src/models/header.dart';
import 'package:hurl_parser_rust/src/models/hurl_assert.dart';
import 'package:hurl_parser_rust/src/models/hurl_entry.dart';
import 'package:hurl_parser_rust/src/models/hurl_file.dart';
import 'package:hurl_parser_rust/src/models/hurl_request.dart';
import 'package:hurl_parser_rust/src/models/hurl_response.dart';
import 'package:hurl_parser_rust/src/models/predicate.dart';
import 'package:hurl_parser_rust/src/models/query.dart';
import 'package:hurl_parser_rust/src/models/request_body.dart';
import 'package:hurl_parser_rust/src/models/request_option.dart';
import 'package:hurl_parser_rust/src/rust/frb_generated.dart';
import 'package:hurl_parser_rust/src/rust/api/simple.dart';
import 'dart:convert';

void main() {
  setUpAll(() async {
    await RustLib.init();
  });

  group('Hurl Model Tests', () {
    test('Should match basic request with headers', () {
      final expected = HurlFile(entries: [
        HurlEntry(
          request: HurlRequest(
            method: 'GET',
            url: 'https://example.org/news',
            headers: [
              Header(name: 'User-Agent', value: 'Mozilla/5.0'),
              Header(name: 'Accept', value: '*/*'),
            ],
          ),
        ),
      ]);

      final jsonString = parseHurlToJson(content: '''
GET https://example.org/news
User-Agent: Mozilla/5.0
Accept: */*
''');

      print('JSON output:');
      print(JsonEncoder.withIndent('  ').convert(jsonDecode(jsonString)));

      final actual = HurlFile.fromJson(jsonDecode(jsonString));
      expect(actual, expected);
    });

    test('Should match request with body', () {
      final expected = HurlFile(entries: [
        HurlEntry(
          request: HurlRequest(
            method: 'POST',
            url: 'http://api.example.com/users',
            headers: [
              Header(name: 'Content-Type', value: 'application/json'),
            ],
            body: RequestBody(
              type: 'json',
              value: {
                'name': 'John Doe',
                'email': 'john@example.com',
              },
            ),
          ),
        ),
      ]);

      final jsonString = parseHurlToJson(content: '''
POST http://api.example.com/users
Content-Type: application/json
{
    "name": "John Doe",
    "email": "john@example.com"
}
''');

      print('JSON output:');
      print(JsonEncoder.withIndent('  ').convert(jsonDecode(jsonString)));

      final actual = HurlFile.fromJson(jsonDecode(jsonString));
      expect(actual, expected);
    });

    test('Should match request with options', () {
      final expected = HurlFile(entries: [
        HurlEntry(
          request: HurlRequest(
            method: 'GET',
            url: 'http://api.example.com/users',
            options: [
              RequestOption(name: 'insecure', value: true),
              RequestOption(name: 'retry', value: 3),
            ],
          ),
        ),
      ]);

      final jsonString = parseHurlToJson(content: '''
GET http://api.example.com/users
[Options]
insecure: true
retry: 3
''');

      print('JSON output:');
      print(JsonEncoder.withIndent('  ').convert(jsonDecode(jsonString)));

      final actual = HurlFile.fromJson(jsonDecode(jsonString));
      expect(actual, expected);
    });

    test('Should match response with captures and asserts', () {
      final expected = HurlFile(entries: [
        HurlEntry(
          request: HurlRequest(
            method: 'GET',
            url: 'http://api.example.com/users',
          ),
          response: HurlResponse(
            version: 'HTTP/1.1',
            status: 200,
            captures: [
              Capture(
                name: 'user_id',
                query: Query(
                  type: 'jsonpath',
                  expr: '\$.users[0].id',
                ),
              ),
            ],
            asserts: [
              HurlAssert(
                query: Query(
                  type: 'header',
                  name: 'Content-Type',
                ),
                predicate: Predicate(
                  type: 'equal',
                  value: 'application/json',
                ),
              ),
              HurlAssert(
                query: Query(
                  type: 'jsonpath',
                  expr: '\$.status',
                ),
                predicate: Predicate(
                  type: 'exist',
                ),
              ),
            ],
          ),
        ),
      ]);

      final jsonString = parseHurlToJson(content: '''
GET http://api.example.com/users
HTTP/1.1 200
[Captures]
user_id: jsonpath "\$.users[0].id"
[Asserts]
header "Content-Type" == "application/json"
jsonpath "\$.status" exists
''');

      print('JSON output:');
      print(JsonEncoder.withIndent('  ').convert(jsonDecode(jsonString)));

      final actual = HurlFile.fromJson(jsonDecode(jsonString));
      expect(actual, expected);
    });
  });

  test('Should parse complete request sequence', () {
    final expected = HurlFile(
      entries: [
        // First request - Get users
        HurlEntry(
          request: HurlRequest(
            method: 'GET',
            url: 'http://api.example.com/users',
            headers: [
              Header(name: 'Authorization', value: 'Bearer token123'),
              Header(name: 'Accept', value: 'application/json'),
            ],
            comments: [' First request - Get users'],
          ),
          response: HurlResponse(
            version: 'HTTP/1.1',
            status: 200,
            captures: [
              Capture(
                name: 'user_id',
                query: Query(
                  type: 'jsonpath',
                  expr: r'$.users[0].id',
                ),
              ),
            ],
            asserts: [
              HurlAssert(
                query: Query(
                  type: 'header',
                  name: 'Content-Type',
                ),
                predicate: Predicate(
                  type: 'equal',
                  value: 'application/json',
                ),
              ),
            ],
          ),
        ),

        // Second request - Create user
        HurlEntry(
          request: HurlRequest(
            method: 'POST',
            url: 'http://api.example.com/users',
            headers: [
              Header(name: 'Content-Type', value: 'application/json'),
            ],
            body: RequestBody(
              type: 'json',
              value: {
                'name': 'John Doe',
                'email': 'john@example.com',
              },
            ),
            comments: [' Second request - Create user'],
          ),
          response: HurlResponse(
            version: 'HTTP/1.1',
            status: 201,
            asserts: [
              HurlAssert(
                query: Query(
                  type: 'header',
                  name: 'Location',
                ),
                predicate: Predicate(
                  type: 'exist',
                ),
              ),
              HurlAssert(
                query: Query(
                  type: 'jsonpath',
                  expr: r'$.id',
                ),
                predicate: Predicate(
                  type: 'exist',
                ),
              ),
            ],
          ),
        ),

        // Third request - Update user
        HurlEntry(
          request: HurlRequest(
            method: 'PUT',
            url: 'http://api.example.com/users/{{user_id}}',
            headers: [
              Header(name: 'Content-Type', value: 'application/json'),
            ],
            body: RequestBody(
              type: 'json',
              value: {
                'name': 'John Updated',
              },
            ),
            comments: [' Third request - Update user'],
          ),
          response: HurlResponse(
            version: 'HTTP/1.1',
            status: 200,
            captures: [
              Capture(
                name: 'updated_at',
                query: Query(
                  type: 'jsonpath',
                  expr: r'$.updated_at',
                ),
              ),
            ],
          ),
        ),

        // Fourth request - Get user posts
        HurlEntry(
          request: HurlRequest(
            method: 'GET',
            url: 'http://api.example.com/users/{{user_id}}/posts',
            options: [
              RequestOption(name: 'insecure', value: true),
              RequestOption(name: 'retry', value: 3),
            ],
            comments: [' Fourth request - Get user posts'],
          ),
          response: HurlResponse(
            version: 'HTTP/1.1',
            status: 200,
            asserts: [
              HurlAssert(
                query: Query(
                  type: 'jsonpath',
                  expr: r'$.posts',
                ),
                predicate: Predicate(
                  type: 'isCollection',
                ),
              ),
            ],
          ),
        ),

        // Fifth request - Delete user
        HurlEntry(
          request: HurlRequest(
            method: 'DELETE',
            url: 'http://api.example.com/users/{{user_id}}',
            comments: [' Fifth request - Delete user'],
          ),
          response: HurlResponse(
            version: 'HTTP/1.1',
            status: 204,
          ),
        ),
      ],
    );

    final jsonString = parseHurlToJson(content: r'''# First request - Get users
GET http://api.example.com/users
Authorization: Bearer token123
Accept: application/json
HTTP/1.1 200
[Captures]
user_id: jsonpath "$.users[0].id"
[Asserts]
header "Content-Type" == "application/json"
# Second request - Create user
POST http://api.example.com/users
Content-Type: application/json
{
    "name": "John Doe",
    "email": "john@example.com"
}
HTTP/1.1 201
[Asserts]
header "Location" exists
jsonpath "$.id" exists
# Third request - Update user
PUT http://api.example.com/users/{{user_id}}
Content-Type: application/json
{
    "name": "John Updated"
}
HTTP/1.1 200
[Captures]
updated_at: jsonpath "$.updated_at"
# Fourth request - Get user posts
GET http://api.example.com/users/{{user_id}}/posts
[Options]
insecure: true
retry: 3
HTTP/1.1 200
[Asserts]
jsonpath "$.posts" isCollection
# Fifth request - Delete user
DELETE http://api.example.com/users/{{user_id}}
HTTP/1.1 204''');

    // Print JSON for debugging
    print('Parsed JSON from HURL file object:');
    print(JsonEncoder.withIndent('  ').convert(jsonDecode(jsonString)));

    final actual = HurlFile.fromJson(jsonDecode(jsonString));

    // Compare entries length first for easier debugging
    expect(actual.entries.length, expected.entries.length);

    // Then compare the entire structure
    expect(actual, expected);
  });
}
