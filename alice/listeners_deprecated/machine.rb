# require 'cinch'

# module Alice

#   module Listeners

#     class Machine

#       include Cinch::Plugin

#       match /^\!catalog$/,      method: :catalog_machines, use_prefix: false
#       match /^\!install (.+)$/, method: :install_machine, use_prefix: false
#       match /^\!use (.+)$/,     method: :use_machine, use_prefix: false

#       def catalog_machines(channel_user)
#         machines = Alice::Machine.all.map(&:name)
#         Alice::Util::Mediator.reply_to(
#           channel_user,
#           "You can !install any of the following: #{machines.to_sentence}."
#         )
#       end

#       def install_machine(channel_user, machine_name)
#         current_user = current_user_from(channel_user)
#         place = Alice::Place.current
#         if machine = Alice::Machine.from(machine_name)
#           if Alice::Util::Mediator.op?(channel_user) || Alice::Util::Randomizer.one_chance_in(4)
#             (place.machines << machine) && place.save
#             Alice::Util::Mediator.reply_to(
#               channel_user,
#               "#{current_user.proper_name} installs a brand new #{machine} for everyone to enjoy."
#             )
#             return
#           else
#             Alice::Util::Mediator.reply_to(
#               channel_user,
#               "#{current_user.proper_name} botches the installation and ends up cluttering up the place with a heap of junk."
#             )
#             return
#           end
#         end
#         Alice::Util::Mediator.reply_to(channel_user, Alice::Util::Randomizer.negative_response)
#       end

#       def use_machine(channel_user, command_phrase)
#         current_user = current_user_from(channel_user)
#         return unless machine = Alice::Machine.from(command_phrase)
#         return unless action_phrase = command_phrase.gsub(/^.+#{machine.name.slice(-5,5)}/i, "").strip
#         Alice::Util::Mediator.reply_to(channel_user, machine.use(action_phrase))
#       end

#     end

#   end

# end
