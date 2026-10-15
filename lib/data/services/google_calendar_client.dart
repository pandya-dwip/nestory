import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:googleapis_auth/googleapis_auth.dart';

/// Thin, testable wrapper around [cal.CalendarApi].
class GoogleCalendarClient {
  GoogleCalendarClient(this._api);

  final cal.CalendarApi _api;

  factory GoogleCalendarClient.fromAuthClient(AuthClient client) {
    return GoogleCalendarClient(cal.CalendarApi(client));
  }

  /// Lists all accessible Google Calendars for the authenticated account.
  Future<cal.CalendarList> listCalendars() {
    return _api.calendarList.list();
  }

  /// Lists events for a calendar.
  ///
  /// IMPORTANT: When [syncToken] is provided, [timeMin] and [timeMax] MUST NOT
  /// be passed, otherwise the Google Calendar API returns an HTTP 400 Bad Request.
  Future<cal.Events> listEvents(
    String calendarId, {
    String? syncToken,
    DateTime? timeMin,
    DateTime? timeMax,
    String? pageToken,
    int maxResults = 250,
  }) {
    if (syncToken != null && syncToken.isNotEmpty) {
      return _api.events.list(
        calendarId,
        syncToken: syncToken,
        singleEvents: true,
        pageToken: pageToken,
        maxResults: maxResults,
      );
    } else {
      return _api.events.list(
        calendarId,
        timeMin: timeMin?.toUtc(),
        timeMax: timeMax?.toUtc(),
        singleEvents: true,
        pageToken: pageToken,
        maxResults: maxResults,
      );
    }
  }

  /// Creates an event in Google Calendar.
  ///
  /// If [event.id] is provided by the client (a base32hex UUID), it enables
  /// idempotent event creation and duplicate prevention.
  Future<cal.Event> insertEvent(String calendarId, cal.Event event) {
    return _api.events.insert(event, calendarId);
  }

  /// Updates an existing event in Google Calendar.
  Future<cal.Event> patchEvent(
    String calendarId,
    String eventId,
    cal.Event event,
  ) {
    return _api.events.patch(event, calendarId, eventId);
  }

  /// Deletes an event from Google Calendar.
  Future<void> deleteEvent(String calendarId, String eventId) {
    return _api.events.delete(calendarId, eventId);
  }

  /// Fetches an event by ID. Used for HTTP 409 duplicate verification and conflict resolution.
  Future<cal.Event?> getEvent(String calendarId, String eventId) async {
    try {
      return await _api.events.get(calendarId, eventId);
    } on cal.DetailedApiRequestError catch (e) {
      if (e.status == 404) return null;
      rethrow;
    }
  }
}
