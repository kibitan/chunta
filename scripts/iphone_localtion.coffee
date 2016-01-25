iPhoneFinder = require('iphone-finder')
moment = require("moment")

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
  robot.respond /(.*)？/i, (res) ->
    switch res.match[1]
      when "ちか" then icloud = iCloud.chika
      when "さと" then icloud = iCloud.sato
      else return
    iphone icloud, (device) ->
      lat = device.location.latitude
      lon = device.location.longitude
      date = moment( new Date(device.location.timeStamp) )
      res.reply date.format("YYYY年MM月DD日 HH時mm分ss秒の場所")
      res.reply "http://maps.google.com/maps/api/staticmap?size=400x400&maptype=roadmap&format=png&markers=loc:#{lat}+#{lon}"
      res.reply "http://maps.google.com/maps?z=15&t=m&q=loc:#{lat}+#{lon}"
