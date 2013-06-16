class UrlShortener
  constructor: (@url) ->
    document.getElementById('copy-url').onclick = @copyUrlToClipboard
    document.getElementById('url-details').onclick = @openUrlDetails

  shortenUrl: (url) ->
    http = new XMLHttpRequest()
    params = "{\"url\": \"#{url}\"}"

    http.open("POST", @url, true)

    http.setRequestHeader("Content-type", "application/json")
    http.setRequestHeader("Accept", "application/json, text/javascript, */*; q=0.01")

    http.onreadystatechange = =>
      if http.readyState == 4 && http.status == 201
        @handleResponse(http.responseText)

    http.send(params)

  handleResponse: (data) =>
    data = JSON.parse(data)

    @id = data["id"]
    @short_name = data["short_name"]

    @renderShortUrl()

  renderShortUrl: ->
    document.getElementById('shortcode').innerHTML = @short_name

  copyUrlToClipboard: =>
    if @short_name?
      url = "#{@url}/#{@short_name}"

      sandboxEl = document.getElementById('sandbox')
      sandboxEl.value = url
      sandboxEl.select()
      document.execCommand('copy')

      sandboxEl.value = ''

  openUrlDetails: =>
    if @id?
      chrome.tabs.create(url: "#{@url}/short_urls/#{@id}")

shortener = new UrlShortener("http://wcmc.io")
chrome.tabs.getSelected null, (tab) ->
  shortener.shortenUrl(tab.url)
