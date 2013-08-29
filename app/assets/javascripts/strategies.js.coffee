addChartPoint = (chart)->
  adj_close_tick = window.adj_close_data.shift()
  ind1_tick = window.ind1_data.shift()
  ind2_tick = window.ind2_data.shift()
  # Prevent position fill data from getting ahead of the rest
  if window.position_fill_data.length > 0 and window.position_fill_data[0][0] <= adj_close_tick[0]
    position_fill_tick = window.position_fill_data.shift()
  volume_tick = window.volume_data.shift()
  chart.series[0].addPoint adj_close_tick, false
  chart.series[1].addPoint ind1_tick, false
  chart.series[2].addPoint ind2_tick, false
  chart.series[3].addPoint(position_fill_tick, false) if position_fill_tick
  chart.series[4].addPoint volume_tick, false
  false

addAndRefreshChartAndIndicatiors = (chart)->
  for i in [0...200]
    break if window.volume_data.length == 0
    addChartPoint chart
  chart.redraw()
  progress = Math.round( 100 - window.volume_data.length / window.initialProgressSize * 100 ) + '%'
  $('#backtestProgressBar').css 'width', progress
  $('#backtestProgressPercentage').text progress

loadChartData = (chart)->
  window.initialProgressSize = window.volume_data.length
  # start plotting data on chart
  addAndRefreshChartAndIndicatiors chart

  # set interval to simulate data streaming
  window.loadChartDataDelay = setInterval ->
    addAndRefreshChartAndIndicatiors chart
    if window.loadChartDataDelay and window.volume_data.length == 0
      clearInterval window.loadChartDataDelay
      false
  , 1000
  false

loadChart = ->
  window.adj_close_data = $("#backtestingChartContainer").data('adj_close').slice(0)
  window.ind1_data = $("#backtestingChartContainer").data('ind1').slice(0)
  window.ind2_data = $("#backtestingChartContainer").data('ind2').slice(0)
  window.volume_data = $("#backtestingChartContainer").data('volume').slice(0)
  window.position_fill_data = $("#backtestingChartContainer").data('position_fill').slice(0)

  groupingUnits = [["week", [1]], ["month", [1, 2, 3, 4, 6]]]

  window.loadingThrobber.hide()

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
        text: "Position Fill"
      top: 300
      height: 100
      offset: 0
      lineWidth: 2
    ,
      title:
        text: "Returns"
      top: 400
      height: 100
      offset: 0
      lineWidth: 2
    ]
    series: [
      type: "line"
      name: "AAPL"
      data: []
      dataGrouping:
        units: groupingUnits
      tooltip:
        valueDecimals: 2
    ,
      type: "line"
      name: "SMA 50"
      data: []
      dataGrouping:
        units: groupingUnits
      tooltip:
        valueDecimals: 2
    ,
      type: "line"
      name: "SMA 250"
      data: []
      dataGrouping:
        units: groupingUnits
      tooltip:
        valueDecimals: 2
    ,
      name: "Position Fill"
      data: []
      step: true
      yAxis: 1
      dataGrouping:
        units: groupingUnits
    ,
      type: "column"
      name: "Returns"
      data: []
      yAxis: 2
      dataGrouping:
        units: groupingUnits
    ]
  , (chart) ->
    loadChartData(chart) # load data progressively

loadDateRangePicker = ->
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

runTest = ->
  clearInterval window.loadChartDataDelay if window.loadChartDataDelay
  $('#backtestProgressBar').css 'width', '0%'
  $('#backtestProgressPercentage').text '0%'
  window.chartContainer.html ''
  window.loadingThrobber.show()
  $('body').animate
    scrollTop: $('#backtestProgressBarContainer').offset().top
  , 500, ->
    loadChart()


bindRunBacktestButton = ->
  $(document).on 'click', '#btnRunBacktest', ->
    runTest()

ready = ->
  window.loadingThrobber = $("#backtestingChartThrobber")
  window.chartContainer = $("#backtestingChartContainer")
  loadDateRangePicker()
  bindRunBacktestButton()

$(document).ready(ready)
$(document).on('page:load', ready)
