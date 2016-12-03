require 'securerandom'
require 'encryptor'

def encrypt_mp3_file(name, key, iv)
    file = File.open(name, "r")
    result = ""

    file.each { |line| result += line}
    file.close()
    encrypted_value = Encryptor.encrypt(value: result, key: key, iv: iv)

    return encrypted_value
end 

def decrypt_mp3_file(encrypted_file, new_name, key, iv)     
    decrypted_value = Encryptor.decrypt(value: encrypted_file, key: key, iv: iv)
    new_file = File.open(new_name, "w+")
    new_file.puts(decrypted_value)
end

secret_key = SecureRandom.random_bytes(32)
iv = SecureRandom.random_bytes(12) 

file_name = "test.mp3"
decrypted_file_name = "result.mp3"

encryption_result = encrypt_mp3_file(file_name, secret_key, iv)

decrypt_mp3_file(encryption_result, decrypted_file_name, secret_key, iv)

