#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [ -z "$1" ]; then
  echo "Please provide an element as an argument."
else
  # Get the element data from the database
  # element=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1 OR symbol='$1' OR name='$1'")
  if [[ $1 =~ ^[0-9]+$ ]]; then
  element=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
else
  element=$($PSQL "SELECT * FROM elements WHERE symbol='$1' OR name='$1'")
fi

  # Check if the element exists
  if [ -z "$element" ]; then
    echo "I could not find that element in the database."
  else
    # Extract the data from the element variable
    atomic_number=$(echo "$element" | awk -F '|' '{print $1}' | xargs)
    symbol=$(echo "$element" | awk -F '|' '{print $2}' | xargs)
    name=$(echo "$element" | awk -F '|' '{print $3}' | xargs)
    # type=$($PSQL "SELECT type FROM properties WHERE atomic_number=$atomic_number" | xargs)
    atomic_mass=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$atomic_number" | xargs)
    melting_point=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$atomic_number" | xargs)
    boiling_point=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$atomic_number" | xargs)
    type_id=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $atomic_number;")
        if [ $type_id -eq 1 ]
          then
            type="metal"
          elif [ $type_id -eq 2 ]
            then
              type="nonmetal"
          elif [ $type_id -eq 3 ]
            then
              type="metalloid"
          else
            type="unknown"
        fi
        echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
    fi
fi

# Finish running
exit 0
