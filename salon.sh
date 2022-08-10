#! /bin/bash
 
echo -e "\n~~~~~ MY SALON ~~~~~\n"
 
PSQL='psql -X --username=freecodecamp --dbname=salon --tuples-only -c'
#wrap_the_table=$($PSQL "TRUNCATE customers, appointments;")
MAIN_MENU() {
  #if no the services
  if [[ $1 ]]
  then
    echo $1
  fi
  #list of services
  echo "$($PSQL "SELECT * FROM services")" | while read service_id bar service_name
  do
    echo "$service_id) $service_name"
  done
  #check if we have the service
  echo -e "Welcome to My Salon, how can I help you?\n(Please enter the service id)"
  read SERVICE_ID_SELECTED
  SERVICE_ID=$($PSQL "SELECT service_id From services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_ID ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  fi
  ORDER_SERVICE 
	#一定要放去if入面?
}
 
ORDER_SERVICE() {
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id =$SERVICE_ID")
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  check_phone=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $check_phone ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    #insert customer_info only if they are new
    INSERT_customers=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi
  echo -e "\nWhat time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  #get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # INSERT data to appointment
  INSERT_appointments=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID,'$SERVICE_TIME')")
  #success
  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  ENDING
}
 
ENDING() {
  echo "-------ending-------"
}
MAIN_MENU
 

