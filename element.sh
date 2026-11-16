#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -A -c"

if [[ $1 ]]
then
  # check for existence of argument element in database
  RESULT_NUMBER=$($PSQL "SELECT EXISTS (SELECT 1 FROM elements WHERE atomic_number::TEXT='$1')")
  RESULT_SYMBOL=$($PSQL "SELECT EXISTS (SELECT 1 FROM elements WHERE LOWER(symbol) = LOWER('$1'))")
  RESULT_NAME=$($PSQL "SELECT EXISTS (SELECT 1 FROM elements WHERE LOWER(name) = LOWER('$1'))")
  if [[ $RESULT_NUMBER == "t" ]]
  then
    ATOMIC_NUMBER=$1
    ATOM_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    ATOM_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    echo "The element with atomic number $ATOMIC_NUMBER is $ATOM_NAME ($ATOM_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ATOM_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  elif [[ $RESULT_SYMBOL == "t" ]]
  then
    ATOM_SYMBOL=$1
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ATOM_SYMBOL'")
    ATOM_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    echo "The element with atomic number $ATOMIC_NUMBER is $ATOM_NAME ($ATOM_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ATOM_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  elif [[ $RESULT_NAME == "t" ]]
  then
    ATOM_NAME=$1
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ATOM_NAME'")
    ATOM_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    echo "The element with atomic number $ATOMIC_NUMBER is $ATOM_NAME ($ATOM_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ATOM_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  else
    # element not found in the database
    echo "I could not find that element in the database."
  fi
else
  # if no argument passed
  echo Please provide an element as an argument.
fi