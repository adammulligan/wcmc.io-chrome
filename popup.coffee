class UrlShortener
  constructor: (@url) ->
    $('#copy-url').click(@copyUrlToClipboard)
    $('#url-details').click(@openUrlDetails)

    chrome.tabs.getSelected null, (tab) =>
      @shortenUrl(tab.url)

  shortenUrl: (url) ->
    $.ajax(
      type: "POST"
      url: @url
      data: {url: url}
      success: @handleResponse
      dataType: 'json'
    )

  handleResponse: (data) =>
    @id = data["id"]
    @short_name = data["short_name"]

    @renderShortUrl()

  renderShortUrl: ->
    $('.shortcode').html(@short_name)

  copyUrlToClipboard: =>
    if @short_name?
      url = "#{@url}/#{@short_name}"
      $('#sandbox').val(url).select()
      document.execCommand('copy')
      $('#sandbox').val('')

  openUrlDetails: =>
    if @id?
      chrome.tabs.create(url: "#{@url}/short_urls/#{@id}")

$(document).ready ->
  new UrlShortener("http://wcmc.io")
