class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new]

  def index
    @posts = Post.all
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: '投稿しました'
    else
      flash.now[:error] = '投稿できませんでした'
      render :new
    end
  end

  private
  def post_params
    params.require(:post).permit(:content, images: [])
  end
end
