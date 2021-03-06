class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def new
    @user = User.new
  end
  
  def index
    
    if params[:q] && params[:q].reject { |key, value| value.blank? }.present?
      @q = User.ransack(user_search_params, activated_true: true)
    else
      @q = User.ransack(activated_true: true)
    end
    
     @users = @q.result.paginate(page: params[:page])
    
    #@users = User.where(activated: true).paginate(pag@users = @q.result.paginate(page: params[:page]): params[:page])
  end
  
  def show
    
    @user = User.find(params[:id])
    
    if params[:q] && params[:q].reject { |key, value| value.blank? }.present?
      
      @q = @user.microposts.ransack(micropost_search_params)
      
      @microposts = @q.result.paginate(page: params[:page])
      
    else
      
      @q = @user.microposts.ransack()
      
      @microposts = @user.microposts.paginate(page: params[:page])
      
    end
     
    #@microposts = @user.microposts.paginate(page: params[:page])
    
    redirect_to root_url and return unless @user.activated?
  end
  
  def create
    @user = User.new(user_params)    # 実装は終わっていないことに注意!
    if @user.save
       @user.send_activation_email
       flash[:info] = "アカウントを有効化するため、メールをチェックしてください。"
       redirect_to root_url
      
       #log_in @user
       #flash[:success] = "Welcome to the Sample App!"
       #redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを編集しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーデータを消去しました。"
    redirect_to users_url
  end

  def following
    @my_title = "follow"
    @title = "フォロー"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @my_title = "follower"
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end



  private
    def user_params
        params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
    end
    
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインして下さい。"
        redirect_to login_url
      end
    end
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    def user_search_params
      params.require(:q).permit(:name_cont)
    end
    
    def micropost_search_params
      params.require(:q).permit(:content_cont)
    end
    
end
