$LOAD_PATH << '/Users/ivan/Developer/Voice-secure/encrypt_part'
require 'test'

puts 'Required'

tmp = Test.encrypt('rec.wav')

crp = 'crp2'

new_file = File.open(crp, "w+")
new_file.puts(tmp)
new_file.close()

nfile = File.open(crp, 'r+')
result = ""
nfile.each {|line| result += line}
nfile.close()

Test.decrypt(result, 'new_rec.wav')
