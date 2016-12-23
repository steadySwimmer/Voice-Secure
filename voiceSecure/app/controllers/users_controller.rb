$LOAD_PATH << Rails.root.join('../encrypt_part')
require 'open-uri'
require 'crypt'

class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_filter :authenticate_user! #except: [:index, :show]
  #before_action :authorized_user, only: [:edit, :update, :destroy]
  # GET /users
  # GET /users.json
  def index
    @users = User.not.in(_id: [current_user.id])
       
    if params.key?(:id)
      @another_user = User.find(params[:id])
    else
      @another_user = @users.first
    end

    @from_msg = Message.where({from_email: current_user.email, to_email: @another_user.email})
    @to_msg = Message.where({from_email: @another_user.email, to_email: current_user.email})
    puts @from_msg
    @array = Array.new
    if @from_msg.size > @to_msg.size
      i = 0
      @to_msg.each do |m|
        @array.push(m, @from_msg[i])
        ++i
      end

      (i..@from_msg.size - 1).each do |m|
        @array.push(@from_msg[m])
      end

    else
      i = 0
      @from_msg.each do |m|
        @array.push(m, @to_msg[i])
        ++i
      end

      (i..@to_msg.size - 1).each do |m|
        @array.push(@to_msg[m])
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    #@user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /record
  def record 
    puts 'Record'
    if params.key?(:voice) 
      audio = params[:voice]
      msg_ref = save_file audio

      @another_user = User.find(params[:user])
      msg = Message.create(from_email: current_user.email, to_email: @another_user.email, msg_ref: msg_ref)
      redirect_to :controller => "users" , :action => 'index'
    else 
      puts params[:url]
      crypt_file_path = params[:url]

      audioURL = Crypt.decrypt crypt_file_path
      puts 'URL %s' %audioURL
      name = audioURL.split('/')[-1]
      
      puts name 
      puts params[:url]

      redirect_to :controller => "users" , :action => 'index', :name => name, :old_name => params[:url], :id => params[:user]
    end
  end

  def save_file (audio_file) 
    begin 
      audio_file.rewind
      my_rand = Random.new
      save_path = Rails.root.join("Encrypted_files/#{my_rand.rand(1..10)}_#{audio_file.original_filename}")

      File.open(save_path, 'wb') do |f|
        f.write audio_file.read
      end

      crypt_file_url = Crypt.encrypt save_path
      File.delete(save_path)
      return crypt_file_url
    rescue Exception => exc 
      puts "Troubles with #{audio_file}; #{exc.message}"
    end
  end

  # GET /get_record
  def get_record
    puts 'Get record'
    puts params[:url]
    # crypt_file_path = params[:url]

    # audioURL = Crypt.decrypt crypt_file_path
    # puts 'URL %s' %audioURL

    # name = audioURL.split('/')[-1]
    # old_name = crypt_file_path.split('/')[-1]
    # puts name 
    # puts old_name

    redirect_to :controller => "users" , :action => 'record'
    # :old_name => old_name
  end

  def take_file 
    # Crypt.decrypt #URL

  end


  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:nickname, :email, :friends)
    end
end
