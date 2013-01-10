class EventObserver < ActiveRecord::Observer

  observe :event

  HIPCHAT = HipChat::API.new(Gitlab.config.notifications.hipchat_api_key)

  puts "EValuating"

  def after_save(event)
    puts "SAve event"
    `echo 'yousucksave' >> YOU_SUCK.what`
  end

  def after_create(event)
    `echo 'yousuckcreate' >> YOU_SUCK.what`
    puts "Create event"
    if event.project && !event.project.hipchat_room_id.blank?
      puts "Event #{event.inspect}"
      HIPCHAT.rooms_message(event.project.hipchat_room_id, 'Gitlab', event.title, 1, 'blue')
    end
  rescue
    puts $!.message
    puts $!.backtrace.join('\n')
  end

end
