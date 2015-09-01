require 'pusher'

Pusher.app_id = ENV['PUSHER_APP_ID']
Pusher.key    = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']

Pusher.url = "https://#{ENV['PUSHER_KEY']}:#{ENV['PUSHER_SECRET']}@api.pusherapp.com/apps/138893"

Pusher.logger = Rails.logger
