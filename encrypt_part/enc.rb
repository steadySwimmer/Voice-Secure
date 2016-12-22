$LOAD_PATH << '/Users/ivan/Developer/Voice-secure/encrypt_part'
require 'test'
require 'crypt'

tmp = Crypt.encrypt 'rec2.wav'
puts 'crypt'

puts 'result' 

audio = Crypt.decrypt tmp
puts audio
