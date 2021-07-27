# Venmo - Social Payment Service

## Project Description

Venmo is a mobile payment service which allows friends to transfer money to each other. It also has some social features like show your friends payment activities as feed. In this project we will try to simulate part of the functionality through an API.
I will simulate build a simple payment system like Venmo with following functionalities:

  1. Send payment to a friend
  1. List friends’ payment activities including yours in the feed

## APIs

### `POST /user/:id/payment`
This endpoint allows two users who are friends to carry out a payment transaction.

**Request body**:
```json
{
    "friend_id": 2,
    "amount": 10.0,
    "description": "testing payment"
}
```
The payment process is executed in the `FundTransferService` with the `pay` method, allowing the transactions to be atomic, avoiding errors in the generation of the payment report and the update of the amount that each user has.

Before carrying out the payment process, it is verified if the users are friends, otherwise an error message is generated that interrupts the execution process.
Subsequently, it is analyzed if the user can transfer money, which means that if his amount does not have enough, it is necessary to make a credit with the `MoneyTransferService` to transfer the money to his account and finally make the payment process between friends .

Finally, to conclude the payment between friends, the amount is subtracted from the sender, the amount is added to the receiver and finally the payment summary is created.

An example of how the payment transaction is executed in the service is: `FundTransferService.new (sender, receiver, amount, description).pay`

### `GET /user/:id/feed?page=number`

This endpoint show all payments of user and user's friends.

**Request body**:
```json
{
    "page": 2
}
```
This feed is calculated using the relationships that exist between friends and friends of friends, allowing you to see your payment history in descending order based on the creation date of the payment.

This means that the endpoint must list the following payment summaries:

1- The payments sent by the `user_a` to his friends and the receipt of the payments made by his friends.
1- The payments sent and that were received to the friends of the `user_a`. (For this case the `user_b`).
1- The payments sent and that were received to the friends of the friends of the `user_a`. These would be the payments of the friends of `user_b`.

The `pages` parameter helps to filter the page number to be listed in the payment query result (10 per page). This is with the help of the [Pagy](https://github.com/ddnexus/pagy) gem that has been added to the project.

When making the request to the api, the following responses can be taken into account:

1. If the `page` parameter is not supplied, the server's response will return the first page of results.
2. If the parameter `page` is greater than the number of pages available, it will show an error describing which is the last page available.

**Response body**:
```json
{
  "feed": [
      "user_b paid user_c on 2021-07-27 04:35:22 UTC - gaming stuff",
      "user_b paid user_a on 2021-07-27 04:35:22 UTC - for cats",
      "user_a paid user_b on 2021-07-27 04:35:22 UTC - new toy"
  ]
}
```

### `GET /user/:id/balance`

This endpoint returns the current amount of the user.

**Response body**:
```json
{
    "balance": 100.0
}
```
## Entity–Relationship Model
The following graphic represents the models involved in the business logic built for the APIs described above.
![Entity–Relationship Model](https://github.com/szcrubyroostrap/venmo-api/blob/development/public/Api-ER.png?raw=true)

## Setup instructions

### Dependencies

This project was developed with the following technologies:

- Ruby 2.7.4p191
- Rails 6.1.4
- Bundler version 2.1.4
- PostgreSQL 13.3

### Installation
1. Clone the project `git clone https://github.com/szcrubyroostrap/venmo-api.git`
2. Execute in terminal  `bundle install`

### Database Setup

1.  run  `bundle exec rails db:create`
2.  run  `bundle exec rails db:migrate`
3.  run  `bundle exec rails db:seeds`

### Unit Testing
You have to run the following command in a terminal: `bundle exec rspec`

### Code Formatter
To improve the quality of the source code, the following gems have been added to the project.
1.  `Annotate`  (Adds comments to the models and factories taking into account the current database schema)
2.  `Rubocop`  (Linter)
3. `rubocop-rootstrap` (Improvements to Rubocop by Rootstrap)

### Branches
The `main` branch is the starting point for the `development` branch. From `development` branches are created to make the changes according to the required functionalities.

Once the certification process is correct, you must merge from `Development` to `Main`.
