class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :upvote, :downvote, :favour, :unfavour, :mark_as_deleted]
  before_action :load_categories
  before_action :set_user, only: [:user_posts, :user_favourites]
  before_filter :authenticate_user!, :except => [:show, :index, :user_posts]  

  # GET /posts
  # GET /posts.json
  def index
    @posts = paginate(sort(Post.all))
  end

  def index_deleted
    authorize! :manage, Post
    # magic number 2 stands for deleted
    @posts = paginate(sort(Post.unscoped.where(status_cd: 2)))
  end


  # Probably deprecated. /categories/:id/posts user for now 
  def category
    @category = Category.find_by_slug!(params[:slug])
    @posts = paginate(sort(@category.posts))
    render 'index'
  end


  def subscriptions
    # According to this so-post, this variant is way quicker
    # https://stackoverflow.com/questions/3941945/array-include-any-value-from-another-array
    @posts = paginate(sort(Post.all))
    @posts = @posts.select{|p| p.categories.any? {|c| current_user.subscriptions.include? c }}
    # @posts = Post.all.select{|p| current_user.subscriptions.include? p.category}
    render 'index'
  end

  # all posts of a specific user
  def user_posts
    @posts = paginate(sort(@user.posts))
  end

  def user_favourites
    @posts = paginate(sort(@user.favourites))
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @comment = Comment.new
  end

  # GET /posts/new
  def new
    # if this comes from within a category, directly preselect that
    if request.params[:slackegory]
      begin
        @category = Category.find(request.params[:slackegory].to_i)
        # integer conversion returns 0 if the string does not make sense, so no need to catch anything for that
      rescue ActiveRecord::RecordNotFound => e
        # nothing has to be done here, @category just stays empty
        # probable a funny internet kid trying to exploit our roues
      end
    end
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

  def mark_as_deleted
    # if a user "deletes" a post, it is only marked like this, so that admins have an overview over deleted posts
    authorize! :update, @post
    @post.status = :deleted
    if @post.save
      flash[:notice] = 'Post was successfully deleted.'
      redirect_to current_user
    else
      flash[:alert] = 'Something went wrong :/'
      redirect_to @post
    end
  end


  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    # only admins can actually delete. This is not present in the ui yet.
    # other users will only be able to mark them as deleted
    authorize! :manage, @post
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

    def load_categories
      @categories = Category.all
    end

    def sort(posts)
      case params[:sortby]
        when 'hot' then posts.hot
        when 'best' then posts.best
        when 'newest' then posts.newest
        else posts.newest
      end
    end

    def paginate(posts)
      posts.page(params[:page] ? params[:page] : 1)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :url, :description, :status, :category_ids => [])
    end
end
