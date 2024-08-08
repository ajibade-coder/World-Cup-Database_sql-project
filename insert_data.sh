#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv |  while IFS="," read -ra datas
do
echo ${datas[2]}
COUNTRY=${datas[2]}
SECOND_COUNTRY=${datas[3]}
FIRST_CHECK=$($PSQL "SELECT name FROM teams WHERE name='$COUNTRY' ")
SECOND_CHECK=$($PSQL "SELECT name FROM teams WHERE name='$SECOND_COUNTRY' ")



 
if [[ $COUNTRY != winner ]]
then

 ##########################################################
if [[ -z  $FIRST_CHECK  || -z $SECOND_CHECK ]]
then
########################## if both countries are not recoreded in the database
if [[ -z  $FIRST_CHECK  && -z $SECOND_CHECK ]]
then
echo "$($PSQL "INSERT INTO teams(name) VALUES('$COUNTRY')")"
echo "$($PSQL "INSERT INTO teams(name) VALUES('$SECOND_COUNTRY')")"
##################################################################################

######################################################### if only first country not recoreded in the database
elif [[ -z $FIRST_CHECK  && -n $SECOND_CHECK ]]
 then
 echo "$($PSQL "INSERT INTO teams(name) VALUES('$COUNTRY')")"
 ############################################################################################# if only second country not recorded in the database
 else
  echo "$($PSQL "INSERT INTO teams(name) VALUES('$SECOND_COUNTRY')")"
fi
################################################################################################ end of checking conditions to insert into team database
fi
################

##### get datas for games table ###
YEAR=${datas[0]}
ROUND=${datas[1]}
WINNERGOAL=${datas[4]}
OPPONENTGOAL=${datas[5]}
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$COUNTRY' ")
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$SECOND_COUNTRY' " )
#################

### inserting required datas into games table #########
echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNERGOAL', '$OPPONENTGOAL') ")"


fi
####################################################

done

