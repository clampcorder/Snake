class EventHandler
  @@listeners = Hash.new { |hash, key| hash[key] = Array.new }

  def self.publish_event(event_name, context)
    @@listeners[event_name].each do |listener|
      instance, callback_symbol = *listener
      instance.send(callback_symbol, context)
    end
  end

  def self.register_listener(event_name, listener_instance, callback_symbol)
    @@listeners[event_name].append(
      [listener_instance, callback_symbol]
    )
  end
end