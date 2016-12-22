require 'openssl'
require 'base64'

module Crypt 

    KEY = "0dfmkl41n1409glmh5phm159uh15h15h15i91gd"
    ALGORITHM = 'AES-128-ECB'

    def Crypt.encrypt(file) 
        begin 
            file = File.open(file, 'rb')
            audio_string = ''
            file.each { |line| audio_string += line}
            file.close()
            
            cipher = OpenSSL::Cipher.new(ALGORITHM)
            cipher.encrypt()
            cipher.key = KEY
            crypt = cipher.update(audio_string) + cipher.final()
            crypt_string = (Base64.encode64(crypt))
            
            my_rand = Random.new
            file_name = "Encrypted_files/crypt#{my_rand.rand(1..100000000000)}"
            #file_name = "crypt#{my_rand.rand(1..100000000000)}"
            file = File.open(file_name, "wb")
            file.puts(crypt_string)
            file.close()

            return File.absolute_path(file_name)
        rescue Exception => exc
            puts ("Message for the #{audio_string} = #{exc.message}")
        end
    end 
    
    def Crypt.decrypt(crypt_file)
        begin 
            nfile = File.open(crypt_file, "rb")
            msg = ''
            nfile.each {|line| msg += line}
            nfile.close()

            cipher = OpenSSL::Cipher.new(ALGORITHM)
            cipher.decrypt()
            cipher.key = KEY
            tempkey = Base64.decode64(msg)
            crypt = cipher.update(tempkey)
            crypt << cipher.final()

            my_rand = Random.new
            file_name = "Encrypted_files/audio#{my_rand.rand(1..1000000000000)}.wav"
            #file_name = "audio#{my_rand.rand(1..1000000000000)}.wav"
            new_file = File.open(file_name, 'wb')
            new_file.puts(crypt)
            new_file.close()
            
            return file_name
        rescue Exception => exc
            puts ("Message for decryption #{msg} = #{exc.message}")
        end
    end
end
