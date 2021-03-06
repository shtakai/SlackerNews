class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :subscribe, :unsubscribe, :edit, :update]

  before_action :authenticate_user!, except: [:show, :index]

  def index
    if request.params[:search]
      @categories = Category.search(request.params[:search]).order(name: :asc).page(params[:page] ? params[:page] : 1)
    else
      @categories = Category.all.order(name: :asc).page(params[:page] ? params[:page] : 1)
    end
  end

  # def show
  #   # @categories = Category.all
  #   render :controller => 'posts_controller', :action => 'index'
  # end

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
    if !@category.subscribed(current_user) && @category.subscribe(current_user)
      redirect_to @category, notice: 'Successfully subscribed.'
    else
      redirect_to @category, notice: 'Could not subscribe.'
    end
  end

  def unsubscribe
    if @category.subscribed(current_user) && @category.unsubscribe(current_user)
      redirect_to @category, notice: 'Successfully unsubscribed.'
    else
      redirect_to @category, notice: 'Could not unsubscribe.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find_by_slug(params[:slug])
    end

    def category_params
      params.require(:category).permit(:name, :desc, :slug, :parent_category_id)
    end
end
