class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments

    respond_to do |format|
      format.html # デフォルトでindex.html.hamlを描画
      format.json { render json: @comments } # JSONリクエストに応答
    end
  end

  def create
    post = Post.find(params[:post_id])
    @comment = post.comments.build(comment_params)
    @comment.user = current_user
    @comment.save!

    render json: @comment
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
