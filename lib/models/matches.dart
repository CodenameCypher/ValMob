class Match{
  String team_one_name;
  String team_two_name;
  String team_one_players;
  String team_two_players;
  String team_one_logo;
  String team_two_logo;
  String match_url;
  String event_name;
  String event_icon_url;
  String match_time;
  String eta;
  String flag1;
  String flag2;
  String score1;
  String score2;
  String round_info;
  String streams;

  Match({
    required this.team_one_name,
    required this.team_two_name,
    required this.team_one_players,
    required this.team_two_players,
    required this.team_one_logo,
    required this.team_two_logo,
    required this.match_url,
    required this.event_name,
    required this.event_icon_url,
    required this.match_time,
    required this.eta,
    required this.flag1,
    required this.flag2,
    required this.score1,
    required this.score2,
    required this.round_info,
    required this.streams
  });
}