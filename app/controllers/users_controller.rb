class UsersController < ApplicationController
  def index
  end

  def show
    github = Github::Client::Repos.new

    begin
      repos = github.list(user: params[:user])
      .sort_by { |k| k["stargazers_count"] }
      .reverse
      .map.with_index { |x,i| if i < 5 then x end }

      @user = params[:user]
      @user_repos = repos.as_json
    rescue

    end
  end
end
