#!/bin/bash

PSQL="psql -X -U freecodecamp -d worldcup -t --no-align -c"

CREATE_TABLE(){
  TABLE_CREATED=$($PSQL "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = '$TABLE_NAME')") 

  if [[ $TABLE_CREATED == 'f' ]]
  then
    TABLE=$($PSQL "CREATE TABLE $TABLE_NAME $TABLE_COLUMN")
    if [[ $TABLE == 'CREATE TABLE' ]]
    then
      echo -e "Table created: $TABLE_NAME\n"
    fi
  else
    echo "Table $TABLE_NAME, exist!"
  fi
}

TABLE_NAME="teams"
TABLE_COLUMN="(team_id SERIAL PRIMARY KEY, name VARCHAR(30) UNIQUE NOT NULL)"
CREATE_TABLE $TABLE_NAME $TABLE_COLUMN

TABLE_NAME="games"
TABLE_COLUMN="(game_id SERIAL PRIMARY KEY, year INT NOT NULL, round VARCHAR(30) NOT NULL, winner_id INT NOT NULL, opponent_id INT NOT NULL, winner_goals INT NOT NULL, opponent_goals INT NOT NULL, FOREIGN KEY (winner_id) REFERENCES teams(team_id), FOREIGN KEY (opponent_id) REFERENCES teams(team_id))"
CREATE_TABLE $TABLE_NAME $TABLE_COLUMN
