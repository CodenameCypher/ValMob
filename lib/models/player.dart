class Player{
  String player_name;
  String player_link;
  String player_team_initials;
  String player_country_initials;
  String rounds_played;
  String rating;
  String average_combat_score;
  String kills_deaths;
  String kill_assist_trade_survive_percentage;
  String average_damage_per_round;
  String kills_per_round;
  String assists_per_round;
  String first_kills_per_round;
  String first_deaths_per_round;
  String headshot_percentage;
  String clutch_success_percentage;
  String max_kills_in_single_map;
  String kills;
  String deaths;

  Player({
    required this.player_name,
    required this.player_link,
    required this.player_team_initials,
    required this.player_country_initials,
    required this.rounds_played,
    required this.rating,
    required this.average_combat_score,
    required this.kills_deaths,
    required this.kill_assist_trade_survive_percentage,
    required this.average_damage_per_round,
    required this.kills_per_round,
    required this.assists_per_round,
    required this.first_kills_per_round,
    required this.first_deaths_per_round,
    required this.headshot_percentage,
    required this.clutch_success_percentage,
    required this.max_kills_in_single_map,
    required this.kills,
    required this.deaths
  });
}