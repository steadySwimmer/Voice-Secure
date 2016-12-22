$LOAD_PATH << '/Users/ivan/Developer/Voice-secure/encrypt_part'
require 'test'
require 'json'

puts 'Required'

tmp = Test.encrypt('rec.wav')

puts tmp.is_a? String
puts tmp.class
crp = 'crp2.txt'

new_file = File.open(crp, "w+")
new_file.puts(tmp)
new_file.close()

nfile = File.open(crp, 'r+')
result = nfile.read

nfile.close()


Test.decrypt(result, 'new_rec.wav')
