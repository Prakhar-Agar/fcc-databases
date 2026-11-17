#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -A -c"
SECRET_NUMBER=$(( RANDOM%1000+1 ))

echo Enter your username:
read USERNAME

RESULT=$($PSQL "SELECT EXISTS( SELECT 1 FROM users WHERE name='$USERNAME')")
if [[ $RESULT == "t" ]]
then
  GAME_PLAYED=$($PSQL "SELECT game_played FROM users WHERE name='$USERNAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE name='$USERNAME'")
  echo Welcome back, $USERNAME! You have played $GAME_PLAYED games, and your best game took $BEST_GAME guesses.
else
  echo Welcome, $USERNAME! It looks like this is your first time here.
  INSERT_USERNAME=$($PSQL "INSERT INTO users(name) VALUES ('$USERNAME')")
  GAME_PLAYED=0
fi

GUESS_TRY=0
GAME_PLAY() {
  if [[ -z $1 ]]
  then
    echo Guess the secret number between 1 and 1000:
  else
    echo $1
  fi
  read GUESS
  if [[ $GUESS =~ ^[0-9]+$ ]]
  then
    if [[ $GUESS > $SECRET_NUMBER ]]
    then
      ((GUESS_TRY++))
      GAME_PLAY "It's lower than that, guess again:"
    elif [[ $GUESS < $SECRET_NUMBER ]]
    then
      ((GUESS_TRY++))
      GAME_PLAY "It's higher than that, guess again:"
    else
      ((GUESS_TRY++))
      echo "You guessed it in $GUESS_TRY tries. The secret number was $SECRET_NUMBER. Nice job!"
      INSERT_GAMES_PLAYED=$($PSQL "UPDATE users SET game_played= $GAME_PLAYED + 1 WHERE name='$USERNAME'")
      if [[ -z $BEST_GAME ]]
      then
        INSERT_BEST_GAME=$($PSQL "UPDATE users SET best_game= $GUESS_TRY WHERE name='$USERNAME'")
      else
        if [[ $GUESS_TRY < $BEST_GAME ]]
        then
          INSERT_BEST_GAME=$($PSQL "UPDATE users SET best_game= $GUESS_TRY WHERE name='$USERNAME'")
        fi
      fi
    fi
  else
    GAME_PLAY "That is not an integer, guess again:"
  fi
}

GAME_PLAY