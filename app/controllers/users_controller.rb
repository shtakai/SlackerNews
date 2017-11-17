class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy, :admin_edit, :admin_update]

    def show
        @posts = @user.posts.last(5).reverse
        @favoured_posts = @user.favourites.last(5).reverse
    end

    def index
        @users = User.all
    end

    def edit
        authorize! :update, @user
    end


    def update
        authorize! :update, @user
        respond_to do |format|
          if @user.update(user_params)
            format.html { redirect_to @user, notice: 'user was successfully updated.' }
            format.json { render :show, status: :ok, location: @user }
          else
            format.html { render :edit }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
    end

    # A user can edit himself, therefore make own actions and rotes for the admin actions
    # instead of making an own route for each action (promote, confirm...) put them in one admin action
    def admin_edit
        authorize! :admin_update, @user
    end

    def admin_update
        authorize! :admin_update, @user
        respond_to do |format|
          if @user.update(admin_user_params)
            format.html { redirect_to @user, notice: 'user was successfully updated.' }
            format.json { render :show, status: :ok, location: @user }
          else
            format.html { render :edit }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
    end


    def destroy
        authorize! :update, @user
        @user.destroy
        respond_to do |format|
            format.html { redirect_to users_url, notice: 'user was successfully destroyed.' }
            format.json { head :no_content }
        end
    end


    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name)
    end
    def admin_user_params
      params.require(:user).permit(:approved, :role)
    end
end
