class UsersController < ApplicationController
  def index
  end

  def show
    url = "https://api.github.com/users/#{params[:user]}/repos"

    begin
      if APICache.store.exists?(url)
        repos = APICache.store.get(url).force_encoding('UTF-8')
      else
        repos = APICache.get(url)
        APICache.store.set(url, repos)
      end

      @user = params[:user]
      @user_repos = repos.as_json
    rescue APICache::APICacheError => error
      @error = error
    end
  end
end
