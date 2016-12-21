$LOAD_PATH << '/Users/ivan/Developer/Voice-secure/encrypt_part'
require 'open-uri'
require 'test'

class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_filter :authenticate_user! #except: [:index, :show]
  #before_action :authorized_user, only: [:edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    puts 'HEEEYY!!'
    @users = User.all
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
    audio = params[:voice]
    
    save_path = ("/Users/ivan/Desktop/#{audio.original_filename}")

    audio.rewind

    File.open(save_path, 'wb') do |f|
      f.write audio.read
    end
    result = Test.encrypt_mp3_file(save_path)
    File.delete(save_path)
    
    my_rand = Random.new
    new_save_path = "/Users/ivan/Developer/Voice-Secure/voiceSecure/Encrypted_files/" + "%d" % my_rand.rand(0..100)
    puts new_save_path

    new_file = File.open(new_save_path, "wb")
    new_file.puts(result)
    new_file.close()

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
