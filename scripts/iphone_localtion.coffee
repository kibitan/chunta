iPhoneFinder = require('iphone-finder')
moment = require("moment")
moment.locale('ja')

iCloud = {
  chika: {
    user: process.env.ICLOUD_CHIKA_USER,
    pass: process.env.ICLOUD_CHIKA_PASS,
  },
  sato: {
    user: process.env.ICLOUD_SATO_USER,
    pass: process.env.ICLOUD_SATO_PASS,
  }
}

iphone = (icloud, callback) ->
  iPhoneFinder.findAllDevices icloud.user, icloud.pass, (err, devices) ->
    for device in devices
      return callback(device) if device.modelDisplayName == 'iPhone'

module.exports = (robot) ->
  reverse_geo_code = (lat, lon, callback) ->
    robot.http("http://geoapi.heartrails.com/api/json?method=searchByGeoLocation&x=#{lon}&y=#{lat}")
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        nearest_location = JSON.parse(body).response.location[0]
        callback(nearest_location)

  robot.respond /(.*)？/i, (res) ->
    switch res.match[1]
      when "ちか" then icloud = iCloud.chika
      when "さと" then icloud = iCloud.sato
      else return
    iphone icloud, (device) ->
      lat = device.location.latitude
      lon = device.location.longitude
      timestamp = moment( new Date(device.location.timeStamp) )
      now = moment( new Date )

      res.send timestamp.format('LTS') + "時点" + "（#{now.unix() - timestamp.unix()}秒前）"
      res.send "http://maps.google.com/maps/api/staticmap?size=400x400&maptype=roadmap&format=png&markers=loc:#{lat}+#{lon}"
      res.send "http://maps.google.com/maps?z=15&t=m&q=loc:#{lat}+#{lon}"
      reverse_geo_code lat, lon, (location) ->
        res.send "〒#{location.postal} #{location.prefecture}#{location.city}#{location.town}（#{location.city_kana}#{location.town_kana}）"
