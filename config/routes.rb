Rails.application.routes.draw do

  root 'posts#index'

  constraints ValidSortOrder do

    devise_for :users
    resources :users do
      member do
        get 'posts(/:sortby)' => 'posts#user_posts', :as => :user_posts
        get 'favourites(/:sortby)' => 'posts#user_favourites', :as => :user_favourites
        get :admin_edit
        patch :admin_update
      end
    end

    resources :categories, :path => 'slackegory', param: :slug, :except => :show do
      member do
        get 'subscribe' => 'categories#subscribe'
        get 'unsubscribe' => 'categories#unsubscribe'
      end
    end
    get 'slackegory/:slug(/:sortby)' => 'posts#category', as: :category_posts



    get 'subscriptions/(:sortby)' => 'posts#subscriptions', :as => :subscriptions_posts
    
    resources :posts, :path => '/' do
      member do
        get 'upvote' => 'posts#upvote'
        get 'downvote' => 'posts#downvote'

        get 'favour' => 'posts#favour'
        get 'unfavour' => 'posts#unfavour'

        # DELETE is actually not very cruddy/resty for marking it as such, but makes it look like an actuall delete
        delete 'delete' => 'posts#mark_as_deleted'
      end
      collection do
        get '(:sortby)' => 'posts#index', :as => :sorted
      end
      resources :comments
    end
  end # ValidSortOrderConstraint

  authenticate :user, lambda { |u| u.admin? } do
    scope "/admin" do
      get 'posts/deleted' => 'posts#index_deleted', :as => :index_deleted
      mount PgHero::Engine, at: "pghero"
    end
  end






end
