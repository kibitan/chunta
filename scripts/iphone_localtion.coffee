iPhoneFinder = require('iphone-finder')
moment       = require('moment-timezone')
sleep        = require('sleep-async')
moment.locale('ja')
moment.tz.setDefault('Asia/Tokyo')

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

module.exports = (robot) ->
  reverse_geo_code = (lat, lon, callback) ->
    robot.http("http://geoapi.heartrails.com/api/json?method=searchByGeoLocation&x=#{lon}&y=#{lat}")
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        nearest_location = JSON.parse(body).response.location[0]
        callback(nearest_location)

  iphone = (icloud, callback) ->
    iPhoneFinder.findAllDevices icloud.user, icloud.pass, (err, devices) ->
      for device in devices
        return callback(err, device) if device.modelDisplayName == 'iPhone'

  max_attempt_count = 5
  response_iphone_location = (icloud, res, attempt_count=0) ->
    if attempt_count >= max_attempt_count
      return res.send "エラーだっち:cry: もう一回!:muscle:"
    iphone icloud, (err, device) ->
      lat = device.location.latitude
      lon = device.location.longitude
      timestamp = moment( device.location.timeStamp )
      elapsed_seconds = moment( new Date ).unix() - timestamp.unix()
      device.location = null

      if !device.location? or elapsed_seconds >= 60 * 5
        res.send 'o(=・ω・=o)=3=3=3=3=3=3'
        sleep().sleep 2000, ->
          # 再帰的呼び出し
          response_iphone_location(icloud, res, attempt_count+1)
      else
        res.send "http://maps.google.com/maps/api/staticmap?size=400x400&maptype=roadmap&format=png&markers=loc:#{lat}+#{lon}"
        res.send "http://maps.google.com/maps?z=15&t=m&q=loc:#{lat}+#{lon}"
        res.send "#{timestamp.format('LTS')}時点（#{elapsed_seconds}秒前）"
        reverse_geo_code lat, lon, (location) ->
          res.send "〒#{location.postal} #{location.prefecture}#{location.city}#{location.town}（#{location.city_kana}#{location.town_kana}）"

  robot.respond /(.*)？/i, (res) ->
    switch res.match[1]
      when "ちか" then res.send 'ちかちゅはいま〜:trollface:'; icloud = iCloud.chika
      when "さと" then res.send 'さとちゅはいま〜:eyes:'; icloud = iCloud.sato
      else return
    response_iphone_location(icloud, res)
