module Api
  module V1
    class UsersController < ApplicationController
      before_action :logged_in_user, only: %i[index edit update destroy]
      before_action :correct_user,   only: %i[edit update]
      before_action :admin_user,     only: [:destroy]

      def index
        @users = User.all
        render json: { users: @users }, status: :ok
      end

      def show
        @user = User.find(params[:id])
        render json: { user: @user }, status: :ok
      end

      def new
        @user = User.new
        render json: { user: @user }, status: :ok
      end

      def create
        @user = User.new(params[user_params])
        if @user.save
          log_in @user
          redirect_back @user
        else
          render 'new'
        end
      end

      def edit
        @user = User.find(@params[:id])
      end

      def update
        @user = User.find(@params[:id])
        if @user.save
          redirect_to @user
        else
          render 'edit'
        end
      end

      def destroy
        User.find(params[id]).destroy
        redirect_to api_v1_users_url
      end

      private

      # Strong Parameters
      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      # ログイン済みユーザーがどうか確認
      def logged_in_user
        unless logged_in?
          store_location
          redirect_to api_v1_login_url
        end
      end

      # 正しいユーザーかどうか確認
      def correct_user
        @user = User.find(params[id])
        redirect_to(root_url) unless current_user?(@user)
      end

      # 管理者かどうか
      def admin_user
        redirect_to(root_url) unless current_user.admin?
      end
    end
  end
end
