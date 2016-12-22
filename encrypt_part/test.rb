require 'securerandom'
require 'encryptor'

module Test
	SECRET_KEY = SecureRandom.random_bytes(32)
	IV = SecureRandom.random_bytes(12) 

	def Test.encrypt(name)
		file = File.open(name, "r:ASCII-8BIT")
		result = ""
		file.each { |line| result += line}
		file.close()
		puts 'Going to encrypt'
		encrypted_value = Encryptor.encrypt(value: result, key: SECRET_KEY, iv: IV)
		puts 'Encrypted'
		return encrypted_value
	end 

	def Test.decrypt(encrypted_file, new_name)     
		puts 'Going to decrypt'
		decrypted_value = Encryptor.decrypt(value: encrypted_file, key: SECRET_KEY, iv: IV)
		new_file = File.open(new_name, "w:ASCII-8BIT")
		new_file.puts(decrypted_value)
		new_file.close()
		puts 'Decrypted'
	end

end 



# file_name = "test.mp3"
# decrypted_file_name = "result.mp3"

# encryption_result = encrypt_mp3_file(file_name, secret_key, iv)

# decrypt_mp3_file(encryption_result, decrypted_file_name, secret_key, iv)

