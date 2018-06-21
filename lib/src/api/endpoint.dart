import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../entities/v1/entities.dart';

enum HttpMethod { GET, POST, PATCH, DELETE }

/// Base class for each endpoint
///
/// Each endpoint should implement one of subclass of it by callable class,
/// hide implementation, and export final varlable of class.
abstract class Endpoint {
  final HttpMethod method;
  final String base_url;

  const Endpoint({this.method, this.base_url});

  /// for debug purpose
  static const bool _print_response = false;

  static bool _IsStatusCode2xx(int code) {
    return (200 <= code) && (300 > code);
  }

  http.Response handleError(http.Response response) {
    if (Endpoint._print_response) {
      print(response.body);
    }

    // handle error
    if (!Endpoint._IsStatusCode2xx(response.statusCode)) {
      throw new ErrorEntity.fromJson(json.decode(response.body));
    }

    return response;
  }
}

abstract class EndpointGet extends Endpoint {
  const EndpointGet(String base_url)
      : super(base_url: base_url, method: HttpMethod.GET);

  Future<String> accessEndpoint(
      {http.Client client = null,
      String instance_url,
      String suburl = null,
      Map<String, dynamic> params = null}) async {
    if (client == null) {
      client = new http.Client();
    }

    Uri ap_url = Uri.parse(
        '${instance_url}/${base_url}' + (suburl != null ? "/$suburl" : ""));
    ap_url = ap_url.replace(queryParameters: params);

    var response = await client.get(
      ap_url,
      headers: {"accept": "application/json"},
    );

    return handleError(response).body;
  }
}

abstract class EndpointPost extends Endpoint {
  const EndpointPost(String base_url)
      : super(base_url: base_url, method: HttpMethod.POST);

  Future<String> accessEndpoint(
      {http.Client client = null,
      String instance_url,
      Map<String, dynamic> body_json,
      String suburl = null}) async {
    if (client == null) {
      client = new http.Client();
    }

    String ap_url =
        '${instance_url}/${base_url}' + (suburl != null ? "/$suburl" : "");

    var response = await client.post(ap_url,
        headers: {"content-type": "application/json"},
        body: json.encode(body_json));

    return handleError(response).body;
  }
}

abstract class EndpointDelete extends Endpoint {
  const EndpointDelete(String base_url)
      : super(base_url: base_url, method: HttpMethod.DELETE);

  Future<String> accessEndpoint(
      {http.Client client = null,
      String instance_url,
      String suburl = null}) async {
    if (client == null) {
      client = new http.Client();
    }

    String ap_url =
        '${instance_url}/${base_url}' + (suburl != null ? "/$suburl" : "");

    var response = await client
        .delete(ap_url, headers: {"content-type": "application/json"});

    return handleError(response).body;
  }
}
// abstract class EndpointPatch extends Endpoint {}
