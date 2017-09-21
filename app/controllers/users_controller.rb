class UsersController < ApplicationController
  def index
  end

  def show
    github = Github.new

    @user_repos = github.repos.list(user: params[:user])
    .map.with_index { |x,i| if i < 5 then x end }

    @user = params[:user]
    @user_repos = @user_repos.as_json
  end
end
