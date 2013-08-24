# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $("input#inputStrategyDateRange").daterangepicker
    ranges:
      #Today: [moment(), moment()]
      #Yesterday: [moment().subtract("days", 1), moment().subtract("days", 1)]
      #"Last 7 Days": [moment().subtract("days", 6), moment()]
      #"Last 30 Days": [moment().subtract("days", 29), moment()]
      #"This Month": [moment().startOf("month"), moment().endOf("month")]
      #"Last Month": [moment().subtract("month", 1).startOf("month"), moment().subtract("month", 1).endOf("month")]
      "1 Month": [moment().subtract("month", 1), moment()]
      "3 Months": [moment().subtract("month", 3), moment()]
      "6 Months": [moment().subtract("month", 6), moment()]
      "1 Year": [moment().subtract("year", 1), moment()]
      "5 Year": [moment().subtract("year", 5), moment()]
      "10 Year": [moment().subtract("year", 10), moment()]

    startDate: moment().subtract("days", 29)
    endDate: moment()
    format: 'DD MMM YYYY'

$(document).ready(ready)
$(document).on('page:load', ready)
