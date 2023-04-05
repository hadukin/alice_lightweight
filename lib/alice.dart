import 'dart:io';

import 'package:alice_lightweight/core/alice_core.dart';
import 'package:alice_lightweight/core/alice_dio_interceptor.dart';
import 'package:alice_lightweight/core/alice_http_adapter.dart';
import 'package:alice_lightweight/core/alice_http_client_adapter.dart';
import 'package:alice_lightweight/model/alice_http_call.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Alice {
  /// Should inspector use dark theme
  final bool darkTheme;

  ///Max number of calls that are stored in memory. When count is reached, FIFO
  ///method queue will be used to remove elements.
  final int maxCallsCount;

  ///Directionality of app. Directionality of the app will be used if set to null.
  final TextDirection? directionality;

  ///Flag used to show/hide share button
  final bool? showShareButton;

  GlobalKey<NavigatorState>? _navigatorKey;
  late AliceCore _aliceCore;
  late AliceHttpClientAdapter _httpClientAdapter;
  late AliceHttpAdapter _httpAdapter;

  /// Creates alice instance.
  Alice({
    GlobalKey<NavigatorState>? navigatorKey,
    this.darkTheme = false,
    this.maxCallsCount = 1000,
    this.directionality,
    this.showShareButton = true,
  }) {
    _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();
    _aliceCore = AliceCore(
      _navigatorKey,
      darkTheme: darkTheme,
      maxCallsCount: maxCallsCount,
      directionality: directionality,
      showShareButton: showShareButton,
    );
    _httpClientAdapter = AliceHttpClientAdapter(_aliceCore);
    _httpAdapter = AliceHttpAdapter(_aliceCore);
  }

  /// Set custom navigation key. This will help if there's route library.
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    _aliceCore.navigatorKey = navigatorKey;
  }

  /// Get currently used navigation key
  GlobalKey<NavigatorState>? getNavigatorKey() {
    return _navigatorKey;
  }

  /// Get Dio interceptor which should be applied to Dio instance.
  AliceDioInterceptor getDioInterceptor() {
    return AliceDioInterceptor(_aliceCore);
  }

  /// Handle request from HttpClient
  void onHttpClientRequest(HttpClientRequest request, {dynamic body}) {
    _httpClientAdapter.onRequest(request, body: body);
  }

  /// Handle response from HttpClient
  void onHttpClientResponse(
    HttpClientResponse response,
    HttpClientRequest request, {
    dynamic body,
  }) {
    _httpClientAdapter.onResponse(response, request, body: body);
  }

  /// Handle both request and response from http package
  void onHttpResponse(http.Response response, {dynamic body}) {
    _httpAdapter.onResponse(response, body: body);
  }

  /// Opens Http calls inspector. This will navigate user to the new fullscreen
  /// page where all listened http calls can be viewed.
  void showInspector() {
    _aliceCore.navigateToCallListScreen();
  }

  /// Handle generic http call. Can be used to any http client.
  void addHttpCall(AliceHttpCall aliceHttpCall) {
    assert(aliceHttpCall.request != null, "Http call request can't be null");
    assert(aliceHttpCall.response != null, "Http call response can't be null");
    _aliceCore.addCall(aliceHttpCall);
  }
}
