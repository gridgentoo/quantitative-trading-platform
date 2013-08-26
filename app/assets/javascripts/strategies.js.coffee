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

  $ ->
    $.getJSON "http://www.highcharts.com/samples/data/jsonp.php?filename=aapl-ohlcv.json&callback=?", (data) ->
      ohlc = []
      volume = []
      dataLength = data.length
      i = 0
      while i < dataLength
        ohlc.push [data[i][0], data[i][1], data[i][2], data[i][3], data[i][4]] # close
        volume.push [data[i][0], data[i][5]] # the volume
        i++
      
      groupingUnits = [["week", [1]], ["month", [1, 2, 3, 4, 6]]]
      
      $("#backtestingChartContainer").highcharts "StockChart",
        title:
          text: "Backtest Results"
        
        credits:
          enabled: false

        yAxis: [
          title:
            text: "Prices"
          height: 200
          lineWidth: 2
        ,
          title:
            text: "Returns"
          top: 300
          height: 100
          offset: 0
          lineWidth: 2
        ,
          title:
            text: "Transactions"
          top: 400
          height: 100
          offset: 0
          lineWidth: 2
        ]
        series: [
          type: "line"
          name: "AAPL"
          data: ohlc
          dataGrouping:
            units: groupingUnits
        ,
          type: "column"
          name: "Returns"
          data: volume
          yAxis: 1
          dataGrouping:
            units: groupingUnits
        ,
          type: "column"
          name: "Transactions"
          data: volume
          yAxis: 2
          dataGrouping:
            units: groupingUnits
        ]

$(document).ready(ready)
$(document).on('page:load', ready)
