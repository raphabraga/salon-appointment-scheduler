#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ My Salon ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  if [[ $1 ]]
      then
      echo -e "\n$1"
  fi
    SERVICES_RESULT=$($PSQL "SELECT service_id, name FROM services") 
    echo "$SERVICES_RESULT" | while read ID BAR NAME
        do
        echo "$ID) $NAME"
    done
    read SERVICE_ID_SELECTED
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

    if [[ -z $SERVICE_NAME ]]
        then
            MAIN_MENU "I could not find that service. What would you like today?"   
        else
            echo -e "\nWhat's your phone number?"
            read CUSTOMER_PHONE
            CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
            if [[ -z $CUSTOMER_NAME ]]
                then
                    echo -e "\nI don't have a record for that phone number, what's your name?"
                    read CUSTOMER_NAME 
                    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
            fi
                CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
                echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
                read SERVICE_TIME
                INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (time, customer_id, service_id) VALUES ('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED)")
                echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
}

MAIN_MENU
