class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
    post = Post.find(params[:post_id])
    @comment = post.comments.buid(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to post_comments_path(post), notice: 'コメントを投稿しました'
    else
      flash.now[:error] = 'コメントをとうこうできませんでした'
      render :index
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
