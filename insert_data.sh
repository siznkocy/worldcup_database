#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

INSERT_TEAM(){
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$1'")
  if [[ -z  $TEAM_ID ]]
  then
    INSERT_TEAM="$($PSQL "INSERT INTO teams(name) VALUES ('$1')")"
    if [[ $INSERT_TEAM == "INSERT 0 1" ]]
    then
      # echo "'$1', Inserted"
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$1'")
    fi
  fi
}

INSERT_GAMES(){
  INSERT_GAME="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR,'$ROUND',$WIN_ID,$OPP_ID,$WINNER_GOALS,$OPPONENT_GOALS)")"
  echo 'Inserted'
}

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    echo -e "\n-- $WINNER v $OPPONENT --"
    INSERT_TEAM "$WINNER"
    WIN_ID=$TEAM_ID
    INSERT_TEAM "$OPPONENT"
    OPP_ID=$TEAM_ID
    # echo $WIN_ID : $OPP_ID
    # echo $YEAR "$ROUND" $WIN_ID $OPP_ID $WINNER_GOALS $OPPONENT_GOALS
    INSERT_GAMES $YEAR "$ROUND" $WIN_ID $OPP_ID $WINNER_GOALS $OPPONENT_GOALS
  fi
done
