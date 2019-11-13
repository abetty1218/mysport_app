class StaticPagesController < ApplicationController
  
  def home
    
    if logged_in?
      
      @micropost = current_user.microposts.build
      
      if params[:q] && params[:q].reject { |key, value| value.blank? }.present?
      
        @q = current_user.feed.ransack(home_search_params)
 
        @feed_items = @q.result.paginate(page: params[:page])

      else
      
        @q = current_user.feed.ransack()
      
        @feed_items = current_user.feed.paginate(page: params[:page])
          
      end
      
    end  
      
  end
  
  def link
    
  end

  def help
    
  end
  
  def about
    
  end
  
  def contact
    
  end
  
  private
    def home_search_params
      params.require(:q).permit(:content_cont)
    end
  
end
