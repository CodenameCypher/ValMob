class Match{
  String startTime;
  String state;
  String league_name;
  String league_image;
  String league_region;
  String tournament_name;
  String tournament_season;
  String match_id;
  String team1_name;
  String team1_code;
  String team1_image;
  String team2_name;
  String team2_code;
  String team2_image;
  String strategy_type;
  String strategy_count;

  Match({
    required this.startTime,
    required this.state,
    required this.league_name,
    required this.league_image,
    required this.league_region,
    required this.tournament_name,
    required this.tournament_season,
    required this.match_id,
    required this.team1_name,
    required this.team1_code,
    required this.team1_image,
    required this.team2_name,
    required this.team2_code,
    required this.team2_image,
    required this.strategy_type,
    required this.strategy_count
  });
}