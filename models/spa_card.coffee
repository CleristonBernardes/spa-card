mongoose = require 'mongoose'

SpaCard = new mongoose.Schema
  given_name: String
  surname: String
  email: String
  phone: String
  house_number: String
  street: String
  suburb: String
  state: String
  postcode: Number
  country: String

SpaCard.index { "given_name": 1 }
module.exports = mongoose.model "spacard", SpaCard
