class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :upvote, :downvote, :favour, :unfavour]
  before_action :set_user, only: [:user_posts, :user_favourites]
  before_filter :authenticate_user!, :except => [:show, :index, :user_posts]  

  # GET /posts
  # GET /posts.json
  def index
    @categories = Category.all
    if params[:search]
      @posts = Post.title_contains(params[:search])
    else
      @posts = Post.all
    end

    @posts = @posts.order(created_at: :desc)
  end


  # Probably deprecated. /categories/:id/posts user for now 
  def category
    @categories = Category.all
    @cat = Category.find(params[:cat])
    @posts = @cat.posts.order(created_at: :desc)
    render 'index'
  end

  def index_hot
    @categories = Category.all
    @posts = Post.order(heat: :desc)
    render 'index'
  end

  def index_best
    @categories = Category.all
    @posts = Post.order(vote_cache: :desc)
    render 'index'
  end

  def subscriptions
    @categories = Category.all
    # According to this so-post, this cariant is way quicker
    # https://stackoverflow.com/questions/3941945/array-include-any-value-from-another-array
    @posts = Post.all.select{|p| p.categories.any? {|c| current_user.subscriptions.include? c }}
    # @posts = Post.all.select{|p| current_user.subscriptions.include? p.category}
    render 'index'
  end

  # all posts of a specific user
  def user_posts
    @posts = @user.posts
  end

  def user_favourites
    @posts = @user.favourites
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @comment = Comment.new
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    authorize! :update, @post
  end

  def favour
    if not @post.favoured(current_user)
      if @post.favour(current_user)
        redirect_to @post, notice: 'Successfully favoured.'
      else
        redirect_to @post, notice: 'Could not favour.'
      end
    else
      redirect_to @post, notice: 'Could not favour.'
    end
  end

  def unfavour
    if @post.favoured(current_user)
      if @post.unfavour(current_user)
        redirect_to @post, notice: 'Successfully unfavoured.'
      else
        redirect_to @post, notice: 'Could not unfavour.'
      end
    else
      redirect_to @post, notice: 'Could not unfavour.'
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user


    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    authorize! :update, @post
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    authorize! :update, @post
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    @post.vote(current_user, 1)
    redirect_to(:back)
  end

  def downvote
    @post.vote(current_user, -1)
    redirect_to(:back)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :url, :search, :category_ids => [])
    end
end
