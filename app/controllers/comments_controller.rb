class CommentsController < ApplicationController
  # POST /comments
  # POST /comments.json
  def create
    @article = Article.find params[:article_id]
    @comment = @article.comments.new comment_params

    respond_to do |format|
      format.js do
        if @comment.save
          render :create
        else
          render :new
        end
      end
    end
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).
      permit(:name, :email, :website, :body)
  end
end
