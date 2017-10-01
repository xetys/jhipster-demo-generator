#!/bin/bash

mkdir docker kubernetes

cd uaa
yarn link generator-jhipster
jhipster --with-entities
yarn link generator-jhipster
cat > customers.jh <<- EOM
entity Customer {
    streetName String,
    streetNumber String,
    postalCode String,
    city String
}

entity User {

}

relationship OneToOne {
    Customer{user} to User{customer}
}

EOM
jhipster import-jdl customers.jh --force
./gradlew -P prod -P prometheus -x test build buildDocker
cd ../bookservice
yarn link generator-jhipster
jhipster --with-entities
yarn link generator-jhipster
cat > books.jh <<- EOM
entity Book {
    title String required,
    author String,
    year Integer,
    price Integer
}

entity Category {
    title String required
}

relationship ManyToOne {
    Book{category} to Category

}

EOM
jhipster import-jdl books.jh --force
./gradlew -P prod -P prometheus -x test build buildDocker
cd ../orderservice
yarn link generator-jhipster
jhipster --with-entities
yarn link generator-jhipster
cat > orders.jh <<- EOM

enum OrderStatus {
    NEW,
    PAYED,
    SHIPPED
}

entity BookOrder {
    status OrderStatus required,
    customerId Long required
}

entity BookHolder {
    bookId Long required
}

relationship ManyToMany {
    BookOrder{book} to BookHolder{order}
}
EOM
jhipster import-jdl orders.jh --force
./gradlew -P prod -P prometheus -x test build buildDocker
cd ../gateway
yarn link generator-jhipster
jhipster --with-entities --skip-install
yarn link generator-jhipster
cp ../app.jh .
jhipster import-jdl app.jh --force --skip-install
./gradlew -P prod -P prometheus -x test build buildDocker
cd ../docker
jhipster docker-compose --force
cd ../kubernetes
jhipster kubernetes
