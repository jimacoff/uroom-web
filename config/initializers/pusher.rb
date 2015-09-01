require 'pusher'

Pusher.app_id = ENV['PUSHER_APP_ID']
Pusher.key    = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']

Pusher.app_id = '138893'
Pusher.key    = '87a966498799a786ec56'
Pusher.secret = '22ed03c4fc3c9a1596c0'

Pusher.url = "https://#{ENV['PUSHER_KEY']}:#{ENV['PUSHER_SECRET']}@api.pusherapp.com/apps/138893"

Pusher.logger = Rails.logger
