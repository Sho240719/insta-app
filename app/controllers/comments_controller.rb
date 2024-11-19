class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.find(params[:post_id])
    comments = @post.comments.includes(:user)

    respond_to do |format|
      format.html # デフォルトでindex.html.hamlを描画
      format.json {
        render json: comments.as_json(include: { user: { only: [:id, :account_name] } })
      } # JSONリクエストに応答
    end
  end

  def create
    post = Post.find(params[:post_id])
    @comment = post.comments.build(comment_params)
    @comment.user = current_user
    @comment.save!

    render json: @comment.as_json(include: { user: { only: [:id, :account_name] } })
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
