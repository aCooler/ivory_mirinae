import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import '../../endpoint.dart';
import '../../../entities/v1/entities.dart';

const _prefix = '/api/v1/statuses';

const _StatusesGet statusesGet = const _StatusesGet();
// const _StatusesContext statusesContext = const _StatusesContext();
// const _StatusesCard statusesCard = const _StatusesCard();
// const _StatusesRebloggedBy statusesRebloggedBy = const _StatusesRebloggedBy();
// const _StatusesFavoratedBy statusesFavoratedBy = const _StatusesFavoratedBy();
const _StatusesPost statusesPost = const _StatusesPost();
// const _StatusesDelete statusesDelete = const _StatusesDelete();
// const _StatusesReblog statusesReblog = const _StatusesReblog();
// const _StatusesUnreblog statusesUnreblog = const _StatusesUnreblog();
// const _StatusesFavorate statusesFavorate = const _StatusesFavorate();
// const _StatusesUnfavorate statusesUnfavorate = const _StatusesUnfavorate();
// const _StatusesMute statusesMute = const _StatusesMute();
// const _StatusesUnmute statusesUnmute = const _StatusesUnmute();

class _StatusesGet extends Endpoint {
  const _StatusesGet() : super(method: HttpMethod.GET, url: _prefix);

  Future<Status> call(http.Client client, {String base_url, String id}) async {
    return new Status.fromJson(json.decode(await accessEndpointGet(
      client: client,
      instance_url: base_url,
      suburl: id,
    )));
  }
}

class _StatusesPost extends Endpoint {
  const _StatusesPost() : super(method: HttpMethod.POST, url: _prefix);

  Future<Status> call(http.Client client,
      {String base_url, StatusPost status_posting}) async {
    return new Status.fromJson(json.decode(await accessEndpointPost(
        client: client,
        instance_url: base_url,
        body_json: status_posting.toJson())));
  }
}
