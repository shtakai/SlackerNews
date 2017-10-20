class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :subscribe, :unsubscribe, :edit, :update]

  def index
    @categories = Category.all.order(name: :asc)
    
  end

  def show
    @posts = @category.posts.order(created_at: :desc)
  end

  def new
    @category = Category.new
  end

  def edit
    authorize! :update, @category
  end

  def update
    authorize! :update, @category
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: 'category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @category = Category.new(category_params)
    @category.user = current_user


    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def subscribe
    if not @category.subscribed(current_user)
      if @category.subscribe(current_user)
        redirect_to @category, notice: 'Successfully subscribed.'
      else
        redirect_to @category, notice: 'Could not subscribe.'
      end
    else
      redirect_to @category, notice: 'Could not subscribe.'
    end
  end

  def unsubscribe
    if @category.subscribed(current_user)
      if @category.unsubscribe(current_user)
        redirect_to @category, notice: 'Successfully unsubscribed.'
      else
        redirect_to @category, notice: 'Could not unsubscribe.'
      end
    else
      redirect_to @category, notice: 'Could not unsubscribe.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :desc, :slug, :parent_category_id)
    end
end
